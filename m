Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941171A76B3;
	Tue, 30 Jul 2024 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360369; cv=none; b=Hzc8/VdAj/gAGkXaV0J/RTk0xIA6mnGelvQuy9P++J8ykVt+GJ6R9CMbPTlh+u5l8mO0wggH2PSGwhKcXFvvN/iVsxmoK2u3nKjvYgrKVDDfio3PDph2JF86/wWNzJRAbui49EHrUcV2sBrfr4LIbMpy95zho8uDJ8PCAio93iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360369; c=relaxed/simple;
	bh=MvE2B0/NbOT8wHDuULjzELdN+SgTNkfZ7rg85rP9Mao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjRiT5mK7ZHYz0uxkj3IuFReLsiDmG45GLWBWt3H1waBGx5zqi17K0Ur98/XLFkvIdfIsUM7Hx2jYzY6fGw48MgiVp0V9dMuGydpoacOEkZV32H8ulcgmI3K49rrSAHfuiSdx6kLldBa2n/8X4ftorqvcuMGqUgPcogDksmsk3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8jWdQt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8jWdQt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A52FC32782;
	Tue, 30 Jul 2024 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360369;
	bh=MvE2B0/NbOT8wHDuULjzELdN+SgTNkfZ7rg85rP9Mao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8jWdQt3cK0dIFMT84YlZRTDHW7It27gwskDMeSlldSujQIR5GV5Lg7aJiyBifZ5z
	 x3adOym+aCusceGwBDdM0OFqZ1OtRl4jSvgjiKBrtNYAydFniM6O1BEBjjDUpjw0gJ
	 olznOIxp0NjWI85oUfTOR2B6chVUp073bz3oohoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.10 660/809] ubi: eba: properly rollback inside self_check_eba
Date: Tue, 30 Jul 2024 17:48:56 +0200
Message-ID: <20240730151750.958173701@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1564,6 +1564,7 @@ int self_check_eba(struct ubi_device *ub
 					  GFP_KERNEL);
 		if (!fm_eba[i]) {
 			ret = -ENOMEM;
+			kfree(scan_eba[i]);
 			goto out_free;
 		}
 
@@ -1599,7 +1600,7 @@ int self_check_eba(struct ubi_device *ub
 	}
 
 out_free:
-	for (i = 0; i < num_volumes; i++) {
+	while (--i >= 0) {
 		if (!ubi->volumes[i])
 			continue;
 


