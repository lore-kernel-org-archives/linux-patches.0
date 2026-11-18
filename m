Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037585;
	b=yQfxhgdDUuV5Kzc1zdlB6Jy5qLI2sBg5G59DrFiRJn31QbKvDlLwaAvm+W3+DPipbfbB
	 nxtgjVZcJqEcm7Zx0OQgtIgl1HDYFmINYPLXclpqSOjYFRM/bvYQthTX+6kbUmTYA+dC2
	 Nnvydvn7jjJgNixzZEog4fScWy4Vgala1bj3GaXfEaTpGBnW9lzjnCcWDIKZLBMlmM2tT
	 xQlvs0VSo5Rz5BIl6e9w0ma85nQ3eNv4/gQlA2sgOEzUog61Vmvs5Ua/Ve5BpR7A3AqTE
	 bQSeBjyqk1Os+GPvylxjsIbIdQBfeGoCOeI9yJZjJO/c4dXTH9+Fkium8AaAcig1xQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TpoDkx8fLqC1aKm4BU9wZonSnBq0Mocp8VEhSlWCKdA=;
	b=cpGTupIDiKSzlEmslmDaB3eEvqaGqXPCXb0Kr9jcwyjlC84JTMHgKRxgQJgvF9g3Il7l
	 6ppwK6G+5QqAuUE7MifGjIFVG/+kDf5H51pnk0TW4ITg9YTaDuHnM7mmJOgGXYt2PxaJa
	 q/YPrZw29mUEjDsw/r/HkvJLqX7zMlMXeNZIfHL1bWSTwqppZrbNZ69pX2XjdPpVQg+Wl
	 O2b3ejznOUMyP8SEL4cQVvtxaig0i4AOWgGh0gh2/scjtxeH3IuaGCPWof2E0XIr5K9Xr
	 ke+XxLkJOxs9/d9rU5uCsM+KvjGFy5E62RUWf3F+QtDPMIJOgLmk/h25iUa6R5qGWug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPYowYWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B2606A320;
	Wed, 18 Nov 2026 21:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPYowYWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3641F000C4;
	Wed, 18 Nov 2026 21:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037585;
	bh=TpoDkx8fLqC1aKm4BU9wZonSnBq0Mocp8VEhSlWCKdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPYowYWgFXyTD/N8oJHiZOAKZ3EarQADbQF4tUxK0IlXpVMwz6m5IzhExbFvrHIsG
	 I5SoE25uo2DevVPpcL03S5QmpDtmGRvYBEISoAkgqNE4iXvQkL0DNYfBB4XmE5tTIx
	 cnn3yQ6Y684WY2dPzUjMTNvusQN6dA/O4AN5l/hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1449/3318] ext2: preserve completed DIO bytes when buffered fallback fails
Date: Wed, 18 Nov 2026 15:34:31 +0100
Message-ID: <20261118150404.320197904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit cbf04dde8b3c5a7e043e91cefad68b8980ea0d18 ]

ext2_dio_write_iter() can complete part of a direct write before
falling back to buffered I/O for a hole inside i_size. If
generic_perform_write() then fails, its error overwrites the completed
direct-I/O byte count.

For example, on a full filesystem, an 8 KiB write to a file with an
allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
consequently reports zero bytes written.

Preserve a positive direct-I/O result and return the buffered error
when no bytes were direct-written. This restores the fallback policy of
generic_file_write_iter(), which ext2 used before its iomap conversion.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261102061555.55183-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index a6913e4eb523e..fbf416dea1300 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -254,7 +254,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-			ret = status;
+			if (!ret)
+				ret = status;
 			goto out_unlock;
 		}
 
-- 
2.53.0



