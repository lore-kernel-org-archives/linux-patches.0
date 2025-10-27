Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5561EA7DF;
	Mon, 27 Oct 2025 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590708; cv=none; b=cbujhR+zmG3l+8l0SI1/usP39vNqMvnDph6EHaYxEHF3ScKwQ/Zptl7n68x+yKobsVaLg/UFTJtHSLGVyM2byakMrDEuAQkoQgeSiVT4sd2DpRc0wJQhga0p8xzQKCVk3vRV5CPS5St+Nm0k4QMHEt32cA1ESMOltifA+0X7bOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590708; c=relaxed/simple;
	bh=GxzU/N1HDmHka/MuZrB6l9qqD6Kfpyj4JMxpV8Bej/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaFkQGFys+GNxpZeAWKHZCSnU3MXkE0wR1kPLGOXBQFPsl/bvnrJD8ZTjEYsaSpQPkxL2YaHGcTI5WdxGPG7ey3KWlVFxlgZVa34HEsoHOXe3jvouFWKwJPgXx1OVqK+IrLN9Dnk2GGeTCSVpG6R7tQtFsVApv+e5WiBC5M4+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0AZn2ou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0AZn2ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094FEC4CEF1;
	Mon, 27 Oct 2025 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590708;
	bh=GxzU/N1HDmHka/MuZrB6l9qqD6Kfpyj4JMxpV8Bej/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0AZn2ouk2CZ+VqWVais93Eo/xNTS/FEufX4VbD/A9IOf9ctcWf49f+28hA0y8Vji
	 d5rDMAZp+wNMSIn+6fGw9+RlhrlMWhxDCQMaT094qAWSf4txhy6C+4JwEBLmlMamZy
	 dUKgg+a3rtm6a/3byWJmDDEZUMHHR/6t7GSWPkuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/224] xen/events: Cleanup find_virq() return codes
Date: Mon, 27 Oct 2025 19:34:54 +0100
Message-ID: <20251027183512.929635929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 08df2d7dd4ab2db8a172d824cda7872d5eca460a ]

rc is overwritten by the evtchn_status hypercall in each iteration, so
the return value will be whatever the last iteration is.  This could
incorrectly return success even if the event channel was not found.
Change to an explicit -ENOENT for an un-found virq and return 0 on a
successful match.

Fixes: 62cc5fc7b2e0 ("xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250828003604.8949-2-jason.andryuk@amd.com>
[ converted evtchn pointer output parameter to direct port return value ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1210,10 +1210,12 @@ EXPORT_SYMBOL_GPL(bind_interdomain_evtch
 static int find_virq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_status status;
-	int port, rc = -ENOENT;
+	int port;
 
 	memset(&status, 0, sizeof(status));
 	for (port = 0; port < xen_evtchn_max_channels(); port++) {
+		int rc;
+
 		status.dom = DOMID_SELF;
 		status.port = port;
 		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
@@ -1221,12 +1223,10 @@ static int find_virq(unsigned int virq,
 			continue;
 		if (status.status != EVTCHNSTAT_virq)
 			continue;
-		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu)) {
-			rc = port;
-			break;
-		}
+		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu))
+			return port;
 	}
-	return rc;
+	return -ENOENT;
 }
 
 /**


