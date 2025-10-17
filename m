Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A58E336EE7;
	Fri, 17 Oct 2025 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714359; cv=none; b=MvnfrmVdyVpE6esbM4Cbje0+P2xGwiT/stRzI43nQTTdUAjW5ryR872lKyRPC2PfUvhNEjFztni5QaUKMglzBafAaV84OKojyNWYifPnoHWCBMf/AJh8vG/fQiW3hQC8zjPkHn1a62yu55UMPkny06aaAOqi/TpdkzebBjYwICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714359; c=relaxed/simple;
	bh=J9bOhnmP6KQ0U61OpFGGcoIlKIuwxpNrHERRAPDmH/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic/2zNhPkxVzGfbNSjE6kRgFmaza49yVo4YXHFllJq+IB6mW4umB/d/rSXyYL6uZiiLUsYDF4SV46c4mGmP7uE5Jd8SB6X18jS0jjmN7FKmZDJZHV4abRmkcKEdmbNzD5JXjjBYjMPgVg7UJY9CILfDnS58Fc0dUUraR2XOFxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4hsfSn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4hsfSn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEAAC4CEE7;
	Fri, 17 Oct 2025 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714358;
	bh=J9bOhnmP6KQ0U61OpFGGcoIlKIuwxpNrHERRAPDmH/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4hsfSn8/vO2NOBtflsPVS1Ln5KjDuTR6nLB7rZozWkune+lgScNV+R/H060tFWQI
	 OJngY7J3g4rwNwS1/2SL0h5ClFOU9N2pRP8ljdEsoUjosYeW8bVofwUTuce/qAvXWe
	 5qjz/9eWPTGoikRCdPfe/+9GATNI8rVPru37GfBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 100/277] xen/events: Return -EEXIST for bound VIRQs
Date: Fri, 17 Oct 2025 16:51:47 +0200
Message-ID: <20251017145150.782545874@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit 07ce121d93a5e5fb2440a24da3dbf408fcee978e upstream.

Change find_virq() to return -EEXIST when a VIRQ is bound to a
different CPU than the one passed in.  With that, remove the BUG_ON()
from bind_virq_to_irq() to propogate the error upwards.

Some VIRQs are per-cpu, but others are per-domain or global.  Those must
be bound to CPU0 and can then migrate elsewhere.  The lookup for
per-domain and global will probably fail when migrated off CPU 0,
especially when the current CPU is tracked.  This now returns -EEXIST
instead of BUG_ON().

A second call to bind a per-domain or global VIRQ is not expected, but
make it non-fatal to avoid trying to look up the irq, since we don't
know which per_cpu(virq_to_irq) it will be in.

Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250828003604.8949-3-jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1320,10 +1320,12 @@ int bind_interdomain_evtchn_to_irq_latee
 }
 EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq_lateeoi);
 
-static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn)
+static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn,
+		     bool percpu)
 {
 	struct evtchn_status status;
 	evtchn_port_t port;
+	bool exists = false;
 
 	memset(&status, 0, sizeof(status));
 	for (port = 0; port < xen_evtchn_max_channels(); port++) {
@@ -1336,12 +1338,16 @@ static int find_virq(unsigned int virq,
 			continue;
 		if (status.status != EVTCHNSTAT_virq)
 			continue;
-		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu)) {
+		if (status.u.virq != virq)
+			continue;
+		if (status.vcpu == xen_vcpu_nr(cpu)) {
 			*evtchn = port;
 			return 0;
+		} else if (!percpu) {
+			exists = true;
 		}
 	}
-	return -ENOENT;
+	return exists ? -EEXIST : -ENOENT;
 }
 
 /**
@@ -1388,8 +1394,11 @@ int bind_virq_to_irq(unsigned int virq,
 			evtchn = bind_virq.port;
 		else {
 			if (ret == -EEXIST)
-				ret = find_virq(virq, cpu, &evtchn);
-			BUG_ON(ret < 0);
+				ret = find_virq(virq, cpu, &evtchn, percpu);
+			if (ret) {
+				__unbind_from_irq(info, info->irq);
+				goto out;
+			}
 		}
 
 		ret = xen_irq_info_virq_setup(info, cpu, evtchn, virq);


