Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26950101C6;
	Sat,  3 Feb 2024 04:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933593; cv=none; b=O8ZBGNq6eHpmlfVqAwWEXavA4sQASkbeNOe7X0GBi+qH5W1/sHlIUEUI5DXxbza5I3ZfSwCoO9Z9Z54XAE2dAneeWdMjq+wnPGD3bpywaPPaetoEA6Xb0qINkPciCZDn9tTBP4sySyWE/N9Tc+jyskXtgi2UG5r+S704qpxKuCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933593; c=relaxed/simple;
	bh=B6q2qrlcU13bk2bTsQqv8aXVPt3GXsV1fqUuyZRFOZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4RXh1jZjyuikAcLaYB7wOnaiQWcBDjN6JP4AwJuyZGLK3aS8nayh4UNniDcu7ao2lM4UP0HohxZz9h10uFpK0vaPJhzS4dEB6GjMVl48UK6wtoXRU2ymFPmpEW9coj2eRLKwmVvAdMF4E/5sHDLwsbcNP5YtrGH16tM+N2hMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T6KaMd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T6KaMd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925BCC433C7;
	Sat,  3 Feb 2024 04:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933592;
	bh=B6q2qrlcU13bk2bTsQqv8aXVPt3GXsV1fqUuyZRFOZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T6KaMd92DXEGXKxeLq2Z82x/TaxFix3akaZuQgdRRoKxYb3s1VTc5mXyYoZ1pQG2
	 s4aROapz/C8K8IBs0ttW1v9rLEyRCmg2LEIdRfnSJKTc2xS2HAuZ3NpIIROnEx21H2
	 U/Civp8hTxyFHYFV0KhAPgdtx9kPIfUEd39h21Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/322] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Fri,  2 Feb 2024 20:03:50 -0800
Message-ID: <20240203035403.446982470@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3f034c374ad55773c12dd8f3c1607328e17c0072 ]

Reordered a check to avoid a possible overflow when adding len to bv_len.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20231204173419.782378-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 5eba53ca953b..270f6b99926e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -944,7 +944,7 @@ bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return bvec_try_merge_page(bv, page, len, offset, same_page);
 }
-- 
2.43.0



