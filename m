Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30BF17BEC0;
	Thu, 15 Aug 2024 14:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732369; cv=none; b=jvCpFKWiKUD+BKxGFxm0OJb3DzG7mhBQc7L5Y5Qc42uw4NrwCPCjukeNVA6Nc3xx37yKU2mP3DKWPtpbTLc+7uPZh4BfuwCi0xRNg3WLt1OtGZfmfpXQtG5w+4j2ad1flXtF85O9366d/tYcoGUuxOgJXOEZ5JWDFV4I8whD96M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732369; c=relaxed/simple;
	bh=neJ48RiwWdumaDChLN0/soc09FoYvdISkqhDFGzeGQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8YYXVVggfLAkhKXHKOZUUkNqlGKGSC1hcwSnACHgzTfiY9jBuApN+XrpFF21fkUSOyQjCPGt+baGIgZmWLbQCTznDdEXRor77LRdVBDvhJiDQsfYE0bdEcE5G2xTjK/ifPgUGbtk+ZMlWdWYiSgpbRyageqJJXR483HSBBmllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+IlkuK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+IlkuK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A61C4AF0C;
	Thu, 15 Aug 2024 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732369;
	bh=neJ48RiwWdumaDChLN0/soc09FoYvdISkqhDFGzeGQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+IlkuK+52MqQYMtrVMfR9rIvHfIlAXCzrQgN8OPUp9ae8M7vV+zEBfrmPs7z36kF
	 VCeBM7UEZES57LfcWkZqeKXGLpUN2Ud/DwAtAbcf+olJkbfTN4SF3DRLo8TpXwgWOk
	 RxJPo1PIF5RKXaXnYNLvmSOtZzMaMcYou4bxiDsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 159/352] ubi: eba: properly rollback inside self_check_eba
Date: Thu, 15 Aug 2024 15:23:45 +0200
Message-ID: <20240815131925.415201101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


