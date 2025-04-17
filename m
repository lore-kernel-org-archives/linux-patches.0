Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E882566DE;
	Thu, 17 Apr 2025 18:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915807; cv=none; b=GYNo0rT/znsfTngAwQSt5PAhAmpIn5zy3ss06FoC0rcUANBWaPAdHQX5/jIOkIruvzvy7yA9BaBZ17C0e7O2bMsSK393K0YVlaXruQcuXxtVRW0g2OEk2+R3ETS2hF+S/sPGfMUQEg2PsbOVzdZ926q+OG1tBhYYMvmLAUXtcNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915807; c=relaxed/simple;
	bh=TsKmtBUI8Em/aDBBEIyTtjplMwwVtLu8X9AvKQd0hGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmnOKmUJbEImF4DkDMUd/Mw/sfrDRPasS2lBwPDIQ52t4QtEKzUUd9N6ZXPTXf88aR4LdxW2rjUSVe45EhXaw7TKwK90K3iepOrB069b5vR91o+A4i2Mme3ocJAHybbdGOPfk5g3RkX4ZCGqByA39G3SukJ5VgtVds25wkhvROM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wX43ES8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wX43ES8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC0EC4CEE4;
	Thu, 17 Apr 2025 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915807;
	bh=TsKmtBUI8Em/aDBBEIyTtjplMwwVtLu8X9AvKQd0hGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wX43ES8+1S3sjLcRthvhrB2tS0l4iCcO5boZ+5Kg1hXWpMQ5qIWqbG/19uHsr2HtU
	 Jbexf1oW9l1MOej2+s/QAU5chrXeFGMaOoUHq9ur8BD8HxKytdD9o9AlhXoaOc4HRu
	 Xz03FvT4m+AI4FpKJZyTcaOK7bscKQ12bgx51reI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 246/393] io_uring/net: fix accept multishot handling
Date: Thu, 17 Apr 2025 19:50:55 +0200
Message-ID: <20250417175117.486705946@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f6a89bf5278d6e15016a736db67043560d1b50d5 upstream.

REQ_F_APOLL_MULTISHOT doesn't guarantee it's executed from the multishot
context, so a multishot accept may get executed inline, fail
io_req_post_cqe(), and ask the core code to kill the request with
-ECANCELED by returning IOU_STOP_MULTISHOT even when a socket has been
accepted and installed.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/51c6deb01feaa78b08565ca8f24843c017f5bc80.1740331076.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1616,6 +1616,8 @@ retry:
 	}
 
 	io_req_set_res(req, ret, cflags);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 


