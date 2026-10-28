Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211758;
	b=U1UrGGlng3dNE0nJS2fEDdC4KdeMCDSrzRUJoB8WG4siUs7zyWdOZCU0/gUYgAdeanWH
	 swPjyMZc5Q03TIHvvTW0mKVvnMFpq7c5HBdxeabMWMBPWdFp3U+diQRVDOUqWBfc/ZvEs
	 wqeGBUltxFO1LPdh79sqJIesfVVlQkEbspF9KPlkAWP91JKcycYjcSGb6hCkihMzIT7Vu
	 M0pCRlJPPbcJpQ/3QDAyKa3l9d9zZ/bm3UhZIoOzBnYuWQV9cwAzDwxUEhq8QWM4krfBf
	 +jN+jEXp8qDxgYw3FbpZ0kd6RNzMEEtUUa2FhDOIPgxISVjxMleKBWuOod+kvBhMjmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L2Lj5kKlcsxCCPTCIKOduZXefWsN4ydVokmxMBfYjYY=;
	b=kOrfecJkUJLENsO3TxTKOokYpKVtzT5j+Qos7WOQj8QyjbRpDnHS3nY3h1pKLG99dGvG
	 1sYCJ7fYOg71OdimNs/A5HfGkB6q4nnSPfc1e6sDmwbBnw/nvYr0lFgCvSAkLN1NF4HlX
	 4/vkW0nYx5c9dsxNATI80FsU3+t6g335afPC08kDAmfvf6DWivnlEFzpPh0T0hw2zFoBA
	 1MvkqXPrpyyLPO2wH4W3c7w0uLZHgvctCdPpeBNLMg2zPZX6YTnLl8zVoX1XWI4W6HMP8
	 yZZ9OgcDzJ4xpPOtQA+KmzdUadEGvDHYPhd2rUsfJq3Wbsaq7C7pqqJZXC4r+jjTPZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ncByyv+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3232A606A32F;
	Wed, 28 Oct 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncByyv+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817BD1F01825;
	Wed, 28 Oct 2026 18:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211758;
	bh=L2Lj5kKlcsxCCPTCIKOduZXefWsN4ydVokmxMBfYjYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncByyv+/SHGAN3JG1cGShWe3hCnvWcch6GSvaq0mcVw42+nPS0SOYEkPtNNP32ncY
	 lS6c6vwo/G1Cikz7Q5xdjK/xPJWg5McgAuHVJEdfpR0agXmPno7daL1a5vwxmBZS8P
	 hR91ydutb1lcqw7oymp4RrTZOxvksPVX7mHXNk+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/571] pipe: preserve existing fasync readers on writer setup failure
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028170019.654700651@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 40bb03d3ea6f6a915218508819ecc4d7a7fa260d ]

F_SETFL and FIOASYNC decide whether to invoke ->fasync() before
pipe_fasync() takes pipe->mutex. Two enables of one O_RDWR FIFO can
therefore both enter the callback.

fasync_helper() allocates before checking for an existing entry. If the
first enable installs both entries, a second enable can update the
reader entry and then fail the allocation for the writer entry. The
error path removes the pre-existing reader entry, clearing FASYNC while
the writer entry remains registered. __fput() then skips ->fasync(), so a
later pipe notification can dereference the freed file or its f_owner.
An unprivileged memory-pressure reproducer triggers a KASAN
slab-use-after-free in send_sigio() through this path.

Keep the reader helper's result and undo the registration only if this
call added it. The pipe mutex serializes changes to both lists, so a
failed new registration still removes its reader, while a failed
duplicate preserves the existing registrations and FASYNC. Successful
duplicate enables continue to update fa_fd as before.

Fixes: 76398425bb06 ("Move FASYNC bit handling to f_op->fasync()")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 0a8095070b70e..117ae6af14e4d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -749,9 +749,11 @@ pipe_fasync(int fd, struct file *filp, int on)
 	if (filp->f_mode & FMODE_READ)
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 	if ((filp->f_mode & FMODE_WRITE) && retval >= 0) {
+		int read_ret = retval;
+
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-		if (retval < 0 && (filp->f_mode & FMODE_READ))
-			/* this can happen only if on == T */
+		/* Undo only a reader entry added by this call. */
+		if (retval < 0 && read_ret > 0)
 			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
 	}
 	__pipe_unlock(pipe);
-- 
2.53.0



