Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3DC154C18;
	Tue, 30 Jul 2024 16:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357819; cv=none; b=p6W947J15cPkVTWilrUk8TZlYXoIeHP/bpj8Od1Crwgga2qYL5MExczDWUldXI152KTEOZHQ3BgG7RXhP8f/Sw1dV8hsCR2Kl1XiblPrTrcW3EN988HEq0OHVh//jxFCSe3FBOJ1Y1vzZFdKSIV2OR1dHgWWe16kFi8Bw294R0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357819; c=relaxed/simple;
	bh=SEn2FhF9aHwMF4sCMJgHMF0KhcC3QvQUEMf3ZbWEXa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvFvPygqrV95FvVkpUEwZrWuVlXZmyrgG+gmrG2xlPB73gl99Ed5sH6QfmWTkAMjdlE/O5KX/M7VFDTBRevFuOCmpz/JXxuYlZomrH9hMrB+HIl5F2Oi+W8qugEFKji7bzzWhYBrzfaAQRLAWVxjURe5m+FiB7FogtWq2Cnaqzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUItgJPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUItgJPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BB0C32782;
	Tue, 30 Jul 2024 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357818;
	bh=SEn2FhF9aHwMF4sCMJgHMF0KhcC3QvQUEMf3ZbWEXa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUItgJPJgcFmByBx+rOhnLm4pUrXPSfJdTtGrGDFdueiDbPf/fc9lzl4HUFNNm44h
	 w07trP4xgzmrZaFeWyuBWxqzKHLP/m0fTI7VTCYIBtNGag90x62pNlcC6cEg167TDe
	 nBN0nSGlve5fGqabHCFlViGXxcRgN+rCXFgJ4ls4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 295/809] s390/uv: Dont call folio_wait_writeback() without a folio reference
Date: Tue, 30 Jul 2024 17:42:51 +0200
Message-ID: <20240730151736.245686299@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 3f29f6537f54d74e64bac0a390fb2e26da25800d ]

folio_wait_writeback() requires that no spinlocks are held and that
a folio reference is held, as documented. After we dropped the PTL, the
folio could get freed concurrently. So grab a temporary reference.

Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20240508182955.358628-2-david@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 265fea37e0308..016993e9eb72f 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -318,6 +318,13 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 			rc = make_folio_secure(folio, uvcb);
 			folio_unlock(folio);
 		}
+
+		/*
+		 * Once we drop the PTL, the folio may get unmapped and
+		 * freed immediately. We need a temporary reference.
+		 */
+		if (rc == -EAGAIN)
+			folio_get(folio);
 	}
 unlock:
 	pte_unmap_unlock(ptep, ptelock);
@@ -330,6 +337,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		 * completion, this is just a useless check, but it is safe.
 		 */
 		folio_wait_writeback(folio);
+		folio_put(folio);
 	} else if (rc == -EBUSY) {
 		/*
 		 * If we have tried a local drain and the folio refcount
-- 
2.43.0



