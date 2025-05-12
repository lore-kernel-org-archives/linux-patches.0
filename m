Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4742BE109;
	Mon, 12 May 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073126; cv=none; b=jb/G4RxJvN9JDls2oSPqHm2e32dW6Czm6PtF5PEC7D4/U/PoWvlQo3oPdqvnXKmoN5CNDzDxcVNwk+3ei7A/WxS1Yfi7B+69ZcJH80odMmg8CbeZbZjtsACL7zfj5XwEy2Y2y0PPBselpAuBnc3mhsWSkk3DSv9gRMKWXciLUcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073126; c=relaxed/simple;
	bh=3AksgRRmkoQ6fJIncxndRZkvy/I4Fxh5QPEmqwimDJo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V8S3aYZL2Gxnswg15TmfAcxck37ckDeAmdlr+V31pgubNcALyp5qai1uENom7aOitktnGisrECCuUYLD+LcLpNCh9TGaQm1vOXT5aFfbr5AFM7uCycmNPqQuIu5MflEgNm+jMQqLqVNtiCOBb4HbQaR80Yd70QLdV8CmDeWmrOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPr255rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPr255rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41088C4CEEF;
	Mon, 12 May 2025 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073126;
	bh=3AksgRRmkoQ6fJIncxndRZkvy/I4Fxh5QPEmqwimDJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPr255rBlHWgPuVdnQtKzCGhYS41C3JKflJ0AIgmHnuaLPxtxrkg75Am93zlAQSIp
	 HQWFb+OmaKKb8gQeMAjkFE2AXHBGEzzQIyX01rEv7GxWa56ALaPr563YhN1KcZdYKp
	 XVMLuJRFe175hsPNbv0aRLJow5otDhfGnullY0odgnWA8nGu4r1cXh4BODtSd+MRsi
	 S6pz67JVk0u8SHvVVX6ezMhV6jQRzo2Q8w3dz+gD5pfCchqjNXPNSe6IQ0f/nkMxh4
	 Ktu8BoGVbGJNnLeOmjykWoQtGFAULAo6+ROW6MXsjAPo2BNGNaz6uL3xc5RuloqQIm
	 8OQXiTJA1MetQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	chenqiuji666@gmail.com,
	xin.wang2@amd.com,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/3] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon, 12 May 2025 14:05:17 -0400
Message-Id: <20250512180518.438085-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180518.438085-1-sashal@kernel.org>
References: <20250512180518.438085-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.182
Content-Transfer-Encoding: 8bit

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
index e680bd1adf9c4..2068f83556b78 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -927,9 +927,15 @@ static int __init xenbus_init(void)
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
@@ -948,10 +954,6 @@ static int __init xenbus_init(void)
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

