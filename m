Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449C1A76AF;
	Tue, 30 Jul 2024 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360274; cv=none; b=Y+lSdC/RAlke11KtxMpbK7DzdIePw9JvSRhEuCZNRqw6QY2OF8Ydb1LX4hmzGnthx73HdC2c1E3WmVQGhTe4JfmYi/6SEfxtxeEnpUKczLEThtrzxoNLaTyjRE+mqTctzfugT3KjXXSi1BC+BDF34e20Pd4Or2VKgFMXAnN9if8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360274; c=relaxed/simple;
	bh=UmySNVXYsR8CV1zdqVqUi1X2ol2uUnKA9kJM0FJGOss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC81FuT5VpaAZL4JMcshR9G7jANkD5Zj0qwAkrmxxazWWBD2IKpd4LtEO3wzzPsnyA8K7YYcvhk5tX5wEHjbS71yDAxAkSdpR4fmgLCKuNxtfskqlxjJzYKhKo6Zq+WaG1eU3En58J4OeW58roLZzwSbbQyWroIzcSvbmmEt17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0L9esCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0L9esCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5537C4AF0F;
	Tue, 30 Jul 2024 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360274;
	bh=UmySNVXYsR8CV1zdqVqUi1X2ol2uUnKA9kJM0FJGOss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0L9esCY/ktvTSBRnyZB9M1YyIDRz3xJzjjrzaBXsIFn+kBlIHqUNwxFUYN7pz8/9
	 1VFrUZVhELD1LBNVkApWhahms9P+PUihRzGkTdyNUxAHbnUOzWFo7HMBiYHsf9bCBY
	 PBKc+0EW69IL4pgc4astR4P8XeTLxcQonCxM7gfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.10 649/809] fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed
Date: Tue, 30 Jul 2024 17:48:45 +0200
Message-ID: <20240730151750.509541922@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 2fef55d8f78383c8e6d6d4c014b9597375132696 upstream.

If an NTFS file system is mounted to another system with different
PAGE_SIZE from the original system, log->page_size will change in
log_replay(), but log->page_{mask,bits} don't change correspondingly.
This will cause a panic because "u32 bytes = log->page_size - page_off"
will get a negative value in the later read_log_page().

Cc: stable@vger.kernel.org
Fixes: b46acd6a6a627d876898e ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3922,6 +3922,9 @@ check_restart_area:
 		goto out;
 	}
 
+	log->page_mask = log->page_size - 1;
+	log->page_bits = blksize_bits(log->page_size);
+
 	/* If the file size has shrunk then we won't mount it. */
 	if (log->l_size < le64_to_cpu(ra2->l_size)) {
 		err = -EINVAL;


