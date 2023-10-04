Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A737A1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89EBC433C8;
	Wed,  4 Oct 2023 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442863;
	bh=lYvxSN+ntqJN/6nqjJtDOb3rXs8Zku2RRkYi4E7V68I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l71rU5AG4nOTE9fMcB6n5FMaxNoqd4NO8OL2g9Ik/Jp1W7Jz8jOM/V94B23dFBv+G
	 UenK4Q9U4FKzUzdjbCNY6BYVBx4R3lc39/NSunBWFOcfStPiZMNMCG8SgbrEgxPJiP
	 ONMmHaa8JGq6cJNInKYbJyVyLOCxmWZ/mUzOKvA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	David Hildenbrand <david@redhat.com>,
	Yikebaer Aizezi <yikebaer61@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/183] media: vb2: frame_vector.c: replace WARN_ONCE with a comment
Date: Wed,  4 Oct 2023 19:56:07 +0200
Message-ID: <20231004175209.652365451@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 735de5caf79e06cc9fb96b1b4f4974674ae3e917 ]

The WARN_ONCE was issued also in cases that had nothing to do with VM_IO
(e.g. if the start address was just a random value and uaccess fails with
-EFAULT).

There are no reports of WARN_ONCE being issued for actual VM_IO cases, so
just drop it and instead add a note to the comment before the function.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/frame_vector.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
index 144027035892a..07ebe4424df3a 100644
--- a/drivers/media/common/videobuf2/frame_vector.c
+++ b/drivers/media/common/videobuf2/frame_vector.c
@@ -30,6 +30,10 @@
  * different type underlying the specified range of virtual addresses.
  * When the function isn't able to map a single page, it returns error.
  *
+ * Note that get_vaddr_frames() cannot follow VM_IO mappings. It used
+ * to be able to do that, but that could (racily) return non-refcounted
+ * pfns.
+ *
  * This function takes care of grabbing mmap_lock as necessary.
  */
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
@@ -55,8 +59,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	if (likely(ret > 0))
 		return ret;
 
-	/* This used to (racily) return non-refcounted pfns. Let people know */
-	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
 	vec->nr_frames = 0;
 	return ret ? ret : -EFAULT;
 }
-- 
2.40.1



