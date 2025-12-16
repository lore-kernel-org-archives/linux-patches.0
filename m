Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84DB56B81;
	Tue, 16 Dec 2025 11:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884121; cv=none; b=BtXQ0u4gAK3b1b86K/CzrBCBco5QimdK11oxrkMXohwksIhU5/HRpS0AjCqV4GUfzgOAhmwF5/zp2p9+5YVeNUG1yTh4rhzABxw1gL54YHadqu68rlRVM58MlPRZsQWdH0hNP7NireNbei5pIsIJ5Vb7vSIzQUoawRlC+wyWMrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884121; c=relaxed/simple;
	bh=NVKJ6yFHgREF8SjknM1/MCQiGTbjmYkcUd69jnD2qVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjllwQzKUHSvk7xJ3mOXbXZSHW4YzdoyRafEWxr/QNiLc6znIoVsg8LtgZ7iBuU7EhtTjGOkRMlVfELEfQYOjcJU78HD03EesaJtASgablHwRQwXLXUuvIqOyZcfiec6zFrCb9O5+Q6FhVVlduL4x/GhLg2Za6J5IcuPN5WHups=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lk/rwvre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lk/rwvre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693D2C4CEF1;
	Tue, 16 Dec 2025 11:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884120;
	bh=NVKJ6yFHgREF8SjknM1/MCQiGTbjmYkcUd69jnD2qVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lk/rwvreWOzbj+qoMj6oE+g7GKng6H4MjffkejpNZs1Jh55mxUlMbeP6SbyKR9YGH
	 /vsNczkEr0t5zz9EoMOCRS9E/MjYpzkHqNCfv5xnntyasc9HldwYl2go5Yoiq4IOEP
	 hy/XhwcL8N9g/7vnayvC3G5ezaPDmQKT1FJfFQ+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/354] wifi: ath12k: fix potential memory leak in ath12k_wow_arp_ns_offload()
Date: Tue, 16 Dec 2025 12:11:03 +0100
Message-ID: <20251216111324.399114192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit be5febd51c478bc8e24ad3480435f2754a403b14 ]

When the call to ath12k_wmi_arp_ns_offload() fails, the temporary memory
allocation for offload is not freed before returning. Fix that by
freeing offload in the error path.

Fixes: 1666108c74c4 ("wifi: ath12k: support ARP and NS offload")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251028170457.134608-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/wow.c b/drivers/net/wireless/ath/ath12k/wow.c
index 3624180b25b97..d9f310a12be96 100644
--- a/drivers/net/wireless/ath/ath12k/wow.c
+++ b/drivers/net/wireless/ath/ath12k/wow.c
@@ -755,6 +755,7 @@ static int ath12k_wow_arp_ns_offload(struct ath12k *ar, bool enable)
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to set arp ns offload vdev %i: enable %d, ret %d\n",
 				    arvif->vdev_id, enable, ret);
+			kfree(offload);
 			return ret;
 		}
 	}
-- 
2.51.0



