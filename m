Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774491;
	b=RRhJAuHo9sz3VteVWKqFUO/JrOJj/fYdgNlkQ/sq+iejbXWCHk0dl66NHK50JQnriVJH
	 /RvIChw/G9nDauXTi74uNxN8hx4aFHjYhQURIdgxzN2yGiV01kCN1jPALgMmL0jSsyWVV
	 Kwq/J0JezA3jaa7Mmtrn0BIqj7/iN6Ewi6op62Vb+ER6y9grm2AIp3bws7qyli3ZBZ7xq
	 7EkNScwIUxIREDgbWcNb2qRCqpzDwt2+aQpn5oV9mS74M63AuK6M/AHqbuTQX2pRFkUJV
	 68Rg70fiL6yKLS64Ia691O0yfHtNdSxhDInmvWjlX+cFyor5mb41JQDNCxAG3LJlALA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYy+oWAv9LlNpDZlLWaB3vvqIndyKW7kItVGkb0Rdyw=;
	b=3UWIojNwESYRD6IvyNPdyg8YzgNR2mbItsYvIjiPvHNJxxLWTu5I6zH6/nV+bDHylvUK
	 QoHwQBe9DZAokmb7SkoAWm23TjJSXA+fg0xyHKVrWW+BFUAkFla9/hwsPCObYpbXf/idu
	 G3M68j8DA3c4q34qbdnakycoI8ndVxFHty9U4T/3wJKk0Wxb/mqv8d8FFLYYR37GkMoZ1
	 3r2dhwXHENnN2KfbFGneQcYgE0RnoxnHOoDMyj++Ot8HLXQEqW6gjkLf4isxbsCTyzbuM
	 zya5geINW2qJmFsXz762L0CGwcyR2JK1D6vgETegGs7QTCQ4K3zG0buX4Mumf74QEXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3mvfcbe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31ED606A31D;
	Fri, 23 Oct 2026 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3mvfcbe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B131F01825;
	Fri, 23 Oct 2026 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774490;
	bh=JYy+oWAv9LlNpDZlLWaB3vvqIndyKW7kItVGkb0Rdyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3mvfcbeRfgu6+Tt/+CDbvxqjb2zgLGvsyRyHX/r+qs7ZmWTwhg7XEJx4xIyVpES6
	 ZSjRnkmjFo1twlURmWb1wVRvHqZXhyO9x6PxOdL7lT/RIrU3JJbL8UpJXPoFT/3oQg
	 sP5fubxIldIKDrpNos4wEjP/3UyY/TpYAYDmlyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 059/242] pipe: preserve existing fasync readers on writer setup failure
Date: Fri, 23 Oct 2026 18:38:21 +0200
Message-ID: <20261023163715.178510860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 429b0714ec575..910be01a6c935 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -853,9 +853,11 @@ pipe_fasync(int fd, struct file *filp, int on)
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
 	mutex_unlock(&pipe->mutex);
-- 
2.53.0



