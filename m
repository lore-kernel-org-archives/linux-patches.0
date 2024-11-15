Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A372BB1B;
	Fri, 15 Nov 2024 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653827; cv=none; b=Oc6/nJGEpTSXXY+p2m1oOdZzuL+I9JrBCWuEXtADEfDjTbtltUogMcUBQ51Jwuz+KX/P9ERb1qJcnRGVYbVriGPVi9Y5uVF2f06rAyZQBqrG6mQWdhOZMmGs7lbYtb+2kTpwdxPIlaA6/hsEfyM2c27jyEIq9UPKpa2ET+gWvbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653827; c=relaxed/simple;
	bh=Fh8iS/bzL/yb5gH9oWygnPxH7WcOmrPBVI3uLAG4750=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idLDI5ryf9t8XITOJ9px7TyPu4y4S/VfRPZ8CHnzGqFh9QVA/YisC7B/Cy/mE6mZM15Ww61VL9Tjbgbhmkc79dEShojgHu6FQXbyVgpIbPINfAM1aIBm0wvBsmvi0joy84qCyCMGiEmujk8vUv5ibu9n03SJKhMZDCf0AWblJp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvGHnqbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvGHnqbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E47C4CECF;
	Fri, 15 Nov 2024 06:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653827;
	bh=Fh8iS/bzL/yb5gH9oWygnPxH7WcOmrPBVI3uLAG4750=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvGHnqbTl8WyqQDf0AzM8t8lBDkoi5+vMoTvKAxvRQ0YR6P1k65iMMH0QsuhVcCvc
	 VMnsoKnEaL9lddCr+zGUVuYyeSgOgSr9NVULSF2UIpFxzJX4w/D69f6DXkIrZzZ53y
	 eUECWo6rfhDabnr7AVAVaj2l5Ue9rwn4S67T7+ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.10 47/82] splice: dont generate zero-len segement bvecs
Date: Fri, 15 Nov 2024 07:38:24 +0100
Message-ID: <20241115063727.255293101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0f1d344feb534555a0dcd0beafb7211a37c5355e upstream.

iter_file_splice_write() may spawn bvec segments with zero-length. In
preparation for prohibiting them, filter out by hand at splice level.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/splice.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -662,12 +662,14 @@ iter_file_splice_write(struct pipe_inode
 
 		/* build the vector */
 		left = sd.total_len;
-		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++, n++) {
+		for (n = 0; !pipe_empty(head, tail) && left && n < nbufs; tail++) {
 			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
 			size_t this_len = buf->len;
 
-			if (this_len > left)
-				this_len = left;
+			/* zero-length bvecs are not supported, skip them */
+			if (!this_len)
+				continue;
+			this_len = min(this_len, left);
 
 			ret = pipe_buf_confirm(pipe, buf);
 			if (unlikely(ret)) {
@@ -680,6 +682,7 @@ iter_file_splice_write(struct pipe_inode
 			array[n].bv_len = this_len;
 			array[n].bv_offset = buf->offset;
 			left -= this_len;
+			n++;
 		}
 
 		iov_iter_bvec(&from, WRITE, array, n, sd.total_len - left);


