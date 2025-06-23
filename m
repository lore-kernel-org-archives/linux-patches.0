Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B5239E63;
	Mon, 23 Jun 2025 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685430; cv=none; b=QxLzilQ336+DfPJYIH9Ha2seBtW2sIcYETnLAhqqBMBlbcNSfAfByd7RvsfbX5RLRdjXRaoCVBpbz9ALZyN6UNH7ccSMC++IZqb4EF5tPNDO9nHOGekEQzmVxNJxV6KLWG0YXZt94cOnL1mGgsc574svvkuncF89hhYo2c/xE58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685430; c=relaxed/simple;
	bh=5HC79Q3vnBWcO5uXX11McV3jaw5I91P0tExuTXiEjAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR4EfnLISFo3dUwQlilAEJCsMeMtRsWiBGwPwNKWsxJMheNve/VbvbTGkwydg/l92m4mCIKXp08xR2RCpmGihy1FuJL5WVlMkVo46WpsmGUEmXSrg3usS6lG4STfONUKOZTgvw2QS8PrsQ+W6kblPSdlhlemMyUox3wBVmqjsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LP41pKhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LP41pKhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B114C4CEEA;
	Mon, 23 Jun 2025 13:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685430;
	bh=5HC79Q3vnBWcO5uXX11McV3jaw5I91P0tExuTXiEjAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP41pKhXkqiACzWmjszudvT5vngYhBPM2OJ1Qt37oDaPaM8/rKzCATzEhZKIhxomn
	 3C96ffWxpzm4FgoPTG0auOgg/4QwrP2+Y00oMSUvKjg1oSFrOOgPhuqvDViBRt6jHk
	 yPOlqpnxLAa0VMRKhwz22O/zzunuxStbqk+VPdVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 007/290] io_uring/kbuf: account ring io_buffer_list memory
Date: Mon, 23 Jun 2025 15:04:28 +0200
Message-ID: <20250623130627.180005109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 475a8d30371604a6363da8e304a608a5959afc40 upstream.

Follow the non-ringed pbuf struct io_buffer_list allocations and account
it against the memcg. There is low chance of that being an actual
problem as ring provided buffer should either pin user memory or
allocate it, which is already accounted.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -560,7 +560,7 @@ int io_register_pbuf_ring(struct io_ring
 		io_destroy_bl(ctx, bl);
 	}
 
-	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
 


