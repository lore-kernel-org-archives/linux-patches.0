Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209966;
	b=N6h26u3qOCoqvL177R4XKRpM9Gtr9l4p6kdS+9Yqt7Cl6KGsoCEXEkDJb/OSNL9dRZIG
	 Mkc1fRWGH11FnaQuwfob+KRdh4vDAto/jrtfhTdM5foe2y+ANXByBD8QJvvdzaVtAI1Sf
	 wzdVyO8p1I3MWiL6LU1+xFvmM84kNG6M7GyHjKFa4cROMuXv17EGhjsbtvHY5/wORaJc7
	 OaxBHVL6gYStUWsMAAQDliVCC1eZebDxUCBPv3w0PApL6p3mNPRCGTlBADBwsHuRmAWsG
	 3RJSEzvcClZpqdmk+hZI7AB6GrJj6SeDmaFsaxsz9TkysI+8HSNg+SQ3WhdViDb2NDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cngq/ugPpuzolfit3VfE638GDAtAw5BJ/tTUh9REWKY=;
	b=ctDkDXEQkb28/fLSARi73HQvjynbsnKExp2Ir+k6xHRkz4X6NX90tQKfoGIdvDaVjkjk
	 lpI15YpFD8gOYZBWIxq93Lbuq3UK7+uu3AiathArgdFgw4alPx9NSPG5UbPkKbI9JPT88
	 9xMbBZHduuZezQ0FsmQeoyci4gjEsFkDK9O5IHQ76jzJxEuWTRi+C7fkxWixBS+CHyDHs
	 XK+0EHU+MFR/wb0nmaeogpGj78JkNy/sVW8T8LJF1ZlHMNg0EtoVfRV8BstTDIXpXWD1k
	 YFdUUiqZ19ZV8kQK1xoBTXN10RESitDXJbzKl27AassFZ9W6Xh5oaLSYB3IDlcPYZig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McKfsOe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD835606A31A;
	Wed, 28 Oct 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McKfsOe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3521F01825;
	Wed, 28 Oct 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209965;
	bh=cngq/ugPpuzolfit3VfE638GDAtAw5BJ/tTUh9REWKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McKfsOe9k0dn2KFwUdf8D8/XRt8TImFg36nwWdGH9mHm5urUt/Cqxt4xgajuPCDZK
	 OqA2e0SZtxhPHAI7vlF95lFdXmGXDRSMdrhoepucChXXOt9MpDfIyyQPxsBWFQ7m50
	 zs1YTuzzw5ImJwSTiLemzXZmfUa8q0NlVzPBV1es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/168] pipe: preserve existing fasync readers on writer setup failure
Date: Wed, 28 Oct 2026 17:59:25 +0100
Message-ID: <20261028165943.787618264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
index ba4376341ddd2..2ad7eba72b35a 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -751,9 +751,11 @@ pipe_fasync(int fd, struct file *filp, int on)
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



