Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890BE2F12D9;
	Fri, 17 Oct 2025 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714427; cv=none; b=n/AbwJz2uk+t9qh+vYcQFni4gQXDCrMVifu7Ly+F/xKkUSKhRQ4B/FcRCQYhMR+YGrzyDspB+qzfgZ3wvgF4cSg73fVk6bF4xxU8tzvd9/xu2fCEeMghSu6DyHBpbEFVcj8zDk0rNBNVW9/yYwMAL2bJ4JwRWItDqlHk9p3sRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714427; c=relaxed/simple;
	bh=juKTQ9g9JoW9rF94aPnJJqC3Jy7T0Rr0xcJ0KiQOC4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlZDlRQix4pvE0L0imB25ut076om93TvMbTcaNiG3XuON57JsjThxEsMAWlYPGen5rEEV1jpoou6Galnxj3QiSHnqhfY7iT8UJjDeMvaEIfN1HH6L4OKmWi9dcrdwY9cVnOr5zC5qrF0DRNxV2va8/RquVdNSConwPm+JA9btlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr8xCgw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr8xCgw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD324C4CEE7;
	Fri, 17 Oct 2025 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714427;
	bh=juKTQ9g9JoW9rF94aPnJJqC3Jy7T0Rr0xcJ0KiQOC4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr8xCgw4cm2eoMHZNXhp2l7N79HmG1Bk4G7lyUgg4PZQQxAP+xvW1EVpb5+nFnRcr
	 sj3dNn01tCq8zNRpWSXsTahjErOyAu+VHB/0MbpKa5/w9+Zf013mrIDIc6nJigRkQS
	 IERZAC7+aqI+ppaCFBBr5VGOo+V7QCSdHI7pyyOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 098/277] xen/events: Cleanup find_virq() return codes
Date: Fri, 17 Oct 2025 16:51:45 +0200
Message-ID: <20251017145150.710093924@linuxfoundation.org>
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
@@ -1324,10 +1324,11 @@ static int find_virq(unsigned int virq,
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
@@ -1337,10 +1338,10 @@ static int find_virq(unsigned int virq,
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


