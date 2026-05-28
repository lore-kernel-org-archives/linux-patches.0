Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08BC25F7B9;
	Thu, 28 May 2026 20:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000305; cv=none; b=C9neTLVJI6XUl2r/DtdGAaItqt4uMZ2KTyunJIQHgZJB66o4dQLPgpZlkgJbh5g3vdtF79GdTsUxWo3uIUJxLWgFuM5EPj7DeUrAoEl9oPngRQOvIq5tjNTIhPHlW57tJSzqdW7FjlQODPs/fgxG+qn3IkGkiJ+3CLYCGSbocCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000305; c=relaxed/simple;
	bh=cbyb6xiL+qrVlyCQjqFVbDIzcyq/vfpw42kOoAvpX98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHsWxup0rmbTiFdrk9R3IYhE29odjWDhTdkA5wGf2SMRC041Ej7ZcqOimFpTq4V6baKkin+uKwu1z5h9rLZt6+t+YNOFFSM5VWE1t5elJjoEq5ywPuv2Cn2r29h5OlvJkUVHHrtbi3ByTZ8xRwZazhLci1qfUs1/ZLAEpK2QhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBohxnqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBohxnqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292751F000E9;
	Thu, 28 May 2026 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000304;
	bh=vJ1btQp0bgwJRxeVFt6Iny6pp5maOKwQcBdSalYiyEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBohxnqRAITQNylqkDM2IKTuk9PuHCgRQd4Wa39WHeRpaCugOMT1BNp6RZvTBDvBZ
	 Q8FUM5/Kw2CS8Rucs3EgO5L5gsh9hqjX8Wwmn1Sgtc6ND7V55wlsXhGM7wza1a6XwG
	 PdR7ConP0iZ2PnMv8KTD3J9a/Z/0EkBRlmJHxcnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/377] io_uring/nop: pass all errors to userspace
Date: Thu, 28 May 2026 21:50:13 +0200
Message-ID: <20260528194649.287956295@linuxfoundation.org>
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



