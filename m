Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6721A76DE;
	Tue, 30 Jul 2024 17:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360202; cv=none; b=TI+loflRkZuLCIYZb+oSo+R4K+2YxztxX0FQT6ugwJfGb6u7ixxYdom0/OUVvZl6RJp45/r7vvPiKbUp4cu001Ys1FF5qteWn53rYjgEOqpIL0AERHaEJg7hWQtahgyG2TS8td4X/5LGDjx+Ou9EJ6wsrs2LWM98cdxjDBwJtSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360202; c=relaxed/simple;
	bh=2MD5ujnXg0V6CNOYIjBfEYYjD8nMSXcDPBFW0P9hKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPmKZndWa8iv1W4gpM1HKLBRxqToP//GMjzE5I4ReZ9M8ifljBPYsefQRFt9DrUZ4f0/mv+6s2Ul3prNxQdfgnMmfvoiHhnoakGJvfb4jZw0P94XhfnpRb0TT8q6t0HlTGsRsuWSSImBE8XltukEY40zXtjqRKATaZnY1JBlc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLGbVbuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLGbVbuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC00C32782;
	Tue, 30 Jul 2024 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360201;
	bh=2MD5ujnXg0V6CNOYIjBfEYYjD8nMSXcDPBFW0P9hKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLGbVbucg3noFpHCbxxQK7s2N2aOoK6e16QWUVFl4XwMFNrPse2A+EkBwIBcJukjh
	 SoyLzuwAFx2ocpUiD+lfkyDL9aAmT5FPyWiBO/95z/Ip4P7rqfhi1k3tvzQDmWQAQP
	 Z7GQ1BdA4MypgsZayuPbqbK5yknTIFea8x9zgU+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 596/809] io_uring: dont allow netpolling with SETUP_IOPOLL
Date: Tue, 30 Jul 2024 17:47:52 +0200
Message-ID: <20240730151748.370787918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit bd44d7e902c2b34c217d3b48874b079760ca7b6e upstream.

IORING_SETUP_IOPOLL rings don't have any netpoll handling, let's fail
attempts to register netpolling in this case, there might be people who
will mix up IOPOLL and netpoll.

Cc: stable@vger.kernel.org
Fixes: ef1186c1a875b ("io_uring: add register/unregister napi function")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1e7553aee0a8ae4edec6742cd6dd0c1e6914fba8.1721819383.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -222,6 +222,8 @@ int io_register_napi(struct io_ring_ctx
 	};
 	struct io_uring_napi napi;
 
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return -EINVAL;
 	if (copy_from_user(&napi, arg, sizeof(napi)))
 		return -EFAULT;
 	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)


