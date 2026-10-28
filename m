Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208816;
	b=WPrpdQXlhgcIiCINycRQVYNCNxCCg+pDf68+NhHWZw5sA7+cBh+fcwgYFPkPHo3Hp3wG
	 yuDpDFXE3MTkbwNLwTp0xl/O+5NUgcqYLXCObIyCfMeXlN2drQb/sYFu+DZ5GQcVjBG41
	 f7j136i2uiJ/As1CBmPUrP6RpKyTf8L+Tc/mMRJugJD90Zbg/8rUKgRHaEwTBNFT1TVcj
	 mOGL3T/JDmWuxfN04dejRd0fNfY95T3/5zp8DGlxlcv124nKx+q1M6Io+n8Ou/MV31FfB
	 GLLevHXhvhkcLY1+LMfL6PdmESTvsflHngi/bP58PA93rW1/XWpvMHIu8Eyw8DQ3L/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lSjs+A7LU5zh279d9Ydpsw1knuU34QN4VakHY8UqUkw=;
	b=ryxosk76MxbAleUp/4VddEg9/6U3bxgLomUMF5cFJ9NNytYCn+ZfnHActC8LGjidlT1B
	 D3ySUJQjjiEnYWmZnK/ae3xjRafPT6Jlr0eTN+oeJ/fNbmZUSYGHNBaRakj2ZxbdPMiLv
	 1/N40GXbY8BVVdol09jOah9eOHF+MpvyuRBTgk3DRrs6bwPvjSvmlFdzJe/1XepfTDIUN
	 uWP1F0xVsG2zx8xRY/nkOuW6BJKsdYw9uXi7wghBY7l9WEpYIfGFb0mOxT4RYugOozJGQ
	 rs+jemZFjNJLJrQ+lOWZOpbQNX3pI9vfqpu+LWGBki44dlJvmC4DyDqfv6xPpHsa9cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXvXCAzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1785606A338;
	Wed, 28 Oct 2026 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXvXCAzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206AB1F031E0;
	Wed, 28 Oct 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208815;
	bh=lSjs+A7LU5zh279d9Ydpsw1knuU34QN4VakHY8UqUkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXvXCAzRHZcpgjEuw5GX/16XNFbtzTjYuwmNO42ktaznY8VrtLeqkxXadOWd+3aSf
	 /rhC1b6nQtvBP2a2CCFaBzbmqSS+PNqAuYFVuiWbwXLD9iXb1VwWbdC3jLxi3Od5rQ
	 eg8ke27ulepo0ljBYVcxQFF9tn6olzmJgEuoc+9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/516] smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races
Date: Wed, 28 Oct 2026 17:56:45 +0100
Message-ID: <20261028170009.488833807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 19465a9aeb664f1d710d0d22c07c31bfb7c85446 ]

The invalidHandle, swapfile, oplock_break_cancelled, offload,
and status_file_deleted fields are stored in the same bitfield byte
in struct cifsFileInfo, but are updated in different code paths that
may run simultaneously, and are protected by different locks.  Since
bitfield assignments generate byte-level read-modify-write operations,
a modification to one flag can overwrite a concurrent modification to
another flag.

To avoid these races, convert these flags from a bitfield to
separate bool fields.

Closes: https://lore.kernel.org/r/7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com
Fixes: 3bc303c254335 ("cifs: convert oplock breaks to use slow_work facility (try #4)")
Fixes: 4e8aea30f7751 ("smb3: enable swap on SMB3 mounts")
Fixes: ffceb7640cbfe ("smb: client: do not defer close open handles to deleted files")
Fixes: 173217bd73365 ("smb3: retrying on failed server close")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
(cherry picked from commit 19465a9aeb664f1d710d0d22c07c31bfb7c85446)
[ status_file_deleted and offload not present in kernel 5.10 ]
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d0905aa0b04cd..8a5cdf4ba0ae6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1322,9 +1322,9 @@ struct cifsFileInfo {
 	struct dentry *dentry;
 	struct tcon_link *tlink;
 	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
-	bool swapfile:1;
-	bool oplock_break_cancelled:1;
+	bool invalidHandle;	/* file closed via session abend */
+	bool swapfile;
+	bool oplock_break_cancelled;
 	unsigned int oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
-- 
2.53.0



