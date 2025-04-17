Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183C1E25E1;
	Thu, 17 Apr 2025 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913294; cv=none; b=bcZpaomikBfWopF5RD2ote2ZjuZibuUueAa/x2Kzt0mcv4qs54r7GH3AhHoHFUFeEpTeYrxbr35KluLbvX6XS32IpgMbDS6xzw+1Q/kG1OcublPwLBYT4llOQdfeZbct48DAg7Jzy9IulbDAF9jqSb/VKGIjIvb44mWNRM+02z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913294; c=relaxed/simple;
	bh=ivKoTg2jSEt19kWylGaSGpZAdRmrvQsqM+OmCiQA/bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIldqc5pO3wyiQhok5Z6YANfj7QEeIOqd6p/+jR0GwCQ9mEZbJ05ur7DtXbXFYPePivJsF08lhDxL4aeR3u7E/3xjYf9afrrxJmHpJbA+otprsKwqZGkjqTWHD+KUGwgLXr2jQ5/9OLWalj+iiwwJN/+ZDvsbTcpqX99Rs1amP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8hDYFWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8hDYFWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55403C4CEE4;
	Thu, 17 Apr 2025 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913294;
	bh=ivKoTg2jSEt19kWylGaSGpZAdRmrvQsqM+OmCiQA/bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8hDYFWyunmA0qaVvgA19E1g9z6WJ9JPtrm5XHJYp0Xf8S5DJGxxXiW/x5ugtgVF+
	 b2WDBSB4iv21JjEV2mAqkpgzzrvm/JacL60DqSlBev6e3m9pEFI+QanS5LOTZjcPgH
	 0645XV9CO+pmVeH4W9toetepYF7worO7xp8ed9/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 290/449] io_uring/net: fix accept multishot handling
Date: Thu, 17 Apr 2025 19:49:38 +0200
Message-ID: <20250417175129.755538565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1650,6 +1650,8 @@ retry:
 	}
 
 	io_req_set_res(req, ret, cflags);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 


