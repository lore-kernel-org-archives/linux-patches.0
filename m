Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBBF35A3AD;
	Mon,  4 May 2026 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903954; cv=none; b=oQ8uJB+B5upY4TtYRq9SoagesigP9/RNrCH3aESbLThc61ovIX8lfOcrLrdNfJ84BmnDRk3mBKG9HxK+tfiWdLsEw1CYGGCyQlZtwemhIxSOVnEN1hyxEa58F2NtlemrjHTat0DudEmcaSXQUSOCApp9UfHs9RFxt7nYP1kzHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903954; c=relaxed/simple;
	bh=Rox3pwTqQuI+KopRltdVN4gK/RwnHhajuHIZ5pxl1T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bjw5Ahw3BP3bIjWg+BEA9G4sqNTqWPdr0LN2StuyA28wSm3OlSDoGtUF41Q+rHiG9LQE52b/HAft7DlfPlExgC6JfcVpjf+YfxxEbye6MvX7/YplGdP01yBKEsfOGrOyWsekJ57ycvStdlY5Udf5Tvv8rjrkvDWClUh+8RoSaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlEaK0L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlEaK0L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B96C2BCB8;
	Mon,  4 May 2026 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903953;
	bh=Rox3pwTqQuI+KopRltdVN4gK/RwnHhajuHIZ5pxl1T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlEaK0L1UMZhkSuXdQV/vhJTVE0Rzxwgs86RfENRkYWLGyC5dczEjLDnR5PhyGS4q
	 QL805UFuXDjqBRT1AIF627e+72hdHP77hu7OV8459sZgsGdE0inPHYl+2jPObjoF/z
	 f3Z6PNG8prPeJi2asnIuutjOj+OiIdmhE10uAYTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 094/275] io_uring/timeout: check unused sqe fields
Date: Mon,  4 May 2026 15:50:34 +0200
Message-ID: <20260504135146.410926513@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 484ae637a3e3d909718de7c07afd3bb34b6b8504 upstream.

Zero check unused SQE fields addr3 and pad2 for timeout and timeout
update requests. They're not needed now, but could be used sometime
in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -445,6 +445,8 @@ int io_timeout_remove_prep(struct io_kio
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -517,6 +519,8 @@ static int __io_timeout_prep(struct io_k
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)


