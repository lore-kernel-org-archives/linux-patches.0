Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F51F1318;
	Wed,  6 Nov 2024 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897510; cv=none; b=YychqKBfYdGUneWfUo1ihg2zEIuz7BUkNESKmSMQwdn32No3LwxkwweIQB6flY2/dyjQa2WKtgfB7o+J0niq6HUIU+iVMnUCRQGNR0tlVoMCFS8PqDab1bEVMrXAqubYzEbvfxiL4bauPq3itkWx3wFgEk+xpVCM9tWDi1+pC98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897510; c=relaxed/simple;
	bh=8saJ8SkLUCldLK8mjQifWeUVOrJu2J+HLSyzoy/PRpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNx9Hb5zJegytm/Q76dUbKair+ZLfCtPphTXJfg+xRtI19Hw6qxFiL3UwBNS06HfbJIGTOJfTTcTmgITBIgZGQZHiPcnjoFbDygF0yOs2vYgCY7e4TyJXs4wSZkJYlzoSgKgngMRzMCHQ0OT/qwS1xDGXv0Zcy8Aw8Um23wccKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7xR8Mvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7xR8Mvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E958C4CED4;
	Wed,  6 Nov 2024 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897509;
	bh=8saJ8SkLUCldLK8mjQifWeUVOrJu2J+HLSyzoy/PRpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7xR8MvzjXwiw3gJBZ8jcz9Pc0x6P0ZVo9LAU8MaHIxZR2dSUIo67QZJYH/SUI8tx
	 X+urxkdOZi1ZeW5iAnz4pYryCfe+5K+CD6dTXWTQFOASiXpHa0//lQdNzGpjHC/FlK
	 RytgV1zadFDMq9pxqliOFQI3pPz28Td2oQPdToR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d121e098da06af416d23@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/151] bpf, test_run: Fix LIVE_FRAME frame update after a page has been recycled
Date: Wed,  6 Nov 2024 13:03:48 +0100
Message-ID: <20241106120309.933607951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit c40dd8c4732551605712985bc5b7045094c6458d ]

The test_run code detects whether a page has been modified and
re-initialises the xdp_frame structure if it has, using
xdp_update_frame_from_buff(). However, xdp_update_frame_from_buff()
doesn't touch frame->mem, so that wasn't correctly re-initialised, which
led to the pages from page_pool not being returned correctly. Syzbot
noticed this as a memory leak.

Fix this by also copying the frame->mem structure when re-initialising
the frame, like we do on initialisation of a new page from page_pool.

Fixes: e5995bc7e2ba ("bpf, test_run: fix crashes due to XDP frame overwriting/corruption")
Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Reported-by: syzbot+d121e098da06af416d23@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+d121e098da06af416d23@syzkaller.appspotmail.com
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://lore.kernel.org/bpf/20241030-test-run-mem-fix-v1-1-41e88e8cae43@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 12a2934b28ffb..905de361f8623 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -244,6 +244,7 @@ static void reset_ctx(struct xdp_page_head *head)
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
 	xdp_update_frame_from_buff(&head->ctx, head->frame);
+	head->frame->mem = head->orig_ctx.rxq->mem;
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
-- 
2.43.0



