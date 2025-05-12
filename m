Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5632BD58B;
	Mon, 12 May 2025 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073117; cv=none; b=QH9WoOsGIH16nOfMjqYaX3fM2OUnvKiwfed+YdBo6KUK0cPeQh/vjvnC1dCQTI7Fb3/P0wo0ZRqsAn1k/ZhE5QSyXr03J7v5577MapckbmTXX5LtTblOKnsNC45+kUAnxfaHoQmDcXdUcJTzlmmW+IfCrumQtB0hgZ4/QXyjwjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073117; c=relaxed/simple;
	bh=CUwTTRBoepiWy3eBVkjtl52xMaizXnQOALV0fmgcrHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hm0m0O+RtjnbZ7i2IgprnRx6D8b1F/CHn6os8WW4X86gR7/5+5z2Q8rIMZjOClIVaTv7lDZ6fJ8EVetiD6HREfNDxvBZoyPQ5UmHfZw4XeD22ISczqWD9DqcAaSxML5PFqwBncup8moup5vyWUNhNHNNYJsldAt63Y6P5wU54cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2irdoKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2irdoKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0911C4CEE7;
	Mon, 12 May 2025 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073117;
	bh=CUwTTRBoepiWy3eBVkjtl52xMaizXnQOALV0fmgcrHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2irdoKQ1ovlV+17jJfSXbJ/8/i+TtLcyIs/53YehDBnIiGP19LFzLEFNphKTK2ea
	 Y4EGjNagxgZ/Sv29nYQi0+XN3qIypZFKOQNs79cPkTTcHNhpXY7/5PoWlWPeyFKlqN
	 dHrF3usEx5yyYf9cuWBFqol1Z0pR6WgLXUg4fYkcBz11Z7Me1OVQBkbWCapGYGbTg1
	 /I4A9LJgqFZwR4b4wfHCqa6NwoRfSrwNUNeryjk17heawIICdtTmvE+yQG8W1rA05W
	 7U862n5/sL5bDZ0N3gk1w8ZwGRkjHwZYSfBDlLgklwVYn2TEkLTfpuLY/UUZLBoQK2
	 e5K0Wh+ZJq/TQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	chenqiuji666@gmail.com,
	elder@kernel.org,
	michal.orzel@amd.com,
	gregkh@linuxfoundation.org,
	xin.wang2@amd.com,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 3/4] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon, 12 May 2025 14:05:06 -0400
Message-Id: <20250512180508.437991-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180508.437991-1-sashal@kernel.org>
References: <20250512180508.437991-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.138
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

