Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB8C402B8F;
	Thu, 28 May 2026 20:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999233; cv=none; b=HSzqhX6frD2h2pGvLuvBynVR8KbSH7dfZi4z5xzlrBKAOOW+Vbd/G8dcNwLnwsJ2n+oBGp8zfwsae0G9s4b9GS93S1du49p24my19WHEUSl4ukuJLVgbAztND7dvQyafquQs7NHXMt+kiCXb6KnUgqej75zSTqlXK94x9Xb+nnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999233; c=relaxed/simple;
	bh=jYIUvwx7QWAgxzX6mGKuMZDbQMGImy91rJaKDluFf7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRcuJ373gEc7lwuN/vtHJ1qu82WApTMsDO81DftzSVhdIA6lpvSt6rkeuZtwjjQRf9nATcaNsXHSYcdDADkbwUUA6K+ryN16O1isQL6b48AH0RMaLZyX++RBo9R3TNS47qqiLJsROI49fBCzM/HLkrcY2cQRym7rLzSp/m7wAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZzNjh0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZzNjh0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D571F000E9;
	Thu, 28 May 2026 20:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999232;
	bh=8EizOH48mP3bi3mwhITLbwOF+n4ve5OaKe5J5V3XEKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZzNjh0WYmBcdhIeyagOcN1r5r0nS3K/anN/H/r0fwPvAlnj4W1lxgTdGbpNbQ3OH
	 YftQruZzu7G8Dg11WHNIZBXIijjBXuOAVA2ESHU6wlWaffrlyjavq4R7b79iDN0aU1
	 4tWDcFF+WLzztdc9s6P6WDHncf047S1oted0GuoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 455/461] io_uring/nop: pass all errors to userspace
Date: Thu, 28 May 2026 21:49:44 +0200
Message-ID: <20260528194700.709940258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit e97ff8b62d4690c69297f0f6de874f0564cc01a4 ]

This fixes an inconsistency where io_nop() called req_set_fail()
based on ret, but passed just nop->result to userspace.
Originally, ret is a even copy of nop->result, but is set to an error
when such happens subsequently. Now that's also passed to userspace.

Fixes: a85f31052bce ("io_uring/nop: add support for testing registered files and buffers")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260520180045.538533-1-grandmaster@al2klimov.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/nop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index 3caf07878f8ac..f5c9969e7f64a 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -79,9 +79,9 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	if (nop->flags & IORING_NOP_CQE32)
-		io_req_set_res32(req, nop->result, 0, nop->extra1, nop->extra2);
+		io_req_set_res32(req, ret, 0, nop->extra1, nop->extra2);
 	else
-		io_req_set_res(req, nop->result, 0);
+		io_req_set_res(req, ret, 0);
 	if (nop->flags & IORING_NOP_TW) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
-- 
2.53.0



