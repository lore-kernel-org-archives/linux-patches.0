Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D30C29345A;
	Wed, 23 Apr 2025 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421186; cv=none; b=s1m2O4EgHtWJugtrBpFxptWZRv2Ww4R+QeuIl9p1Yc+0JvWOHGZ9c4UgnCOBpBSwL7iLXIZG0pc3DdOTG0E+Zx9jr4c64GG7Z5XzMtLq9fJ5xUnxpXjvLJpt1QWbR/h7tkLEQQq/E2URTvnUh2OyWDSL72bCl/3aMVrxrvMxiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421186; c=relaxed/simple;
	bh=hMZtWe+ViC4p9pX38ylzIArINd2Ju7HhtgpbFmY+xmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrJvuiEn5vPZ570tu7oPSY4XZy7eb1yXoFFr2WRZ7jgkOhTCaRRprRvC2jaLlDoVd4dqb0+cGZG5kT6XlvGpYb4F2WG8aswZ/pqCOMosMfuy4/o+oavx0WtfJHP5FLIiwS2b0XxjNnQUKQLeo+AtQcnB3bVKpQjBpoef3btgXAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pv5/PD2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pv5/PD2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2C5C4CEE2;
	Wed, 23 Apr 2025 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421186;
	bh=hMZtWe+ViC4p9pX38ylzIArINd2Ju7HhtgpbFmY+xmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pv5/PD2TAJeZMl3H1z9WFi2wNAq7BslqAS2TANf6gik28famYrTq7x+/CxigoB8cf
	 nHRmV4g5PCktFaVebwFPsOohhbZBWce4NDqps1y8eYfe9nE4FBSh1cuFWWnathgk4j
	 uZHIqfGVrDW6iqtBSeib2mgFOmjMY++UBFXMirMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 154/393] io_uring/kbuf: reject zero sized provided buffers
Date: Wed, 23 Apr 2025 16:40:50 +0200
Message-ID: <20250423142649.739829880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit cf960726eb65e8d0bfecbcce6cf95f47b1ffa6cc upstream.

This isn't fixing a real issue, but there's also zero point in going
through group and buffer setup, when the buffers are going to be
rejected once attempted to get used.

Cc: stable@vger.kernel.org
Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -321,6 +321,8 @@ int io_provide_buffers_prep(struct io_ki
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
+	if (!p->len)
+		return -EINVAL;
 
 	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
 				&size))


