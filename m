Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F101A9B48;
	Tue, 17 Jun 2025 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177036; cv=none; b=d3DKl5uCsTYYNxAv8fw5uXBI4gdygBu7LDqz/Qeqcf7vop05jZ3AtnjIm9AbhlwTYAoP9plm81c88IsxwKVI8U2VqaGbtkvismQamRSI6DNvU2Jk9MNq4k95ECv83JSaGS/N8oZo91PpFCifPnoLsV4Ff9POyeCpxOkuYRuXIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177036; c=relaxed/simple;
	bh=P+NIm/aAsH1HqHFxhVQ9Hqn1okmm5v2cIDL6DH3imGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE/TvXInINygdvkAKUwZ2EfZZ33XQop0tEqBUofS8XFywrt2rioEbyho841rIYkTZ9/+6zrGakMvoLKEKG50Hhp1oCvG7dVX4dlQamROzavObfR03sOFzDTPwtJ2sFv/Ryv5xUQT7qt9G/tqOXv5xXFNiTlAjNDd6w/6iuQnhnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK4rlbNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK4rlbNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF9EC4CEE3;
	Tue, 17 Jun 2025 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177035;
	bh=P+NIm/aAsH1HqHFxhVQ9Hqn1okmm5v2cIDL6DH3imGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OK4rlbNkYx6QBeomzaYtMFDcqEZ+4QkGGt77g39F4TxOREakh/bsExG8eplMN3MKM
	 U/OQjaKPz1bPpBGPIEB8/fy5fuNjV+pNzJniMTMTH0Ya/hr26T5X4BahiVARfItdTr
	 rreNYcWF/72oR3X2Go6CmqI+YniZ8fbgzunULqAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 341/356] io_uring/rw: fix wrong NOWAIT check in io_rw_init_file()
Date: Tue, 17 Jun 2025 17:27:36 +0200
Message-ID: <20250617152351.862961839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit ae6a888a4357131c01d85f4c91fb32552dd0bf70 upstream.

A previous commit improved how !FMODE_NOWAIT is dealt with, but
inadvertently negated a check whilst doing so. This caused -EAGAIN to be
returned from reading files with O_NONBLOCK set. Fix up the check for
REQ_F_SUPPORT_NOWAIT.

Reported-by: Julian Orth <ju.orth@gmail.com>
Link: https://github.com/axboe/liburing/issues/1270
Fixes: f7c913438533 ("io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -696,7 +696,7 @@ static int io_rw_init_file(struct io_kio
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
 	if (kiocb->ki_flags & IOCB_NOWAIT ||
-	    ((file->f_flags & O_NONBLOCK && (req->flags & REQ_F_SUPPORT_NOWAIT))))
+	    ((file->f_flags & O_NONBLOCK && !(req->flags & REQ_F_SUPPORT_NOWAIT))))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {


