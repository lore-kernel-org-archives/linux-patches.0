Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E282512C7;
	Wed,  5 Mar 2025 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197404; cv=none; b=JF8hODuYIZXrIZ1TaAXG56AP75fsK4b24on5HBdQEudFNYbt9j/aGrRUqvb0PfX5SOLmdJQaBVhq8rXsr/cHEMW6nPZuH88QrYYV0vOIdZ5PbOeFCyJCCOr/a4CsLU40rfUUAzgpLvPS2vV1H5wdclltDSGM2oQTaAdVFNh0qhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197404; c=relaxed/simple;
	bh=snfQVagxoWzKhJfYrwSTw7Gmle0qBdgLtDe1DThVCgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/+FWuBAgBu2FWEUNGY96NK0752wkOUWtUGjOlMFFN9vU0aKfD+wz+me1oDMNI7kATtGuBN76TyGEq7x8GZ14cO2Shk+5cC/a3GReJEUzcT/LFuxLDKFLjzkNHe+G02J7TsOW5Uj7SOc1j+Z8mqhmBdrjJb2ODgbybkSdBkREpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/do2y97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/do2y97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2024CC4CED1;
	Wed,  5 Mar 2025 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197404;
	bh=snfQVagxoWzKhJfYrwSTw7Gmle0qBdgLtDe1DThVCgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/do2y97cRDzGYcyPk/MNoebNEQZPfQ4VxNdH9U6T6Gh5jkIX80DaapUZAhheIXCA
	 18xLgOVfOCDOuE4YNDOormrq9IFdxsds/abfYdtlKukCkw6vNaBP0emcsxMo6kfCSq
	 ltZLb4pYOZAhDDtzlJJhxcduMSTQ8d/u9HUmBUD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/176] io_uring/net: save msg_control for compat
Date: Wed,  5 Mar 2025 18:48:34 +0100
Message-ID: <20250305174511.266715816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc7c1e44ec47b..d56e8a47e50f2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -282,7 +282,9 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
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



