Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869E1714D0;
	Thu, 15 Aug 2024 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728802; cv=none; b=TIsAMPbtLr+Q66Kghx+d5Xk3JUvjpTN3aPU6hhz5/cNzVDxv0AxqulsR9AWUxjoXs0r9StynRLVSVMxVC4S6pgAHGxPyDaNb8pauKdoKW7Jn4v5GzR12hOlGOqCJ3BeJmAksgEZRQZScSyp4MLx9jW/j/iNkp5o3za4N4UTPQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728802; c=relaxed/simple;
	bh=9BZ96yMhbWJFg02U2LzWjtwMFHH4SH68u5euPP+7LvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRDTnqn4DS4yuqcTXWIEU5nWBp4jv/wvz0o1Bf/8KQ2Jcgivw6Zf6kq1vQ//R8Dq4GpTzhO51+49u+Z7vq/TGcRMR4ttfJFSOMjDg2G0RGTs0I1GOSb/yLoYtXiUh1U4dDeSVs7saEPmInadzn9OC1sWtTR5VMB9IaVm9VaaieE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMkGWTLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMkGWTLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF55DC32786;
	Thu, 15 Aug 2024 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728802;
	bh=9BZ96yMhbWJFg02U2LzWjtwMFHH4SH68u5euPP+7LvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMkGWTLwuxsUf3HAnOHADiHoo7H8Q4f5DiNVbGWemtlHynHOfHtavzyjeuQt6YBzA
	 lUGkdNfsFLLrX5LWig0rLgZIdsp7VyymZLXBrjjKMPJnYrgEY3TwsBpVX9P2cb7rb2
	 IJTahsi6l1CZXvs2XgTf2naUA8eWsjczOeIGYd5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 083/196] ubi: eba: properly rollback inside self_check_eba
Date: Thu, 15 Aug 2024 15:23:20 +0200
Message-ID: <20240815131855.254817862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1573,6 +1573,7 @@ int self_check_eba(struct ubi_device *ub
 					  GFP_KERNEL);
 		if (!fm_eba[i]) {
 			ret = -ENOMEM;
+			kfree(scan_eba[i]);
 			goto out_free;
 		}
 
@@ -1608,7 +1609,7 @@ int self_check_eba(struct ubi_device *ub
 	}
 
 out_free:
-	for (i = 0; i < num_volumes; i++) {
+	while (--i >= 0) {
 		if (!ubi->volumes[i])
 			continue;
 


