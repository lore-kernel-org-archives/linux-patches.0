Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022350;
	b=l3M56lFRDgjxrZUDF7aSJ5pwE0BbO9cwbMmomJbOFjCz5ykaVvKZvwkk8i1c2KOuq0dj
	 +yC+kBKBl3pacecskjdzzWO5mqAr0MLYK/TNbDcZdjviQwFKsfmBwnskE0zBgZlQ87Jty
	 Yimf05NtjIJFYzHmfGQzeKNOMckfP5RmcSz1SaFndnu0UEVuZFQZJvFqULqOctymto8eD
	 wiEpX5uYWdUWSTaKR4vzR7eNLGdlDTLsSiNxd8y8Raq27cZs4pXfk7zFBem8C2FFgY8k1
	 WmqB4/br9p8TGYpHv+R9HkrjBInhnIB4naqqB94y1zF+J6w2UgS+0XTJyg8A+qX6pIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LLGE3RWFSkOdEz3q3H4YsmmCpKeZjepRisg6+FPNuw=;
	b=5I1cQSGHO0gFymuUpBtLDyul7cSwmp2rvhInp7ePEMKnHatDVNCL+mKdkY+RwHJX9T12
	 CAJVJ98Ld4qZX0P0lGe75FZ30gNG/iwmCpJ4lX8o2IPTOwU6x+XqexHzLhYA0L/RvPRnX
	 4WgkFoQ6MLMWoSTDapqbXbsNJLXt7OdhqKRnN2f4wG+Rw6nZeUv1xZ1QB1Uc5EeC5b4ru
	 bZOw8kLvPhidS+9laI1r9XyuTcFvdraa22TjgY1OIId1lAUBQ33Imt6n6wu5K2iAnSa7E
	 lZUJtdbYbDFKajNJ/es8U8JJu4TWnVyVr5g83fyFQSOvEtEKQ9m5ODWp6zjRLq88RNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uzf1ipys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBC3606A320;
	Wed, 18 Nov 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uzf1ipys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFF1F000C5;
	Wed, 18 Nov 2026 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022349;
	bh=9LLGE3RWFSkOdEz3q3H4YsmmCpKeZjepRisg6+FPNuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uzf1ipysHO96ChkTEK98KLs7phUwZxD/fc2TmEoc8g0TlVGLxoHFLP09kvGmX/KGf
	 fOklLUrj4RkV0me1o6VsE3NAWtPlqRQoOgL4qyf887xFuY5lzDtAAVmt93jsd/g03Q
	 /Cpf0yQ9EH8YJOAJZyi/WVFtQAs6maEnZoVqq0Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>,
	Qu Wenruo <wqu@suse.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2631/2651] iomap: only follow dio alignment requirement if specified
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150418.885309314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 87d02f3e98a86abf70441b0a0418e01cb1d64b44 ]

After commit 4025185cf953 ("iomap: follow the alignment requirement for
iomap_dio_hole_iter()"), generic/091 fails on both xfs and ext4.

The reason is that ext4 and xfs (except COW write) do not require full
block alignment for direct IO. They are totally fine reading a sub-block
range.

That commit fails any direct read of sub-block holes/prealloc, even those
filesystems can handle it without any problem.

Fix the regression by only follow the block alignment if the
IOMAP_DIO_FSBLOCK_ALIGNED flag is set.

Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap_dio_hole_iter()")
Reviewed-by: Pankaj Raghav(Samsung) <pankaj.raghav@linux.dev>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Link: https://patch.msgid.link/0e89c49b6f7804081f4041007b81ac620a153830.1793307063.git.wqu@suse.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c  | 26 ++++++++++++++++----------
 include/linux/iomap.h |  3 ++-
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 9ad1a984d09e2..06566073a88c4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -590,18 +590,24 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
-	unsigned int bs = i_blocksize(iter->inode);
-	loff_t aligned_copied = round_down(copied, bs);
 
-	/*
-	 * If fs block size is larger than page size, page fault failure
-	 * can cause @copied to be page aligned but not fs block aligned.
-	 */
-	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
-	dio->size += aligned_copied;
-	if (!aligned_copied)
+	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED) {
+		loff_t aligned_copied = round_down(copied,
+						   i_blocksize(iter->inode));
+
+		/*
+		 * For fs passing IOMAP_DIO_FSBLOCK_ALIGNED flag, if fs block
+		 * size is larger than page size, page fault failure
+		 * can cause @copied to be page aligned but not fs block
+		 * aligned.
+		 */
+		iov_iter_revert(dio->submit.iter, copied - aligned_copied);
+		copied = aligned_copied;
+	}
+	dio->size += copied;
+	if (!copied)
 		return -EFAULT;
-	return iomap_iter_advance(iter, aligned_copied);
+	return iomap_iter_advance(iter, copied);
 }
 
 static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 9273378b37d0d..e9b76647784c6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -665,7 +665,8 @@ struct iomap_dio_ops {
 #define IOMAP_DIO_PARTIAL		(1 << 2)
 
 /*
- * Ensure each bio is aligned to fs block size.
+ * Ensure every operation, including bio and hole zeroing, is aligned to fs
+ * block size.
  *
  * For filesystems which need to calculate/verify the checksum of each fs
  * block. Otherwise they may not be able to handle unaligned bios.
-- 
2.53.0



