Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624019;
	b=fNcC0L8F6kJDdS9uQlSHC3MInK5J0Csn3PBlKuTLR3op8iCPXhBChJWKpZ0UZFSKH7SS
	 arkCQ28wPZYiAonPNCCXH7lD6nhWASmK1IpAQddA9jUmXw7dZhq3BctgdD/iL4TdtSeGI
	 aHLYzQDnuKN05JIAl+F00gJ5CqPANOAlEwGf6lYV8ZpfC5fqzeCdzkG7zMiyGwR1rKIJN
	 L2yh2Mfv3tJuQThcyAlRIRx163hXaKRDAZCnDyMpWLNZY0JBV1EBtFajs2K7tc3YYI4XD
	 kyEErND1RZZUiw4ZZ3+G7/zOkZEh54wkGvo7+NCICLIjBkB6UOFP9+IJgow2Bp1I6Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDQr1iert29SGxKAod4P9xOewPcFY4k9vp949Oy9kS8=;
	b=QgqPUoQzVxIAs9oAmvakd2Zx9EmL5kmtA7t5OORaaI78/ihKgA3hoOtVcAznV1ouPSBO
	 YQU32EG+rh9Ujg8WUzi/ndPkNFJxz0WMBTwk6RUXk7pOaayicGQnRQJvQdvVwwgca1Gek
	 EvXNV0HMbQooA/hYfUgjJl0qbEQNAmHHvvcUqJjSurXgvygMWFTdbFCiApz2kR4859h5V
	 QRiha3Y9zyYomerJ+3vWMQJeqJbRQzGCoifnPdTlqdm1F55WZTaggbdgttQ9bpENrm+cu
	 Wou73/yoA5+qmiO7LG8ZQv202VleZ4lcekc5SOXh6ms+MyMhxhqhkoltziuTGfbTscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbU4dhbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40A606A32A;
	Wed, 25 Nov 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbU4dhbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41751F000D8;
	Wed, 25 Nov 2026 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624019;
	bh=JDQr1iert29SGxKAod4P9xOewPcFY4k9vp949Oy9kS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbU4dhbhMpkcDsmW+HvnEGVqWKVSUfQ1bh/606VbwX+ejV3GdxqqhSx7S96zNPiOU
	 GbxGRrgBnsevrxwHXm2dztefb59J20hriqhLqnGQ1zr32zCgZ56MAKp4PcEivLTUAP
	 MZmldyavzJf5b8HXI2pY6Bx7gZ1NMZO5sFpWx68Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/816] io_uring: fail soft links on negative IOU_COMPLETE results
Date: Wed, 25 Nov 2026 15:26:21 +0100
Message-ID: <20261125143849.984847147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 9ed19503a7b34e1ffb2b81236843204c473b0ae0 upstream.

Handlers such as fsync return IOU_COMPLETE with a negative cqe.res.
The old io_req_complete() path called req_set_fail() for res < 0.
After completions moved into the core, that check was dropped,
so IOSQE_IO_LINK dependents kept running after the head failed.

Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114041123.109163-1-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.12 has IOU_OK rather than IOU_COMPLETE]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 630b306a849f0..3f8a0f7e84f62 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1789,9 +1789,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (ret == IOU_OK) {
-		/* not all handlers take care of the internal restart codes */
-		if (unlikely(req->cqe.res <= -ERESTARTSYS))
-			req->cqe.res = io_fixup_restart_res(req->cqe.res);
+		if (unlikely(req->cqe.res < 0)) {
+			if (req->cqe.res <= -ERESTARTSYS)
+				req->cqe.res = io_fixup_restart_res(req->cqe.res);
+			req_set_fail(req);
+		}
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
-- 
2.53.0



