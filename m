Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B792459FF;
	Mon, 23 Jun 2025 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684305; cv=none; b=iN64yoLNg1bozjjRUQV8kihPm2XkONQYgq5azODMscWLrmUThGjoix/a/Ymy4EHQmvVYS2vm+BV0HbSIu9h8eaLFKPLNSE5++Nv4i8iuOxhp6LD3y1cZ9NJhfzRZm451Ru6AUujU0rUP3xRYyn9ryLzIynLEjWvVDButvo/Ko5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684305; c=relaxed/simple;
	bh=Z+InN0LJH8lRUZYtcc2qQpN48gkPrIo0W7G/jgR3omA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuBLomhm6Lwt2nFG7TWW05fK9ByPoVjpOMJwGHVKWO+MqtY8SMwMX33rIIl38cqeLpFltNwY4qtu/tRJ1wKR9DHeoQE8S5I7s/N7zayjxjk5Mo3epL1fBObfAqFlhtvIWEeD3BPAouxE0htD/r8TZUl0B4uFBZdN9fCtifGR4S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXK8EB5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXK8EB5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A588C4CEEA;
	Mon, 23 Jun 2025 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684304;
	bh=Z+InN0LJH8lRUZYtcc2qQpN48gkPrIo0W7G/jgR3omA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXK8EB5NK4ILx9A25j6AIiswRsenFTEH7eeHHzGlYlQBx0XXylQMsEW/cHjQQHOs6
	 QVuBg+bk5B77jXMRYI9t4qYV2POZHZ2k323sikE2FdtManx5HIz3AlDGFIbX/TNytO
	 Ge5AmY9Yg936VH+oNz2hSGWWZM7Rlf/TeEjjVVxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 018/592] io_uring/kbuf: account ring io_buffer_list memory
Date: Mon, 23 Jun 2025 14:59:36 +0200
Message-ID: <20250623130700.659346089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -624,7 +624,7 @@ int io_register_pbuf_ring(struct io_ring
 		io_destroy_bl(ctx, bl);
 	}
 
-	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
 


