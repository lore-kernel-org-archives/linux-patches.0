Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA0835CB6B;
	Mon,  9 Feb 2026 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647300; cv=none; b=dnRhKHRJLEr9y5YO2TXay1wFApun7JY8kTtYH4Idf03Z7ZCQXqSa8GTQZEk6jGBzp2daKwDB3nZeVhBVYgdlUu5ZyJRdWKGDtMgQ8EAswyy1w4bwTyT81NVmsscZQr2Wn1ZpP6LiBSATR8wAF61ezJU/QYinr1WGqTVbCNFjZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647300; c=relaxed/simple;
	bh=G4T9tvOqAG4t1PSTeldRA2Ea7k8wgIsCVczuGOye3+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdnXEZWwlEF+kck/Nw/sJu1PC5Jg3Vnexf7kRREfaGEAHoRTnAo15WbhzQ9PX+g8Z8AytoX/0fnuhvE/JcV3midG1whymMIfYcxnhw3vZxXtP/mZGS/4P9Yeoc5rZ/VnI7FW/X4MmmRNht4mdM+Bxp18t0xxcUvaR3dnWV44UFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNM8ybil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNM8ybil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB035C116C6;
	Mon,  9 Feb 2026 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647300;
	bh=G4T9tvOqAG4t1PSTeldRA2Ea7k8wgIsCVczuGOye3+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNM8ybilgLGQSml0K2PnzfOw1iqTRCreKuZHfVpqVNgpKccECp+jGaIDhvNbXPxZN
	 kp3BJtdSSRXOjOerIp1wi2Kx+Kn3d/o9DaqcsosiMHNE//WYFt9QeZqIGq6l++2+en
	 PT//7WjBWwPRlA6rqAPLfQkk6ag+G1evvzyRlIzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Negrel <alexandre@negrel.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/175] io_uring: use GFP_NOWAIT for overflow CQEs on legacy rings
Date: Mon,  9 Feb 2026 15:22:12 +0100
Message-ID: <20260209142322.587056328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Negrel <alexandre@negrel.dev>

[ Upstream commit fc5ff2500976cd2710a7acecffd12d95ee4f98fc ]

Allocate the overflowing CQE with GFP_NOWAIT instead of GFP_ATOMIC. This
changes causes allocations to fail earlier in out-of-memory situations,
rather than being deferred. Using GFP_ATOMIC allows a process to exceed
memory limits.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220794
Signed-off-by: Alexandre Negrel <alexandre@negrel.dev>
Link: https://lore.kernel.org/io-uring/20251229201933.515797-1-alexandre@negrel.dev/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e97c495c18065..104192bcc8e4b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -897,7 +897,7 @@ static __cold bool io_cqe_overflow_locked(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 
-	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
 	return io_cqring_add_overflow(ctx, ocqe);
 }
 
-- 
2.51.0



