Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E953002A0;
	Thu, 28 May 2026 20:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999370; cv=none; b=h9ggPwzLUhnZ8pcS4DRs39YR5NScJwi0WoAaeEYEUib9XH6LmyynicL5bj9+bditXss6+QykgX1HTXUZr08R2+PaQSadrFGWdyAwtz8DspUrAPRBvlY0R3RVRWZ4QWHUiFCqmHQZTM627c6DDZ4F4c9b7aw5ZUw3aGFyrAweTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999370; c=relaxed/simple;
	bh=0OoILvkum6i2z1xi43+d3wtzNaX0/8Fj3cBF5PK/dEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQpVoPwzyiOFqEePyBhQbkHamTgg7jkrWDlU1KOZ02jtxUmeCwwiz94EV6kWYVHb6wKlh3U+jFX7IGQQ52oIk6bR4mneuoQ1OkK+2e+KbuABAbzQdb7FxVmjFMQUe52ybyvLem65TDMOqm98xOjG8y2Jrxin39x8JnNBH04r6YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNZTHXse; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNZTHXse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE0D1F000E9;
	Thu, 28 May 2026 20:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999369;
	bh=uNr79qMM9B8O7dTILUrFX8jbSpnNgRkELt3nb3wrDYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rNZTHXseFr3R+pxziAZW1ZtYDtv/nfsXYGCgbCD2tfow9TanTQbrk7xR9GdBo+Uqu
	 CYe2fdWvTMzeX0yKREGEhrRK2tfqDUMXe/UIkPMVyPtdFx1ChpxZVX8MG4JUIeuUOA
	 e0QahmY1jXtnOOW858X1f4oDlxTaaN6URoAU3Nj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 043/377] io_uring/waitid: clear waitid info before copying it to userspace
Date: Thu, 28 May 2026 21:44:41 +0200
Message-ID: <20260528194639.621236655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Heechan Kang <gganji11@naver.com>

commit 93d93f5f8da791e98159795c6ef683f45bd95d13 upstream.

IORING_OP_WAITID stores its result fields in struct io_waitid::info and
later copies them to userspace siginfo. The prep path initializes the
request arguments, but it does not initialize info itself.

If the wait operation completes without reporting a child event, the common
wait code can return without writing wo_info. In that case io_waitid_finish()
still copies iw->info to userspace, exposing stale bytes from the reused
io_kiocb command storage.

Clear the result storage during prep so the io_uring path matches the
regular waitid syscall, which uses a zero-initialized struct waitid_info.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Heechan Kang <gganji11@naver.com>
Link: https://patch.msgid.link/20260516184709.852814-1-gganji11@naver.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -258,6 +258,7 @@ int io_waitid_prep(struct io_kiocb *req,
 	iw->upid = READ_ONCE(sqe->fd);
 	iw->options = READ_ONCE(sqe->file_index);
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	memset(&iw->info, 0, sizeof(iw->info));
 	return 0;
 }
 


