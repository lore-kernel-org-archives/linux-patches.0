Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060795;
	b=Jgidb+672q/8U6KOriuUR5WAN0MMSVUIJi/Z+eb12d2n5hcjB1IweQA8xOavKGVnwjUs
	 Kd9XERckIAxAtMdyrhM3tLQ4FuZgimTapiUr4SjBZpodgV5Nagw5C7BqIFmiPIjqpH5CW
	 gi7AQpYpSXjZsFHVRp7w0gb/ulgP2y6OxbHRHd6QnIKWjwhn4CE/2IC/nH9oab5nk06f+
	 vIpOPDh1WOtW9DHNrAocpcOA87T+bJzfevwVsoJ4zhKey0wYRUaZb52yUOIpgQTFJupZh
	 gNl78+ao9knWQ9BwkixjvrJhXxo2xACkkuURLEcZ7Lo5sju721iiOqoEkH22dFSnlsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9lwwY7X4WrqjopbugO7VbRggtto7pnUFlIZ71+RkkOg=;
	b=uiAQybjtCAvbf/o6dNrxylYXuGvgsYDXHjzy9hPSX4vd3aJCyihcelDKRwwFqSMqB2q7
	 S64Wqy2/K5ufXf9+PaHkJQ6JsnH7A6CsgBhBSNNchra33KY+K4h8dhlwHwDxtMipvMzR8
	 O9oormjTnqysI5OhyDxh3USxOXXikYXHFxGiRugQVPnxij1JRpCAC3199JjYffRfrwWj5
	 3IcCCf5QKWjGJbcryPuHhtYw/D1h2msJMB6/cYCXjIsDfKIff2OelCFEszLUnAWDL/XgW
	 /jtz8MNi+XeRFA5FqbB+S3FHbKdANml2s0I6RdXFHkebgdPPQYknNZLIsYJbqamNtiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDnvz9Ap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76541606A332;
	Sat,  7 Nov 2026 14:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDnvz9Ap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210DE1F0089F;
	Sat,  7 Nov 2026 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060795;
	bh=9lwwY7X4WrqjopbugO7VbRggtto7pnUFlIZ71+RkkOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDnvz9ApMwW6zepiPI2QZglzA2LzO43ko2rcXKhwao+zJ2Gwyx9rdkjCVXfxROZB/
	 ornnpM//X6lpYb8G0q7kbZ6YsX32bjZ/qk7Df18eWW33ExHBv6QULKHhPZrHpU5Sya
	 zuqvKULv1jUul9c2IVxSkYyJCsrDrvokQR0saET4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0197/1536] ext4: use FGP_WRITEBEGIN for tail block zeroing
Date: Sat,  7 Nov 2026 08:36:53 -0500
Message-ID: <20261107135003.194493055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422 ]

ext4_load_tail_bh() returns a locked folio that callers immediately
mutate through folio_zero_range() and mark_buffer_dirty().  Use
FGP_WRITEBEGIN so that, on backing devices that require stable writes,
__filemap_get_folio() waits for writeback to finish before returning
the folio; on regular devices the wait is a no-op.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dea85cff89457..dcd67771f3a3b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3689,7 +3689,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	int err = 0;
 
 	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
-				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				    FGP_WRITEBEGIN | FGP_ACCESSED,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-- 
2.53.0



