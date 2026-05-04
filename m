Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6E63DE42D;
	Mon,  4 May 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903120; cv=none; b=RTKURLdcsxNwMGeGRQT2orAFok5JJWyeqhk5wOj8AlJNgmRubL15uaB6mX/6M3MAhrzqVxmysdbsZxp2Wv/E0B1F0DPlqRrsjN5oIjtfKDMjZzte+FHxuxO1vVxUMcLkOIu4btZWw3+m5juCCtdCx40MXTYgVJ8MDHDAlIQx8l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903120; c=relaxed/simple;
	bh=SQs2lhRKbdZPXH3oniMSNDkbnQR6p8DrF8hhhthxglE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM8y1+5GzjQ64PEBaJFbNjgJOqiZuvocdSINUcnIrLcAF1HKZPJBIRQvbXmtKyZS/aRfkOiNiVCibbGQEYcqnTGSNYFCwJN19cZbjlQR8mKlxM3z+CptY2UWgW31Zwt1XF1+/XBy3XQ+8Nokhv4dMPFJyB65Ax+OqKnEYPhLoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTecSZ5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTecSZ5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56624C2BCB8;
	Mon,  4 May 2026 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903120;
	bh=SQs2lhRKbdZPXH3oniMSNDkbnQR6p8DrF8hhhthxglE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTecSZ5iuoxwHBCsqRKGkcma1JZCFEMbB1RYmRN7sKHeIvboOwwPSRvHPLzarP5al
	 5L6jVyUfO5EUaFtYzG5Obb2EMsQFOYtnh+DytRfFGCzfj7T3ZZUg+DONcwV6m7nlav
	 WYzZunBQCYswN4UPZ2gvA7EvbsKYdctcTlCyuPeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 112/307] io_uring/zcrx: fix user_struct uaf
Date: Mon,  4 May 2026 15:49:57 +0200
Message-ID: <20260504135147.020984134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0fcccfd87152f957fa8312b841f6efef42a05a20 upstream.

io_free_rbuf_ring() usees a struct user_struct, which
io_zcrx_ifq_free() puts it down before destroying the ring.

Cc: stable@vger.kernel.org
Fixes: 5c686456a4e83 ("io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/e560ae00960d27a810522a7efc0e201c82dff351.1776760917.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -565,13 +565,13 @@ static void io_zcrx_ifq_free(struct io_z
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
-	free_uid(ifq->user);
 	if (ifq->mm_account)
 		mmdrop(ifq->mm_account);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
+	free_uid(ifq->user);
 	mutex_destroy(&ifq->pp_lock);
 	kfree(ifq);
 }


