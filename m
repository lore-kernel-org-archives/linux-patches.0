Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5F31E86F;
	Tue, 30 Jul 2024 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359169; cv=none; b=Uk10CnGr++QTZzmEGMLWStcO48orjNOU7PKv/IJ1T5HX2XtQ6CL4PQptE2hcfJ+fuJr8nC1O4TfLrAGf71QFdMhL0wU7aTEtweIDBPBrU317r2kdYzaYx9+enu2BpXD8q7yDz5r1ThT004ONgmnnJNfkQJhfQb3P2USouewZ1MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359169; c=relaxed/simple;
	bh=FAWu1hT03kMe5IP//1qoTkdUcLiscq4s1A8XzbyAeHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbOVPPgqU3FBglN0qf4+MBAW21XmZIKK7p8U3XYF3Oqd/huTnuvrC/Cz93P9CvYXH2eImRzIKGtMp9j4tyMMyRIdnOVQ1F69q+x+IjB+RT9j1khRjn65EHvrZkROXKGBZyiBtbh8dUl5IkW3yPHXbvy7aKp72Mbcmdw/Tn1OkUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq0Cz5JO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq0Cz5JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419DFC4AF0A;
	Tue, 30 Jul 2024 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359168;
	bh=FAWu1hT03kMe5IP//1qoTkdUcLiscq4s1A8XzbyAeHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq0Cz5JOboDeJ0KJuSNlCbuYxDbAkxLJIA/2chp6qx9FpfvzJw+MYTa4iiixamx42
	 mTlxiDafaAktPY4TClaeBAK2YH9NUOV3hwZ6MU3FJ8BWo9vbyKcXL4MR2CrAJDqnJA
	 UAtdDc8gfWhocRD4Gc9YKO37uhdKg7hs57tle7Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.6 442/568] ubi: eba: properly rollback inside self_check_eba
Date: Tue, 30 Jul 2024 17:49:09 +0200
Message-ID: <20240730151657.148088568@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


