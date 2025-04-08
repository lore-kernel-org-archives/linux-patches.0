Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C11C267B65;
	Tue,  8 Apr 2025 10:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109792; cv=none; b=achq9HHIYV6IEbM7RFy/8Rvc5ivUFk8BjpYcxDDoPxPsNKdm8kQX1zxDX4lmYY9EiJKBIuUU4w/L8S6VlLZlxdHmi13mAC/l4KiMw450dT9cXqhS0cQCCTrM76TxTKCxYWdLnkm6uQjZiBWv6PBmO1MUDpXvICIAm87PKoWuKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109792; c=relaxed/simple;
	bh=9db7fO95SEh3uSRtuyNF3MOIt0acmXRSKspCCWI3gzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWB9EelJFwEze139w3wrwt3KOlNWmTTADnMD5oz8KJprrzIJw1DFWlhgvQVPbcNPFI/Yl7YruHzdC2fhLLbE2ZM+WdLrMf7UHroxQgU8Z+GYuwcibewGlMfkFlvlFoW0QCgvVe3Mq3xeTkSaejPoCu64Sd3piogUY692MexX1jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSOFcZfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSOFcZfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD592C4CEE5;
	Tue,  8 Apr 2025 10:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109792;
	bh=9db7fO95SEh3uSRtuyNF3MOIt0acmXRSKspCCWI3gzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSOFcZfD3eP0pK44g1QmDb3XiAcRdrqw/+41y1kCnZ53Eksxeq6Iji4fueS98U8mZ
	 20wIa7+I9LVtKKkfEvsKaZZHnKQ+kuS/y7CRfCwitCcSXRM+v64ba6n1nNlvdS4Z7/
	 rok0aulRMfM4i0F83QtzFU/xMGfLCPkD28hKtjek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 055/227] qlcnic: fix memory leak issues in qlcnic_sriov_common.c
Date: Tue,  8 Apr 2025 12:47:13 +0200
Message-ID: <20250408104822.051137978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
@@ -2173,8 +2175,10 @@ int qlcnic_sriov_alloc_vlans(struct qlcn
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


