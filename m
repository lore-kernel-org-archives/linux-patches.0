Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F901F4708;
	Wed,  6 Nov 2024 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897644; cv=none; b=T3XxhIf2Pu6AQCR23DibZ5T9rZh6d7SS0BRrV5U77mOAwyV/gxHbMB1CqXp0q8PJ+qK9Uxx3Qy2hCg7KRKRXE9EoH0hLRqdtvaek2+jpmzDbiQrJ45WcsRfnS9vQYTQj6GOaOSynQNy+ZOn0Jwh6TaMqVFJ1GyryDpUfgekDuqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897644; c=relaxed/simple;
	bh=qbFPHYFPAK14Rj8LuFImtwjZmXKiX6ModhTIKpDZ0OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szbvYzq/qf3R+id/xLaViNSIYqiBSQ2fawSktu6gblWT4gvEO4+mQUsN2UZZMzg0YnClJvZ//OOI66kfb9V84/iMrvU56E4luuucLEDbTWYlDW2SIG3PaVYQznXREDT+zY88NOhbdQwC+b/N4nqulhXAg0tO3gwjQc+zuC7dd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCXfMQTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCXfMQTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EA5C4CECD;
	Wed,  6 Nov 2024 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897643;
	bh=qbFPHYFPAK14Rj8LuFImtwjZmXKiX6ModhTIKpDZ0OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCXfMQTAArEj/YIeuGwbxN17/DJOQiMo9oTSzWhr/KLxAi6xcktjf+xnquugO9v5j
	 Tsdhl3zhdB72hcdEXPk3Ifq05ffQZRU4/TNt9arBmjQ0s9MeAcpceB1SsRPfL6E2DH
	 ALzegXqMtDnfa7K4zUAbBWIE5baI7aMxxt8DYeZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/151] iov_iter: fix copy_page_from_iter_atomic() if KMAP_LOCAL_FORCE_MAP
Date: Wed,  6 Nov 2024 13:05:11 +0100
Message-ID: <20241106120312.250634648@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

[ Upstream commit c749d9b7ebbc5716af7a95f7768634b30d9446ec ]

generic/077 on x86_32 CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y with highmem,
on huge=always tmpfs, issues a warning and then hangs (interruptibly):

WARNING: CPU: 5 PID: 3517 at mm/highmem.c:622 kunmap_local_indexed+0x62/0xc9
CPU: 5 UID: 0 PID: 3517 Comm: cp Not tainted 6.12.0-rc4 #2
...
copy_page_from_iter_atomic+0xa6/0x5ec
generic_perform_write+0xf6/0x1b4
shmem_file_write_iter+0x54/0x67

Fix copy_page_from_iter_atomic() by limiting it in that case
(include/linux/skbuff.h skb_frag_must_loop() does similar).

But going forward, perhaps CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP is too
surprising, has outlived its usefulness, and should just be removed?

Fixes: 908a1ad89466 ("iov_iter: Handle compound highmem pages in copy_page_from_iter_atomic()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Link: https://lore.kernel.org/r/dd5f0c89-186e-18e1-4f43-19a60f5a9774@google.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 27234a820eeb3..a4bb47efafe37 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -570,6 +570,8 @@ size_t copy_page_from_iter_atomic(struct page *page, size_t offset,
 		size_t bytes, struct iov_iter *i)
 {
 	size_t n, copied = 0;
+	bool uses_kmap = IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) ||
+			 PageHighMem(page);
 
 	if (!page_copy_sane(page, offset, bytes))
 		return 0;
@@ -580,7 +582,7 @@ size_t copy_page_from_iter_atomic(struct page *page, size_t offset,
 		char *p;
 
 		n = bytes - copied;
-		if (PageHighMem(page)) {
+		if (uses_kmap) {
 			page += offset / PAGE_SIZE;
 			offset %= PAGE_SIZE;
 			n = min_t(size_t, n, PAGE_SIZE - offset);
@@ -594,7 +596,7 @@ size_t copy_page_from_iter_atomic(struct page *page, size_t offset,
 		kunmap_atomic(p);
 		copied += n;
 		offset += n;
-	} while (PageHighMem(page) && copied != bytes && n > 0);
+	} while (uses_kmap && copied != bytes && n > 0);
 
 	return copied;
 }
-- 
2.43.0



