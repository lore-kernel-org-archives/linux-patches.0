Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21404657F8;
	Tue, 16 Jun 2026 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628987; cv=none; b=eWzjd13Yhaku+Wn8a9GMuT01TamdZE47FcpIlWeXkXA5BL5Z3e5VUnhVuWtkf/wbKB4/JjZp0D5Nh/i2LtTfolIpbDOlKtxF2UWvKb/ePe/P+HHpWRY9j2LaCG0vnIfG57FTIdFlX66jcF8obkbr/MYFq1Ut31c+8UL/KSCmYp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628987; c=relaxed/simple;
	bh=qNT0VzR4qHCvNFLzdyEKYmnlUur4pK7iCrzD3hwQXn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYelFz3VgG3pLOi1lWKfW+Q/jS5eWOd3QFmWpDB9S8fztv6btK0cv6gRahdzKrrrunRcEc+WgTiEc7xAfsbMpV1Xr8jy1eszc+fiaGfzf+fo6TXofy1/DLQeGN59Mufae5286Ovzfa/YHfcNfd30lPYOguN2gd9cuO68O5WBbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GV5WtL/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GV5WtL/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB901F00A3A;
	Tue, 16 Jun 2026 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628985;
	bh=eqv8prrRoX/HeNVOh3OqpJk/Xwiqbv3j0ivp/i3Qs6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GV5WtL/4PCiVuaBMADwvkqZZ1HUXC4PTxXOvb0sTx6lPwTTI8W/HseDjwP8OVJta1
	 Ehr928gOTQoRIYXnZ+JTNb+gr+zrumQu0C9ocZhSgC2VLa1GkK7i5ZtTH/M15egC9Y
	 MluxWR3OJL68t4spStxmfWfqoorlP1uV1GYqKjvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.6 182/452] serial: sh-sci: fix memory region release in error path
Date: Tue, 16 Jun 2026 20:26:49 +0530
Message-ID: <20260616145127.411456328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2818,7 +2818,7 @@ static int sci_request_port(struct uart_
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


