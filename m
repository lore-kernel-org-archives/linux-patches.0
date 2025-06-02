Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE4922CBFE;
	Mon,  2 Jun 2025 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877283; cv=none; b=ju15Z3OLNikQG2N9KdKIcPM/uNxPkj+pgsk+trB11iru1hOQTbdGIlG/SSBbqHcAxSrF36xCpT3bguRHSZ/nnXEUk2T2Xm/N1yB+iaCuZmYtq2QwA1AmnTX2X9pny9pf5SvbJLWwYlOQoobklIL81PELPlJIXbP3KamfoTiMiho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877283; c=relaxed/simple;
	bh=NrEtquFJbGJhcdRGZtdV1IHGCc1fkLSf+KjQccdDxuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eddCc31L85XDl9mZce1179CheJ/zdETs0EK/zKyMLq3lk+6fH7QQ8VB8guN/AcBcF4MBQ1a59CQPsUrI6L+FUyNhO7EhV+CuXHQLwtZDs1+VAQrUdERqEovb1IqoQpso3o3WNvCbvlcTVCoObSTNwI2ldLqib9x8/sp8Aee+JbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysVGa9LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysVGa9LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E496C4CEEE;
	Mon,  2 Jun 2025 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877282;
	bh=NrEtquFJbGJhcdRGZtdV1IHGCc1fkLSf+KjQccdDxuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysVGa9LWIt7oBhCjlM0G0K3DhIfHAoLR05whvI2IkoYFNW26iNZU2reaSFG2Y3WGT
	 dgHIhFfeWOp3iS+Jxm79zdkMsk9lY4GHKa6KFwLq89n7XbT+JDiZq9Uz/ZGyOyDYmZ
	 C0KmKLJ3xTvObl7gXux+7dEOY8Ag90zBZ65C30oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/325] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon,  2 Jun 2025 15:48:24 +0200
Message-ID: <20250602134329.047038453@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 25164d56c9d99..d3b6908110c6f 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -966,9 +966,15 @@ static int __init xenbus_init(void)
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
@@ -987,10 +993,6 @@ static int __init xenbus_init(void)
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



