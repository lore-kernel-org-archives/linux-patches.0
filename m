Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211214;
	b=viZJB0kvBWtCdNhedpTNaN/QMc0o81YL0aR3iDjEg8VkKhYhSg2FUt6777kcM5sqJyG3
	 JxiFkQil3XuwvuNll4AWW+0BJTcxbT0iKPFbH23CLQBojjgytfu3hr7R6NKRnXWGKjFGc
	 T309CZMm9aPNqJMXa8DTYFTRuQ/n6QH7RuOeOAWgKrJuUaEXV42FvtiAZtZa4HnAlShW7
	 byc1/KXcb6BKelKUI5hEk4C9Ww82g/ZYXPZY8B0uHYWvJtDiY0PHd6kfZ3/BlxHblhJEQ
	 VFqVwbsO+FQ+Zg9xhFVX27BQVKlhDQNNbkGrj/uS5o3srB5Vnb/2fobDYSqa+ab1p2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29KHNdBFq+TEKblxXzwBndr66GlOzuNFAAbCxT3zFaw=;
	b=REf6P+pREh8Tn7bvntPh9zCoDcrvR+d/IanXKgTGaIvFGeCI27K/Qro0pbFJnLQXX5OP
	 ZcLa06b7k1Me5TIRwrDUwGqHkFaX0h/m5zSBcqF+FPuXITSunEEYwJxzJaZRijAjYkb71
	 fqxBlVi1GwzUFWkvAYqhqCUBa+TBQQMU8LnLS2k+1Bp7x4wOHUozKcc+t7LcMFGgohl87
	 08fGG2RpARLUuNFQ9ZuBPupvDXrixaVU8s5HKMtKg3qooN80Zb1KUs7tjcyyZDDXFhKNW
	 v77zO+F05RTm5+s48kkPk+3qUt3EsMIX6D7CG1gjoXLgOSY0yHK1x/GiTxmqc38Jjag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GlHTP4PS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F04606A96C;
	Wed, 28 Oct 2026 18:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GlHTP4PS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14E81F01825;
	Wed, 28 Oct 2026 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211214;
	bh=29KHNdBFq+TEKblxXzwBndr66GlOzuNFAAbCxT3zFaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlHTP4PSEExU5SnYppHoI4Ur3/+sq4u1DfffZoIalXYpQUnjx3oe/7JQ60Papag2W
	 hH0YhmOs/Kn+oVzcYs28vM1T3sjqOHGnDc7YyeYTGHF/ByVrAyTc7cZDttTQGB5X+X
	 hJqTvK0BppBGrWY96jfuFSqfx+Ee83hSrfEFUvKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/571] smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races
Date: Wed, 28 Oct 2026 17:56:59 +0100
Message-ID: <20261028170014.455731428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ status_file_deleted and offload not present in kernel 5.15 ]
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9b08020634f19..be53b788ea4ff 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1265,9 +1265,9 @@ struct cifsFileInfo {
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



