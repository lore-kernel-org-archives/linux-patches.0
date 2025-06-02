Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111B923D284;
	Mon,  2 Jun 2025 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875848; cv=none; b=aDGP2cjyOAX2vJ+Q1rpJDy2Ff9/mX2blHLFNm/go0W04cyY2WL18x7rbI5gESvoqWFFpT4lh++TgCrYaA/gdb/XiA7AofocMaXTPgXRmz1xnNY2iqf9zyVh13P7297oES8f3kifFKpw6z6sfKmx4M67Ji6clKKdL9FzzcTaIAXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875848; c=relaxed/simple;
	bh=m3h9h57rChFBwSBZo/wWFfeQ0pnng/EpwENnG2rUsXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXYuqZH6RfbLfvxbEDrELH1wSGatomkO23aHJruj7XEtAaSaWKNrmwgg9cH+t6CjN0V59HaQAUP3+1ZVLR603Gs3HmyynBDMJF6xhb3pKeXhGfuoTpSSpRvD1oZ1fPmPqxRwS6TZ4jtmrjgc3YN2Hs9XW3xP7GiybJutU9eUeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwFBhFJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwFBhFJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C8C4CEEB;
	Mon,  2 Jun 2025 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875847;
	bh=m3h9h57rChFBwSBZo/wWFfeQ0pnng/EpwENnG2rUsXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwFBhFJ3tl4BAEGu6+4rpiZvu2saAOSLU2UjgM+CgJNYW9wTE6eWe8zv0OJ7c7syv
	 DO9KmMrdbk0A/JEcs+YuOGuLvAd6Ur9P2eHK3V8XdTHVLnxxrmEH+Y/Fz8BPZH7gS8
	 veelcordf712yk/R0jpW7b18FnRTQa44hu+OhW0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/270] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon,  2 Jun 2025 15:48:38 +0200
Message-ID: <20250602134316.833790714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 90989869baae47ee2aa3bcb6f6eb9fbbe4287958 ]

Make xenbus_init() allow a non-local xenstore for a PVH dom0 - it is
currently forced to XS_LOCAL.  With Hyperlaunch booting dom0 and a
xenstore stubdom, dom0 can be handled as a regular XS_HVM following the
late init path.

Ideally we'd drop the use of xen_initial_domain() and just check for the
event channel instead.  However, ARM has a xen,enhanced no-xenstore
mode, where the event channel and PFN would both be 0.  Retain the
xen_initial_domain() check, and use that for an additional check when
the event channel is 0.

Check the full 64bit HVM_PARAM_STORE_EVTCHN value to catch the off
chance that high bits are set for the 32bit event channel.

Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Change-Id: I5506da42e4c6b8e85079fefb2f193c8de17c7437
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250506204456.5220-1-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 743795d402cb0..fb5358a738204 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -864,9 +864,15 @@ static int __init xenbus_init(void)
 	if (xen_pv_domain())
 		xen_store_domain_type = XS_PV;
 	if (xen_hvm_domain())
+	{
 		xen_store_domain_type = XS_HVM;
-	if (xen_hvm_domain() && xen_initial_domain())
-		xen_store_domain_type = XS_LOCAL;
+		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
+		if (err)
+			goto out_error;
+		xen_store_evtchn = (int)v;
+		if (!v && xen_initial_domain())
+			xen_store_domain_type = XS_LOCAL;
+	}
 	if (xen_pv_domain() && !xen_start_info->store_evtchn)
 		xen_store_domain_type = XS_LOCAL;
 	if (xen_pv_domain() && xen_start_info->store_evtchn)
@@ -885,10 +891,6 @@ static int __init xenbus_init(void)
 		xen_store_interface = gfn_to_virt(xen_store_gfn);
 		break;
 	case XS_HVM:
-		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
-		if (err)
-			goto out_error;
-		xen_store_evtchn = (int)v;
 		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
 		if (err)
 			goto out_error;
-- 
2.39.5



