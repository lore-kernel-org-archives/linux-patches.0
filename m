Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFBC19DF9A;
	Thu, 15 Aug 2024 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729807; cv=none; b=DWEZw4/4blr6QVJbIC8v0haET6CTkqChG/hrL5CVxyhGzrQud0d/U7tWsLARlogyRP0KjWlA5FqJPwaD21kibF8Plu92PFK/jAEbrFg2qh35Qk3L3SbBNC/bv8XG24VKyrxX6I2LLzZMPmfTWYSF3k0JPGPwv19tLQltgnrHcvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729807; c=relaxed/simple;
	bh=9oytuL0yUDhHl+BBBGEZfTofqc60RoSXYnjZJ2qmJmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvihUAHFlG7IJrxAsSuRIlhmfBG7LUSaFnmoAj4YfuPnR5BclYgglohV0+wjiqB3m6olIzUIM8j10P8bdPUtvoXwJeYOQlhUrc6lxyeFzsNYY/b5QPtxd3I2mRWzkaRWBaPMtej/rJ6PHl9pS0qTKCTsEHwNe90ZqmycqxMavE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7euT0dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7euT0dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B8BC32786;
	Thu, 15 Aug 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729807;
	bh=9oytuL0yUDhHl+BBBGEZfTofqc60RoSXYnjZJ2qmJmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7euT0dE0+Ha55zt2GPwiFZMR/flVQoOLbQYrF3djm3wpyk2w2cMtTDCkgETVaaqc
	 Uw3vsr03OZexAmbrMzhYi7KFyIlmBAIWaBPUODUrlcgxtufIPggTtshkiOJHmM/vpq
	 /ybU1XIJIDhE41+efQhTfSroN2pMuuFSICXd2QrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 214/484] ubi: eba: properly rollback inside self_check_eba
Date: Thu, 15 Aug 2024 15:21:12 +0200
Message-ID: <20240815131949.676715274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 745d9f4a31defec731119ee8aad8ba9f2536dd9a upstream.

In case of a memory allocation failure in the volumes loop we can only
process the already allocated scan_eba and fm_eba array elements on the
error path - others are still uninitialized.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 00abf3041590 ("UBI: Add self_check_eba()")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/eba.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1560,6 +1560,7 @@ int self_check_eba(struct ubi_device *ub
 					  GFP_KERNEL);
 		if (!fm_eba[i]) {
 			ret = -ENOMEM;
+			kfree(scan_eba[i]);
 			goto out_free;
 		}
 
@@ -1595,7 +1596,7 @@ int self_check_eba(struct ubi_device *ub
 	}
 
 out_free:
-	for (i = 0; i < num_volumes; i++) {
+	while (--i >= 0) {
 		if (!ubi->volumes[i])
 			continue;
 


