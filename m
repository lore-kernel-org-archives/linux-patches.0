Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1462FA623;
	Tue, 17 Jun 2025 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179500; cv=none; b=Suhwu9/494vMDE8MvOhdbpIhY/tYtjVJ83/J22OrPdCSUxPE26M35TFmZyFShnq6/a9fqwwb3NjKs77g+9fW4olzK8l6nJJjaCx9yMbTM1D94ElInFlarrFt2FcYN+wxjwfbXm8/OnFp1IDCEGkuyvoe7QPKOaKCrIQ5qf2Ct1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179500; c=relaxed/simple;
	bh=8K4l55Hx2qgYksL6qUrkwStnkmyqwHbpw7L0IcEkuj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laBXxYmXXximPMQabh3jVsKiyhruGq57HyBZRrd2gaW8ovftLKjdbgYxQaRp64CxTUVTxe+L1DxVew7xe2lDfxt2lJo+TJwz3xnYbjq8Q6AeiEx1JbNTuQlTH+9VJKDkkoULgB1U7ffFCFxNeisRCkkqpd3xW7s/PmnnwphF478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwFucV9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwFucV9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9669CC4CEE3;
	Tue, 17 Jun 2025 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179500;
	bh=8K4l55Hx2qgYksL6qUrkwStnkmyqwHbpw7L0IcEkuj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwFucV9uJ68BvgcDcWXpqqbixhxD3+ZkCUuxAvySOg3tq03xRSR76nkXFCMPwkmwb
	 U6RWMXuAjCxe7WOD/21IApu2lPqDkJbDITey57q4ANT0pMcY5YC3UeWQFkEZuowRwo
	 hvbM8g4jgbySo7woDMqeoO3QPG/3Mx3h4TwVxDkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 737/780] bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP
Date: Tue, 17 Jun 2025 17:27:25 +0200
Message-ID: <20250617152521.514850504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit f826ec7966a63d48e16e0868af4e038bf9a1a3ae ]

It is possible for physically contiguous folios to have discontiguous
struct pages if SPARSEMEM is enabled and SPARSEMEM_VMEMMAP is not.
This is correctly handled by folio_page_idx(), so remove this open-coded
implementation.

Fixes: 640d1930bef4 (block: Add bio_for_each_folio_all())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20250612144126.2849931-1-willy@infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index b786ec5bcc81d..b474a47ec7eef 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -291,7 +291,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 
 	fi->folio = page_folio(bvec->bv_page);
 	fi->offset = bvec->bv_offset +
-			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
+			PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
 	fi->_seg_count = bvec->bv_len;
 	fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
 	fi->_next = folio_next(fi->folio);
-- 
2.39.5



