Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94F33AE1A2;
	Tue, 16 Jun 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635758; cv=none; b=hMe4vMGMneA3qnDWRXDJ2hq3bHJ18S8/MwGhPpySiS1xrZ6nJ23qSJS/RrUDyq3NHdBzCrXhO84JUTsuRarRpgSag9nX1AdbQjs1Wi9UrYOm35IhuXN+zNtn/tklbJ5Axkzu5IutEzOWbr8ah5q7Nc/lg3Yq5WdD5SRlIpgzfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635758; c=relaxed/simple;
	bh=YCxjCCk+od0D0xC6xsfdPR5DiJG2IbB1r7mdor2b2Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlKqeae0YcZ7DVHoE80IDdDeTB0hYQtwjrE9DTO0cP4UPTovCHitUmwS3vP+uXhVBMcGw+z0w65yYa7TEg1sO9g28+r3JMljnkPk+jek3mz+ZWlloVLYcMj8ImjTwVbK5Hh6HZCqbCBkMgCySzND7WEDwfWMe2pg376a8yO9S/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbwwNNIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbwwNNIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D626A1F000E9;
	Tue, 16 Jun 2026 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635757;
	bh=6ci9IeSx5QeSRKFdkJBg/g9RANlKEMyMRWNgdU3FO/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbwwNNIm9+aENLR399ZHY7X+BpeOYvzwRCI9ufYeKKf1KQrEBncmdUJHTVzYeZDDh
	 8o/vnpFJ055aMzhadVEdVpTdZUdB9rop+T7TlyWarQJ9zT51JJBE4OKsXINSL2/s3Y
	 7smYk2lHW57yBSA0UZhKwzb753FuM8Wd16W0qos4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.10 109/342] serial: sh-sci: fix memory region release in error path
Date: Tue, 16 Jun 2026 20:26:45 +0530
Message-ID: <20260616145053.303732446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2781,7 +2781,7 @@ static int sci_request_port(struct uart_
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


