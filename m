Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5022D12CDA5;
	Sun,  7 Jun 2026 10:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829872; cv=none; b=cQUk79psO681srtM7frzXKVmm4Uh+I2bBDy1jYDgP0Ii8GHsmd5YyItp4dMtUMugh8CGVdCKZwaoKZToHW8+EVSygozjvkK/T8Y/Y9xqBBH9GhKqZMWO12OEu3bFdmgqUpugZ5SsLtjh5EKLSEId2wc061KweXYC2iWG+UaMoZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829872; c=relaxed/simple;
	bh=oDZe7xrejT2IDUD0zJyIUKuoaTMYI6qiHwM/uWE8L00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRXLTMbtZIS5NUoimWUAG+ndjtDZ4KrBk98qUy4i2x0bxQlzmq9ZQAnV0eLHjeOdRZ1NYKLKk8/mSYEhypn5PRoxdhUsxTEJxaZ81xZhMVo2YIZd1GkSR05qRX6nTwFWTMca+ga2FHt/DehOBRwf4MjB35f+tH0De3AkQHw0avo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGbtiw5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGbtiw5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CD21F00893;
	Sun,  7 Jun 2026 10:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829871;
	bh=raumMo/N3OVuc0f+QTGURJweaKEL3SvpC9l9R4s0gFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGbtiw5pFM/mWxrJMogpqtN0Tjr2LJYuVv7k34LcNgA4N3r42aj3MH2/Og3Nv/D6S
	 jqnTRJq5iMCpY2IdlJI8EEavpdTmG8itk5G11KCrwB4LhaseXqtiQzfutXP2kvXXqf
	 vLFFvvdtFEZGf3GuRLwkiu9z+CNuldT+cnuUbsbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 7.0 299/332] serial: sh-sci: fix memory region release in error path
Date: Sun,  7 Jun 2026 12:01:08 +0200
Message-ID: <20260607095739.041686621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3024,7 +3024,7 @@ int sci_request_port(struct uart_port *p
 
 	ret = sci_remap_port(port);
 	if (unlikely(ret != 0)) {
-		release_resource(res);
+		release_mem_region(port->mapbase, sport->reg_size);
 		return ret;
 	}
 


