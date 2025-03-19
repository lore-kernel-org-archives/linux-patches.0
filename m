Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155E18BC36;
	Wed, 19 Mar 2025 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395251; cv=none; b=TMIRVHNSIK3reKwLimtMVXaa/As8jUKiidlYoiC31VF1PZpengWeLFVquP7uYWHwMBg18J1eIY7t7ss23qWknf8hFLc5SWxPesSlKCnV1grKVSKB1A0YJfZrEhDeqwfEfKxqVd+nfO+eCXJGJ8hU8RbKtG7mhrSc7rskPBo+ds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395251; c=relaxed/simple;
	bh=BsD92i5mH/qnMsziLAM9F+EOiMJlAPXb+ZfptwHvMtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofsMWwYGt1exuCIdMu6o8oeDX9nheHPa5JwesKZpB8jhQeoJhx+/Sf+Ak28dZ8MSOHnlvMQNhBJ8cfxG5angWrOGpbbJfu9PrqateHoQeBBHJyq0EkJUhLJK7kcAVgPapifrVo7+WSglbHlHknuW8QzrEg7I5nWrnbLZ+dvztKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m430rm27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m430rm27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D05C4CEE4;
	Wed, 19 Mar 2025 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395251;
	bh=BsD92i5mH/qnMsziLAM9F+EOiMJlAPXb+ZfptwHvMtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m430rm27qSAwdeApUld3/7Yj44o9oS5HSiD4ezfGdXh/6l0umxRZBzsMfzXPLKbM+
	 RvUCI9H4yMTwqptZWLT0rWgN2TIK9IWi0xBj3P6ttnVauFDuYLA/x4C1F28OsrCBVQ
	 uohYk/QLv5i3VckFTOKub0IC/9n3wnZXQihV8GHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 133/166] qlcnic: fix memory leak issues in qlcnic_sriov_common.c
Date: Wed, 19 Mar 2025 07:31:44 -0700
Message-ID: <20250319143023.618171690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


