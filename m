Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD128F58;
	Mon,  4 Mar 2024 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588336; cv=none; b=e7C1zB0VA68LXVbE5ek34K0QblRsPCueYlHhsHNqOAftooenyiQKE/plN4uO8BbTco9yC4o/Qog/5sbd/f98ViN4CaX4pqzZUaxejo62a8SMIf4G6eRv96CMNPZSUQtFFBxz5dqcgn5LgF/3VfX++t5actlZx1OS6VWDYdbcu1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588336; c=relaxed/simple;
	bh=K7lDLTW7uvHzEfk9oYR1axjLSaA/Cb7y9wn7US2Jxlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ahj7jgDy+Gs0DNn4h8Tm7GSJgv6oYyHXchd3gmNC9/viG2yFQEdlFCNoGxdDhBv3FlpbS4mCRQdkWZjUARXybfxdPyEkOpqpYpVys+QaRpD6V5IQJbEk5alLiK3HYySucmgScX9u52gL+tinCAMj7B3601h34PgE/Gmicczua3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upYBd8Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upYBd8Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF63C433F1;
	Mon,  4 Mar 2024 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588336;
	bh=K7lDLTW7uvHzEfk9oYR1axjLSaA/Cb7y9wn7US2Jxlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upYBd8KwN+1IeYzqsuSRgyV95LgIzcmCVW78RcRY0ARTGRDzg41UEJRI+VKwRq+3P
	 W9hYbpi55heZHMGujoF2SsRVl5OAKa1968TSBzfxiaJ92/Eln598v7xQVxPNQqB3Xn
	 rD0vmLpwk8w0uF6UTiqAciP9izTe/yw1vVhHG58s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 068/143] tomoyo: fix UAF write bug in tomoyo_write_control()
Date: Mon,  4 Mar 2024 21:23:08 +0000
Message-ID: <20240304211552.101996889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 2f03fc340cac9ea1dc63cbf8c93dd2eb0f227815 upstream.

Since tomoyo_write_control() updates head->write_buf when write()
of long lines is requested, we need to fetch head->write_buf after
head->io_sem is held.  Otherwise, concurrent write() requests can
cause use-after-free-write and double-free problems.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Closes: https://lkml.kernel.org/r/CAEkJfYNDspuGxYx5kym8Lvp--D36CMDUErg4rxfWFJuPbbji8g@mail.gmail.com
Fixes: bd03a3e4c9a9 ("TOMOYO: Add policy namespace support.")
Cc:  <stable@vger.kernel.org> # Linux 3.1+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2649,13 +2649,14 @@ ssize_t tomoyo_write_control(struct tomo
 {
 	int error = buffer_len;
 	size_t avail_len = buffer_len;
-	char *cp0 = head->write_buf;
+	char *cp0;
 	int idx;
 
 	if (!head->write)
 		return -EINVAL;
 	if (mutex_lock_interruptible(&head->io_sem))
 		return -EINTR;
+	cp0 = head->write_buf;
 	head->read_user_buf_avail = 0;
 	idx = tomoyo_read_lock();
 	/* Read a line and dispatch it to the policy handler. */


