Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4D433AD;
	Mon, 15 Apr 2024 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192037; cv=none; b=JBjmRpgp6ujMdDdK+J+raS30cLgZu2+qXt5GBAUgx5pibuT5bnZ8J60QNHhCfYP04PiILMuAbh3s6Y06GcumrQVZ+hTczRh9RTwF+5aJKaZiHsiAAx3JmtVoG0iQwm3iCmzfgs4YjJz+g280CJ4qBEVCnnGhHf+Az7SxICJTPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192037; c=relaxed/simple;
	bh=iWUnAjcBqN6ThexP9dmBCiCFqrtkU14aAPZ8Fxh0a40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3cb914Lr+dUxD4QBp/ELttSO6Pgu7owYCk6nwQFgB0pngK+wsXvpDB2x6O1wKZW+dUh8RC7uYEfsdL2xNfTfG4l0t/puAuDy1BpPYPqFe7AQw04HH6WGCJ53EPBLc5WmAq4DPMUL7bLjiCyMONA2oJ8Aq3U/NwyuIXlgXAih5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLcRtar2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLcRtar2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99767C113CC;
	Mon, 15 Apr 2024 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192037;
	bh=iWUnAjcBqN6ThexP9dmBCiCFqrtkU14aAPZ8Fxh0a40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLcRtar2oFklQjpl9Ykaq9gP/qS/NRDmMj3MS1kJ+3hx7iPDiYnEP5xBJ3y+0xtXz
	 V5ZDNJgtEBD/ThxY7oTsOumMY006o1zfnBgWL2Z3V74kZtxYXUsVa33GxI+Q0Jrllp
	 wxWGFDnN+G27Uc98yRC4blbNgDldjkjp1xU5W3uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 44/69] io_uring/net: restore msg_control on sendzc retry
Date: Mon, 15 Apr 2024 16:21:15 +0200
Message-ID: <20240415141947.494048772@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 4fe82aedeb8a8cb09bfa60f55ab57b5c10a74ac4 upstream.

cac9e4418f4cb ("io_uring/net: save msghdr->msg_control for retries")
reinstatiates msg_control before every __sys_sendmsg_sock(), since the
function can overwrite the value in msghdr. We need to do same for
zerocopy sendmsg.

Cc: stable@vger.kernel.org
Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
Link: https://github.com/axboe/liburing/issues/1067
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/cc1d5d9df0576fa66ddad4420d240a98a020b267.1712596179.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1229,6 +1229,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
+		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)


