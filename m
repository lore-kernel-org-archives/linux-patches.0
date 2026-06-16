Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112054779B9;
	Tue, 16 Jun 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631403; cv=none; b=WUwcIHNnt4STAUTZ2hrM/Qyf+HV1RDMINH5kFpvD5mbiCBhSpNv4u7eqtEO4ItfjPlgG3pSqSucVobshD3EZSXiHqqwB3k+NrNHOE3PjR4R/2Uf6rW408uiFAWucjtIo+Qr/0MPVeL5DtI82Pp1QE9L84w8TuEajAQ7H5GdPuio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631403; c=relaxed/simple;
	bh=IVeAmcqRawQ9DXaXaj4e52oY7WWtitkhhFiLbmzWDcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/b6ICO5AhiLWvHl9U6BpwwwpI6mjcSrdIZvZpxM9aD1nI3Di7infGT465qok+QxqucpC2jzfg+o433/3tMZ1e/WZ9FT5dCLIT6rcZ7l/Fr9hg35qFTS10aRUsXH7OY00HjcyqzGAkJ1ofC0oOIpOq3PwWI76TzcWUAloIo8MN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYnr4qAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYnr4qAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91AD1F00A3D;
	Tue, 16 Jun 2026 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631401;
	bh=0iRq64NM0EgjQGO9TSAD70jwYY9Ujf3nTC2DaVwbTYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYnr4qAVW35YCZQk+HqJWHo9yoN/4M/Y+jMLkUs8CCG6DTaYkcg5gznOGJBNYL8Sz
	 btuu/MxcyFJsQsvgC9TdnR3wDWk2oOk0c0YPcJ393s696F+qejnXumQLh7JaOX6vd5
	 quD9Wux3Nw4VnV1XzRlHIhVB+n+Yd9LBiYxBvU+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.1 171/522] serial: sh-sci: fix memory region release in error path
Date: Tue, 16 Jun 2026 20:25:18 +0530
Message-ID: <20260616145134.152948473@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2757,7 +2757,7 @@ static int sci_request_port(struct uart_
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


