Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD36B762E0;
	Mon, 15 Apr 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191920; cv=none; b=saFGGWI5gx2CohuVzDexKBPlP71ne+EDW3s+g++qS3xmT69HoK5JfUGrAua6QoAD9mHHX1pzW/xLq6ABsg7tPegVzbyDYqZsaaYZ/MuDi+8b5WrvsZzJehyO+VOTMGO07psV4elq2ADyKZ2QtL8R2rQpyUsMs9UGl0J27/1aPXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191920; c=relaxed/simple;
	bh=SJ0soXVBbIEDkcqkG6R7aD6Z3f4wgkFvJte7YnVIzVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSv3jPPN0+0QHoUFxyGIk7c7vlyFWcBDZLdScdclOTbx/4kNA+rf7qXXuZ97E+AU647al8Tk8e8O0gSXoYmd44VBmW2OAP/N4WCQIuIV1wyqjkqVBYJdTmcK5+99PhzEORu8zvA+qyQrAox3pI8/G6KSk82vOUF3xGM2oHmI50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDGX65jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDGX65jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F02C2BD10;
	Mon, 15 Apr 2024 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191920;
	bh=SJ0soXVBbIEDkcqkG6R7aD6Z3f4wgkFvJte7YnVIzVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDGX65jwWu5TJ0P+7GxZoNVtrKbmLmGl5U+htTR/cIBRve+kIMfFceISOeyxD1W3B
	 waPc25Y9Zq/beUaug6GzsU6nhZwVJNm8Lgr6lJStaVm49x1Cyx8oPDPZ5fmasNDljS
	 dN5uDR3dLcfz73vdX9eNyVXCKYjh6MT4hJFIoujY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 083/122] io_uring/net: restore msg_control on sendzc retry
Date: Mon, 15 Apr 2024 16:20:48 +0200
Message-ID: <20240415141955.867719147@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1274,6 +1274,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
+		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)


