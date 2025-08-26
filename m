Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5578341671;
	Tue, 26 Aug 2025 11:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207081; cv=none; b=UNubJqs5vRZBM883t5bhT4RDjmhxCvLnAry0VCEphNRZ3q5r/snX2RwGFSKle3laRXRKJjfsaTsWTK8pPxx7lGs/LEUZh6ofOGvHrzQUyz8Jh9wdbxI8pK14TdNKGnyeyVfH6KA+n+KDgk8VFQ0lX+OKCXNdCD1dkkJLz8y+p38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207081; c=relaxed/simple;
	bh=OZyA6xghll8Qc2vBdP8t05UjlMwqkBUkPD7CzerJrcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBtBqoY6tOM0z29hvDhPNpNzceh+h0gUFSryV90fGVhNgzy+xiZAKBfg9VFWp5BaNPXfUD2YKrCKUIz17yVTt62d0D2+LmB67ttk9BlAk3wlvt0sm6Ya6AuC9Vtma/NRz/9qdOLGPpTUh6z/00XoNHLmpKeeSoPz5unMeM22OSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7F4N8yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7F4N8yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CEAC113CF;
	Tue, 26 Aug 2025 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207080;
	bh=OZyA6xghll8Qc2vBdP8t05UjlMwqkBUkPD7CzerJrcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7F4N8yfoMr5LDO4EhzqQwpK2bZd5/CbilmH4bsDOUxICqYtiqCjYlwXZWObo/DMF
	 sv9ylFPyh/mNluryaBoOUbAtn0o9uKS0Kf5hlTFRM01DKKQ/fpG7Uo3i6ae25+Len5
	 n+6E/Z21b3jrDkYjFytVwNZx3UQQRwNwZI0mlc+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 042/457] ext4: use kmalloc_array() for array space allocation
Date: Tue, 26 Aug 2025 13:05:26 +0200
Message-ID: <20250826110938.383825651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Yuanhong <liaoyuanhong@vivo.com>

commit 76dba1fe277f6befd6ef650e1946f626c547387a upstream.

Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
allocation and overflow prevention.

Cc: stable@kernel.org
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250811125816.570142-1-liaoyuanhong@vivo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -589,8 +589,9 @@ int ext4_init_orphan_info(struct super_b
 	}
 	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
 	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
-	oi->of_binfo = kmalloc(oi->of_blocks*sizeof(struct ext4_orphan_block),
-			       GFP_KERNEL);
+	oi->of_binfo = kmalloc_array(oi->of_blocks,
+				     sizeof(struct ext4_orphan_block),
+				     GFP_KERNEL);
 	if (!oi->of_binfo) {
 		ret = -ENOMEM;
 		goto out_put;


