Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0D330B1E;
	Fri, 17 Oct 2025 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716381; cv=none; b=nSX6ZNBg5hdz3e38f1KPgkHkX/hgxalAYT++eU/BI2Iga8QTp39SnaSsm9AEnzuLS8itQWZyJxFFncovG2lHAF/C96yVmE4tKzMM0hq8pv8Fcmo+XgdFEmPEbdp3BQAOUqTZSKXz6+skPLJijlBz2rvmqLBuMUVx2trhyl7A9kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716381; c=relaxed/simple;
	bh=QPBj88U6r+yN+vUKWdJMa4fdeRJQ1FGbMsukZ0Wgw6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa6tZLO57zgtzrW32p4TVfQ/wVjsXiSKT34efHNmFSgqXIo60AkPh08ipeLCBpGuqneGYd0QKfB2FcXptFvSm/39Kpt1OnRnR48hUMB720ieG4H8/t7JU1QlvGOfF+VP8GjV8T+ssREkg9Dooq8835+6YvCcmo0k/+mz3fYCFBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KItJLihZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KItJLihZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C37C4CEE7;
	Fri, 17 Oct 2025 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716379;
	bh=QPBj88U6r+yN+vUKWdJMa4fdeRJQ1FGbMsukZ0Wgw6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KItJLihZ6c9WQOkOK2N77t3uKpa0h3RI/6ihH0XQ+hR0P+EYl5tz7q9WRE4fOGGjX
	 Q+pVc3QQYlfZIyco/qx+yjwNSDjsh2+9Y237Te/D30V6SihAn/edu+Abd5Ag1bmw2K
	 jorAzECpoNtZxqR9YpT544D1whMYF4YOWVBRTK4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 170/276] xen/events: Cleanup find_virq() return codes
Date: Fri, 17 Oct 2025 16:54:23 +0200
Message-ID: <20251017145148.677668300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit 08df2d7dd4ab2db8a172d824cda7872d5eca460a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1331,10 +1331,11 @@ static int find_virq(unsigned int virq,
 {
 	struct evtchn_status status;
 	evtchn_port_t port;
-	int rc = -ENOENT;
 
 	memset(&status, 0, sizeof(status));
 	for (port = 0; port < xen_evtchn_max_channels(); port++) {
+		int rc;
+
 		status.dom = DOMID_SELF;
 		status.port = port;
 		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
@@ -1344,10 +1345,10 @@ static int find_virq(unsigned int virq,
 			continue;
 		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu)) {
 			*evtchn = port;
-			break;
+			return 0;
 		}
 	}
-	return rc;
+	return -ENOENT;
 }
 
 /**


