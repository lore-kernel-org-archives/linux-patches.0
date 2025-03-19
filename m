Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DBA21C18C;
	Wed, 19 Mar 2025 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395129; cv=none; b=XvdLk3kHNlKiDPZR+D+VvIybaYN/eWbvrcqkF4xGp62Ym27VMh7aQlVPT8EXBv4PZMEbXlJrKMJE8knPHYI+FBhoNbndVrVPq37U8xEldxWH7nPWKf0z30TcfuOrdEdCUYFQap6LL3Yi/sxMM823fQYM5ClHg/gDpGeZohQT/XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395129; c=relaxed/simple;
	bh=Ude4ER+MS2PrsUY2BVMcMXub/pPuDQslhLsg8/G1sBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmxtykSMXYbOKYX+YKe2aMaYyipftnSjrW3c3CbPXR3kJjGQKIh6CUklPPjmStjbYmt+pmRiNH2q+C1zlJPxYA19U17MNr3ZjW5ytikcpO2Mc9E8TZ6E9pk1p8jX0FyxbE5L5GM7/KId1V2amxKXombJsk/00cLoP7Lifgt+3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uuqm0bqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uuqm0bqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2141BC4CEE9;
	Wed, 19 Mar 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395129;
	bh=Ude4ER+MS2PrsUY2BVMcMXub/pPuDQslhLsg8/G1sBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uuqm0bqxfKcohGAOu9tQ+0jI9q2Z3OFEvqaWVE031+//m61c4ZA8akKdR9etxruRZ
	 8U9Bq+rp6kGHDylj5KBm7Ve0GHfflW1658bPgsD4VNKbbp9lVqdhHRGjeMkEbNvnH+
	 oY6+D+JUTn8W+UqcSKq0058XyToDAQ5bmFUwrsTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 193/231] qlcnic: fix memory leak issues in qlcnic_sriov_common.c
Date: Wed, 19 Mar 2025 07:31:26 -0700
Message-ID: <20250319143031.609442990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d2b9d97e89c79c95f8b517e4fa43fd100f936acc upstream.

Add qlcnic_sriov_free_vlans() in qlcnic_sriov_alloc_vlans() if
any sriov_vlans fails to be allocated.
Add qlcnic_sriov_free_vlans() to free the memory allocated by
qlcnic_sriov_alloc_vlans() if "sriov->allowed_vlans" fails to
be allocated.

Fixes: 91b7282b613d ("qlcnic: Support VLAN id config.")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250307094952.14874-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -454,8 +454,10 @@ static int qlcnic_sriov_set_guest_vlan_m
 
 	num_vlans = sriov->num_allowed_vlans;
 	sriov->allowed_vlans = kcalloc(num_vlans, sizeof(u16), GFP_KERNEL);
-	if (!sriov->allowed_vlans)
+	if (!sriov->allowed_vlans) {
+		qlcnic_sriov_free_vlans(adapter);
 		return -ENOMEM;
+	}
 
 	vlans = (u16 *)&cmd->rsp.arg[3];
 	for (i = 0; i < num_vlans; i++)
@@ -2167,8 +2169,10 @@ int qlcnic_sriov_alloc_vlans(struct qlcn
 		vf = &sriov->vf_info[i];
 		vf->sriov_vlans = kcalloc(sriov->num_allowed_vlans,
 					  sizeof(*vf->sriov_vlans), GFP_KERNEL);
-		if (!vf->sriov_vlans)
+		if (!vf->sriov_vlans) {
+			qlcnic_sriov_free_vlans(adapter);
 			return -ENOMEM;
+		}
 	}
 
 	return 0;


