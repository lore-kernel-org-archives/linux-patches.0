Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F16330B30;
	Fri, 17 Oct 2025 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715333; cv=none; b=ma2t7EuqqIjTnUiXHdj0NA5W7s3ADPmeq4D6lgFYyxypMPwpISbTNmw74lVVJQtc5KtkWALUVEVAddtnD3VvuAHLzUtF/rDg9bVavMzBkyNnZfohlJbHkwho/dUuKwnv0RBVUM03bNSTcw44sHxMNwugvCkZmP5IyjPNZ314AFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715333; c=relaxed/simple;
	bh=A8drwjtBWRLj8sldcM6ki0n3qOH/ae7mG3yHNpeVBFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkiFTbXjxhhwfZt0QNr82jcubop1b5j2i4EzYznTszDlccmVeKFZDSpymiZe9HJ2RUFZM1yee1U/nK0kjRhE3fHNGDnixf5iN8rYsPNJ73X5bI2Pf8tG1n7ksIlGJNr8ZwOC8+TiuDhJmo1nlrKdT+sLsA04/8akw5JHlUCODhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkNiC5ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkNiC5ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F00C4CEE7;
	Fri, 17 Oct 2025 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715332;
	bh=A8drwjtBWRLj8sldcM6ki0n3qOH/ae7mG3yHNpeVBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkNiC5maTlye+idtGe/s+4kC94EO4qj1y+xFlDO2cjggMwdNC0LrJwPQeCbwdevtZ
	 tS4PhQ6YNR2otCOkpk8U72gLj6m9auv0qiBwrsFEB0i47E3PUQIcwrFg1yFSezEYwO
	 VfzZwPwEkeVUD0F8GywiCv4XT9k96wRY6usUvq1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.17 162/371] xen/events: Cleanup find_virq() return codes
Date: Fri, 17 Oct 2025 16:52:17 +0200
Message-ID: <20251017145207.794668417@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1318,10 +1318,11 @@ static int find_virq(unsigned int virq,
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
@@ -1331,10 +1332,10 @@ static int find_virq(unsigned int virq,
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


