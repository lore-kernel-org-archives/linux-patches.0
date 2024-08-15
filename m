Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDF7DA9E;
	Thu, 15 Aug 2024 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729557; cv=none; b=M6v8NQ3Rt/PHsnRiGQAAhJV609z+zAqhBcqHI+kiH394iOYYamvrZhe8Bsb2qNqnTT/5dl2FksyXgOSYmpswAoEMLiZRFs+VM1H/g3+E4GTGq9u9H6jvZyjk3zL8NI3+eWHxrn7zTJx19jOAZxuZk7rvuBJ52MRcRvhWI1cCvOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729557; c=relaxed/simple;
	bh=Zd3AwQfzP1Jn4wnwqTZOrnwlAlmiFsdHjXJt4JzhEpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhXwS65qCtElLnMLrPGadyFHALhpiMse0lTbTHUANT4PQMwu1bDG86bSn5MhTkSjsfh/47OoS7jf70B0KLR3Yf2hfTprShNBnuLZwnHVg08c9F74yffDozGY0h89R+7BqGAWeba4ILFFegqgNwxN0WXH9oG+wZG18avIfMfrIis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqtDO9az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqtDO9az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5E2C32786;
	Thu, 15 Aug 2024 13:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729556;
	bh=Zd3AwQfzP1Jn4wnwqTZOrnwlAlmiFsdHjXJt4JzhEpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqtDO9azK8w6SUav3Mzr0sdSRQwf9lF+EDTiWmp5u8VlUrKYBtdCmWe5L701AMoGP
	 m0oFQ3DuaowuM+iPxEi/Xy0l0062f1wMY6mm+iaSdX2jwI47hhnlr1ph/Wxt/BBzJ2
	 qZLYUCaP11thJlejfx2NXpIv8ptmDQu0zY8ka0B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/484] s390/uv: Dont call folio_wait_writeback() without a folio reference
Date: Thu, 15 Aug 2024 15:19:12 +0200
Message-ID: <20240815131944.922031925@linuxfoundation.org>
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
index b54376c658688..4ec467605d328 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -299,6 +299,13 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
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
@@ -311,6 +318,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		 * completion, this is just a useless check, but it is safe.
 		 */
 		folio_wait_writeback(folio);
+		folio_put(folio);
 	} else if (rc == -EBUSY) {
 		/*
 		 * If we have tried a local drain and the folio refcount
-- 
2.43.0



