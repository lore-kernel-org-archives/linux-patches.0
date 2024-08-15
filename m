Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267D61714A1;
	Thu, 15 Aug 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729798; cv=none; b=UI0hRddpPF0tpaLFUNF6YHxRyQobuVK55KaFLGGIy7JI4n7AmRMVI2NRvgAlSpqJ8oovD7siDp+CJvgPgNS3azCEVUz74Nsrw12cEfnU7MmpYEktaK5TYAHp3iaMmItjlAiq6J1YSF2w0O3S1ae32R9JOiqfSDH08kSNL+rqHDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729798; c=relaxed/simple;
	bh=FYG4DCLTdWqt+fsZ3I1eWnW6e9lS/0WkpTtAbpRHRYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUn3OXA5vs1KCgnkDi35c+iv75qYOmu5DfNz/7v/P1uVyJJW65GQ/aJ7iNm9sHGc9hOHc8IpORn6/7RQxL318kTysHiw9XgdrGqI5QopFEIlZ8+wa9LdFT5flu2kf9MMxcUOoMEED9hUfOGm3xfQQOxCTZBGg8HxZT9OLOnOApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1b2FsLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1b2FsLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DF0C4AF0F;
	Thu, 15 Aug 2024 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729797;
	bh=FYG4DCLTdWqt+fsZ3I1eWnW6e9lS/0WkpTtAbpRHRYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1b2FsLexHeV6rXNHRtCHkMI/xHX4ZMZyoSYw3uwxt76peB38ft6Mztq5vgyo1cut
	 KU6ZXXIQNuDv/9GK3O2Es4QXZh7Z9DHH4vPQARaoOOjwjcQ9Djym9PgADR9k1SWYup
	 srmPt5bH6nYniuorrbEF5et1fcwx13vbw1sJQJHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 211/484] fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed
Date: Thu, 15 Aug 2024 15:21:09 +0200
Message-ID: <20240815131949.562188595@linuxfoundation.org>
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
@@ -3935,6 +3935,9 @@ init_log_instance:
 		goto out;
 	}
 
+	log->page_mask = log->page_size - 1;
+	log->page_bits = blksize_bits(log->page_size);
+
 	/* If the file size has shrunk then we won't mount it. */
 	if (l_size < le64_to_cpu(ra2->l_size)) {
 		err = -EINVAL;


