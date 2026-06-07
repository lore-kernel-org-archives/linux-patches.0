Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA73287510;
	Sun,  7 Jun 2026 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829741; cv=none; b=ee9gWS0+vBo+rhyCc84sHxsrr/ztobUN4BRXIgFD9nG7F816TUNfdPfiyZp992f/9CdUfdpIqY9f+5J8Ik3UEqpm/roaaLLCNe7lu08pQoDM02yfW+OE/TDIPga0rI0N2aMsKNEpIapIJThGHK1cNPOfwXu/E1//50nHuNNs3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829741; c=relaxed/simple;
	bh=bNMv7U7LNMIuBDoMYLHVvneLjd08G13jhoAtUjy9pU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nStzI+D7mLqA+7LuQb/XfKavkAT8XYFT+Q3eofcBr5M0xJxpVlxjRvREIzsXcZAnhHhzVhIrfLeCjchQJFGgiJWByROBVkP5QYog8V14h1H1YNQyfdjfbzoqN5KSVxs/GVJspelUraF+Uzn8SlaqayWwcE9Pk6AikMZ+wOj/+P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEXDnEbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEXDnEbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05291F00898;
	Sun,  7 Jun 2026 10:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829739;
	bh=NIAPMnb25kCTtAPDQGrALEAZFQ0fZkzIglJCI6Yt8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEXDnEbddSnK9NaxS4EspAwiTWr+1hV+vH646rV7odcLnlZivNScYrFvEjk78QNFN
	 4F9j4iW0wOmYKXVkr+CWBbxo0ZCRqgJUwBlzeye4oWIz49lrEB9HjlqHjhLQGknwe3
	 AWwUtRHFDsdV3g3n0rz/Ub7YcztfbRv5xYiczEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.12 250/307] serial: sh-sci: fix memory region release in error path
Date: Sun,  7 Jun 2026 12:00:47 +0200
Message-ID: <20260607095736.875842848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 92b1ea22454b08a39baef3a7290fb3ec50366616 upstream.

The sci_request_port() function uses request_mem_region() to reserve
I/O memory, but in the error path when sci_remap_port() fails, it
incorrectly calls release_resource() instead of release_mem_region().

This mismatch can cause resource accounting issues. Fix it by using
the correct release function, consistent with sci_release_port().

Fixes: e2651647080930a1 ("serial: sh-sci: Handle port memory region reservations.")
Cc: stable <stable@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202604032356.SzEjYkBC-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260421065737.724187-1-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2849,7 +2849,7 @@ static int sci_request_port(struct uart_
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


