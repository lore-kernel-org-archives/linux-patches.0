Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3406A23AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECE7C433D2;
	Wed, 28 Dec 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246720;
	bh=SJq0HXEP6SaMc2nvEg74Yr7oXYudStapI1zLV51gV+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRUe2L+SO4ZssvV3BV8pse/Ih/CXJR+jkMKsTInreQdg3dhgW/WSpnTvfgMDfQ5DS
	 ZAN5dpZ7+CpTum7BjcxEopl73aSmZUI/pABFXt9iD1AfgIe3ZmXDTtNbuPfMtka8BE
	 CsVS2OqrOMKtfOo+rEFwX7Mcpf3FlT4G44oIupmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1139/1146] io_uring/net: ensure compat import handlers clear free_iov
Date: Wed, 28 Dec 2022 15:44:38 +0100
Message-Id: <20221228144401.080892905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 990a4de57e44f4f4cfc33c90d2ec5d285b7c8342 upstream.

If we're not allocating the vectors because the count is below
UIO_FASTIOV, we still do need to properly clear ->free_iov to prevent
an erronous free of on-stack data.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Fixes: 4c17a496a7a0 ("io_uring/net: fix cleanup double free free_iov init")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -479,6 +479,7 @@ static int __io_compat_recvmsg_copy_hdr(
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
+		iomsg->free_iov = NULL;
 		if (msg.msg_iovlen == 0) {
 			sr->len = 0;
 		} else if (msg.msg_iovlen > 1) {


