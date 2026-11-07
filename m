Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063769;
	b=SsNrPvePtCzpi+B/Id4PFiAkqC2Rqyjqr+uSQtllhTfvIVNeH5VeQyh3ODu/nc8AvYUo
	 q0OcGa4fnXECOwGgGCwidtE/LeynQM27yCNYv78TRp8ocwR2PumICD5bO84RHjteDYXTu
	 3OjpESpp6o7g9OBCVqsCxE+UOHu6UZzLoiQZS+HmlevpmjBWC8fx534prS9bMY5e4aUAo
	 JxCXyxkCiMwYwps4A7QcmYcLCKeq7pfgP24+2bCtKO8gS4PnjWWENRLxv/s9J75fEZlEw
	 dyXtoYreJfRFoQOBC71/i2CyFRd32o6pkA6Dyyc0GokhzVbcJzpC+dVnwSMqEwAvZjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E3M74m8FYOfvLFfehYzTcvy7QUvtMQy6Ze6cAppeah8=;
	b=VEtRcBuOVtfB7s7Hg+9+nYF1aJe/zf48ZPWlLBwZA0opMXFlBvWPabI86fnOywWALrZa
	 v0XEDhFpvvVvFMsaBZYMJP89GoESYY6EOUngmWGtKh4Ln8h6YGFpB35w/H9i0Z/MyS8Ce
	 LVBLY2GYPaApNEUF2+fRxUKfQSwSs8MTjpnhE3YdBt8hWOeX+TjpkDhYhO2kGB1eVe7wq
	 Xyt6wiu9BMK5KZt+n+7M9owCGHBz0ZeA4Z0R0NAEc0UiiKXiNsgZLs/ixKulT9lpMoylS
	 a/5lLNH+bnb5voTvcYbCqH07dRJbQnwFCZhRuMkuojmYXF54aQOeUKkHn5/33JUQBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iia0C1fD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B85960A261D;
	Sat,  7 Nov 2026 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iia0C1fD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECADD1F0089F;
	Sat,  7 Nov 2026 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063769;
	bh=E3M74m8FYOfvLFfehYzTcvy7QUvtMQy6Ze6cAppeah8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iia0C1fDh7r7iWnO/8TKP46psRsnVzCdE9Y+0msrBmMe0ryGdsw3KcS2r1Joq8+WO
	 jfnFt+RDQCfAfONSKHkynty9G0HsL5sl+850wOJ446/uVSM0c+Vfw6yuBcoTusQalu
	 blvwUwOoNSwJ54cXW3aciaOvmAWDrH9Hl5FCYpgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 861/869] iov_iter: fix NULL deref in iov_iter_alignment()
Date: Sat,  7 Nov 2026 08:59:03 -0500
Message-ID: <20261107134922.009452319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit a290a9e5cf5fbba05d6c59b94b36d00f4fc15ef2 ]

Since commit 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed
buffer import") io_import_fixed() hands out an empty ITER_BVEC for a
zero-length request. Its count is 0 and its bvec array is NULL.

iov_iter_alignment() only checks the count for ITER_UBUF. For ITER_BVEC
it calls iov_iter_alignment_bvec() and the do-while loop in there reads
bvec->bv_len before it looks at the count. So it dereferences NULL.

btrfs checks the alignment of a direct read with iov_iter_alignment()
before it looks at the count and f2fs does the same. So any user that
can open a file on btrfs can oops the kernel with a single zero-length
IORING_OP_READ_FIXED on an O_DIRECT file descriptor. With IOSQE_ASYNC
the oops happens in an io-wq worker. The dead worker stays on the worker
list and when the task that submitted the request exits io-wq writes to
the freed task_struct of the worker. That's just fallout from the oops
though.

Empty iterators with a NULL array aren't unusual. afs, tls and tipc
create them as well. So leave io_uring alone and make
iov_iter_alignment() return 0 for an empty iterator of any type.

Fixes: 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed buffer import")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261029-work-fs-ai-fixes-v1-3-88f22792f6f7@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 4bc7c19337558..b2eb629497a92 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -836,6 +836,10 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 		return 0;
 	}
 
+	/* An empty iterator may have no segment array at all. */
+	if (!i->count)
+		return 0;
+
 	/* iovec and kvec have identical layouts */
 	if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
 		return iov_iter_alignment_iovec(i);
-- 
2.53.0



