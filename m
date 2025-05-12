Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42E29ACDA;
	Mon, 12 May 2025 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073087; cv=none; b=Xo+ZYiSw9kSBkreMnd2j5UK6xAh5lv66vcl0sPRsC9SXdPNiadt7ArzSEOJ7q8RRyYc0U3hcY+VaDsNybde0YBmYupw+N2s8b0y44fej2aL4W2VqgLYjYf6x/MljOxY4TrGB7jZuWNJgQI2DPQ39ARuTxRL0yR+j9a14Ui4Rntk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073087; c=relaxed/simple;
	bh=lCTxzM5mPtEqEUhqg9mBz2nbnDEbWNQdOwqtwsH/FcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qJRWeQ7LCDks61n7imdpMj7RfA7aTm5aPbWtVXrTumzPpOE+8u4Sjme6CoCyJtp/uEm4h7vxdBLm4+zqy5GRblGNWDX37ABHrt4CQxIfQJOeP/RbsybPeDqY0Df62rYWhR8j0V/KNG0n7uLAQtyBKMLmdNj1KiYz63LPqo1nTeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENRtZKMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENRtZKMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BCDC4CEF0;
	Mon, 12 May 2025 18:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073087;
	bh=lCTxzM5mPtEqEUhqg9mBz2nbnDEbWNQdOwqtwsH/FcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENRtZKMXwWza3chzqhxjc8H8mGmRL/Bz1M+Rr6NeobL0kj/Ew6VlWjTIwLk7lPd3p
	 UC0yazS2b+t0Ha0lkfBb3NOOiwRlQMGlDZm1ZkL8XKB/gQoZxh/SJcBSMvZhfQ6dZK
	 DHtUnayTofw+quRQn+/jY0mO0655OXvB1JM0+Tmh1tExm2gudfnWPjw1zwrj0mvNHq
	 ngBI8UAjz/A5c65wJhRnhxClf85ZBKuV49Z80ejI/S43s4oEinsjoHcnU/GDZhK7FJ
	 BlPkQp0ZVdkypn0N02ukbalB6cNmYZy06lG6h8RyjxCdo/1N8f4KaY2SNxYeetGfL+
	 jS5RsK6iQH37Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	chenqiuji666@gmail.com,
	michal.orzel@amd.com,
	xin.wang2@amd.com,
	gregkh@linuxfoundation.org,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 09/11] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon, 12 May 2025 14:04:24 -0400
Message-Id: <20250512180426.437627-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180426.437627-1-sashal@kernel.org>
References: <20250512180426.437627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.28
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
index 6d32ffb011365..86fe6e7790566 100644
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

