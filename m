Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3801A257451;
	Thu, 17 Apr 2025 18:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915813; cv=none; b=Mm+GMpHbYPBacd+610Ict38F4tI0VuB9t2QwmFKpdsGXs56R6QO9svl79J3j80XCOLqPPf9TRDol+12s7a2449rS+HPzMGOxnLFaoz2oPXMU2XeMrH4nR0TL81/nNSD6mZfxD4Y99TTxiuXWs4mcR/Rp9Rgx7zxbajt0maK1hwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915813; c=relaxed/simple;
	bh=0KGsQlZ6RuS+B7anEAwebb+UIG34mYkR+Bxv2S8eH/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ2PWx6Nv4ulNHlt83iEyXgQ72J2cSnvhnSUaehaUXljN5KsmPOhbHSTR1oefqxsDp8aYGKKUocQQiko2rhlzC3pFlHDsBPqt+U7cmIEEUHi82gf2RgA4XOmgTqpAwjErTWe8cnxBy1o7WuA+ScAUBljmtTFI8nAmuPCTM4ifNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKzzd0R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKzzd0R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B2CC4CEE4;
	Thu, 17 Apr 2025 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915813;
	bh=0KGsQlZ6RuS+B7anEAwebb+UIG34mYkR+Bxv2S8eH/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKzzd0R0kuRoEtcbKujKNmNtThQ75DL1hZKmeocolMnSXe8a3kT5fdGp+hjGg/NfF
	 us7Z4imCGgdiH5n3A58Rmwn12TA4xNrWLctHA72hlXJYEgUAfHQ9pcsqn4/J3mCv3u
	 wn6Ojk3xrGYWg2VCFozdCTn9bNj6Tw3NB5i9F/80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 248/393] io_uring/kbuf: reject zero sized provided buffers
Date: Thu, 17 Apr 2025 19:50:57 +0200
Message-ID: <20250417175117.566133000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,6 +484,8 @@ int io_provide_buffers_prep(struct io_ki
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
+	if (!p->len)
+		return -EINVAL;
 
 	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
 				&size))


