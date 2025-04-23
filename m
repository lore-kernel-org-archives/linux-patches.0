Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB15729617A;
	Wed, 23 Apr 2025 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421099; cv=none; b=O72zxe7cRQvCtFJ4heZEgvLoI6RZfGz7e9xw3tbyU1SEB4++5E8SgyG/Dvbzw8TIBFbaPAoY/6AyuLq8tUuYPLQdxDxOfRlAqBqaTj7FuRRJuVPkaEP8sTheQWemmS3rRjUqEECtxrtfSOm5haG9Eiex64nKGPZ9pmEcsiA63rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421099; c=relaxed/simple;
	bh=F1rFs6Z/i0LlplYGeIgPtmFH36mlcmy8rLOjshRBASk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKyaL24jzNQiOgq5o8/liiG/QQacaKkzg3GKjyeT0vXP2/TKFDZKN+h+T0VtgkzMkAa11pHCKwG5WkqxTQDJBeuJX7HgQ5HEdX+1/QaPMDPDApu4J1MCmI7clTOschNmaHVoiglgXh5EbbAILgtOaMYQ0qeyeSDdj9jg/Lon98o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJZNyieO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJZNyieO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1ABC4CEE8;
	Wed, 23 Apr 2025 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421099;
	bh=F1rFs6Z/i0LlplYGeIgPtmFH36mlcmy8rLOjshRBASk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJZNyieO7dXZUpwdcLq2f3Hfjq+ViXVcDkwYvn9fjxiJe/hrfUsUgfqCX6B3KCVCA
	 5dDRG4uZQYu9KJRahJEef0VrhlayF7bYQway3asl9qfFU0pvpEZlZ7zap+qEe4wbJE
	 sY6PAyVMNh2psEc3ZtE6x+SodIwzIw0bkouhdPQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 108/291] io_uring/kbuf: reject zero sized provided buffers
Date: Wed, 23 Apr 2025 16:41:37 +0200
Message-ID: <20250423142628.784051162@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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
@@ -336,6 +336,8 @@ int io_provide_buffers_prep(struct io_ki
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
+	if (!p->len)
+		return -EINVAL;
 
 	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
 				&size))


