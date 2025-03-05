Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F48245010;
	Wed,  5 Mar 2025 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198553; cv=none; b=Ktj5ySdIaHrKK7uw3UIAMhU6f36OX8VQdXbP/eeur5tobpPIVTuh+TlXF21KU9+FFkbJZHxoE+B+dCKX9KDvX2GsBsq7oV57+5XmKwozSwIS3DKkwTZGeYZmZoFws9x+MnE1r93b5liTxRD4higiYCS/7mHE9V9T2zZIcPYJJIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198553; c=relaxed/simple;
	bh=wD1EpZUV4+OUu5L9YCp2bFXgh4/xtbxffy4ymx6EzUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIa8BN1edXdhRd9oIZKM4F0jHrmAollD4/JM8nHtu5a0mn1VJ/D8d0YcoqXGgXuv2oematagHsa+61XoAlMdLOOItNR0SUP1twZGGUcJdu0E/P73V+pwRuul64mBQCzNLZNMtzqsetKNyliXjXdHU8OmLi4OybfTD4R6PFnrqgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZEslKu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZEslKu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F46C4CED1;
	Wed,  5 Mar 2025 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198553;
	bh=wD1EpZUV4+OUu5L9YCp2bFXgh4/xtbxffy4ymx6EzUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZEslKu3cbpnKfeLWSFFd5FuLdV/Mnr05bTh/NFIt+72CitKfWX3vA5ydihfqPQqH
	 XfpZl7/lYEv7/3PVrueOBfF8rxs3cQEqvOR2foeL4iU4mCFdPddoZHcrrIkk0+f9uf
	 1VNYlc9T6YcETcIw317FfSdXaUjsBOFZF5R/0oL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 068/157] io_uring/net: save msg_control for compat
Date: Wed,  5 Mar 2025 18:48:24 +0100
Message-ID: <20250305174508.034638128@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 6ebf05189dfc6d0d597c99a6448a4d1064439a18 ]

Match the compat part of io_sendmsg_copy_hdr() with its counterpart and
save msg_control.

Fixes: c55978024d123 ("io_uring/net: move receive multishot out of the generic msghdr path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2a8418821fe83d3b64350ad2b3c0303e9b732bbd.1740498502.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index b01bf900e3b94..96af3408792bb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -334,7 +334,9 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 		if (unlikely(ret))
 			return ret;
 
-		return __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		sr->msg_control = iomsg->msg.msg_control_user;
+		return ret;
 	}
 #endif
 
-- 
2.39.5



