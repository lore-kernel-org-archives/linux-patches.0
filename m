Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7851136A36C;
	Tue, 16 Jun 2026 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633887; cv=none; b=DWXaBJvX47+n2mCRcEv/QdXhtOVgQU+GE/2vLIN19Se6e9biWo//DfGoYHTTa9QI7mQmel5seE1fFJ//jxBtAha9SxBLFmVoKPgrzBVcIU/tKn4gl4cedhdLD2ZVV0kNpvGE30IbeqaliNaSsw8lOI2ucDbcRzvXa1COese7BAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633887; c=relaxed/simple;
	bh=iwqpDXDyLtNlG9ERqXq8Wuzt2xnyP7KN6SmOb1jUJ3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1k5qlhmxnwgbsx6h/2EPbabyyR5ZaEhP8J/RK65BmyoXeNH9wFadPczK4xE6enpqxwQZnL4qQZHbD2ktP+QF1J9v/JecYOoJSO0cSMpb45AW7vdru7dIpxpatRplHyhsldccjZSO1UzrfcSgPz7Bs4r+PySIFC7ml8Zjd8/JG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXC9ROHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXC9ROHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836321F00A3A;
	Tue, 16 Jun 2026 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633886;
	bh=KRhI3wovD0A92cYjbW1GrDbTLgBeohmbkIjH8LAteI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXC9ROHDd3JNEHCOzApciYoFTnfGgLSQmsgyaN5YerGF/8waVzRUoE/PDxPm1nDmZ
	 z1H77CzRAiehPHiYfEM4AfUjCZXkb0KlyDX/Xs6+ARCbJSVJ2F8juHx1j+HmnP0nDv
	 78WysLpXHJSs6TfV0R0UmfM14b9zzt0mSact+6Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.15 129/411] serial: sh-sci: fix memory region release in error path
Date: Tue, 16 Jun 2026 20:26:07 +0530
Message-ID: <20260616145107.186341127@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2753,7 +2753,7 @@ static int sci_request_port(struct uart_
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


