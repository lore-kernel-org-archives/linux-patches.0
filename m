Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A91C6AB;
	Mon,  4 Mar 2024 21:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588787; cv=none; b=ipqUIemUNpoCVujMw76MzUKYUnRI5N5gX6dGSx+5JBiYyoK/RK36fqAJhmPZwRJD6elCCRR7Nr8md2Ro0K68ODJQgUZX3va38qpvKn0Om7VfSlJwgKoffvhtLL6tPMCRkcVDAHTFFLzVHNROpmr/lIekOC7L2QdTIPutKEiPOpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588787; c=relaxed/simple;
	bh=UTuIVDMYcL3Yj8YnfPJXnl2w7S4JKSyFVERO2EGaxgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9MBr/Gfzx8VJUa3wZugga++eCXEb75ksniYbfRZMRZ5Gp+o9qXhbJsq6MTahPvBmH9CXeIBMAuk4aIaFbyY9gDkFjm5x8Yk98ZfOGIXN5BZncybC9zcvE24VUMp6pO4EPXJJATOXG57qQRi1LIZ95p4p6ZMgZgg+ckTw3R+6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUoRnHv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUoRnHv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C31C433F1;
	Mon,  4 Mar 2024 21:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588787;
	bh=UTuIVDMYcL3Yj8YnfPJXnl2w7S4JKSyFVERO2EGaxgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUoRnHv3dzPqnpyy65/RlVVwVQHuzz1IcERJtBInGx79Uc10GJG+B6f4dFHhbnY37
	 Nm7izBu5Xpv0Bmr8s/+ev+6702D5tKPyhca/nME7lybwb8FARjZdYNvpfOkq2XPNgB
	 xDOzjPiwFmYEut4NvviRWfmENHN019JSkOpEHGC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 072/215] tomoyo: fix UAF write bug in tomoyo_write_control()
Date: Mon,  4 Mar 2024 21:22:15 +0000
Message-ID: <20240304211559.264564763@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2648,13 +2648,14 @@ ssize_t tomoyo_write_control(struct tomo
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


