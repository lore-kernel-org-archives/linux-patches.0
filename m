Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5049359FA9;
	Fri,  9 Jan 2026 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960482; cv=none; b=dMzsdKgMZaUQzmDEUF1cb9Pj6KAaerOI1qp05/Re8eSbUUDBEKSr35Lq/0Kv7acc8HIfbjwu6KUfzKpHjUZdk5HqUM026ZPLzCsRdSzzJvdZ4b2+++zOtNTU6/9YywHEX1FGSGLjeZii6WtVN32WconPSDhjhNRQwEszcu/9Zy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960482; c=relaxed/simple;
	bh=iZiQFYKoiMxWUfU0BLB0bquKeMtkMPxrS6v6kXLwMRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0Wk/fQ71EXCLSPYuZZmqGDqrLSdR7gBFsu/yvu1WH8nvpBykZVvFUZ3+2XIypkvUs+ZdPxUtPtqXwkBuqHUKQz3Y6RNzriDx2Ad/mWjVARQIYf1Ff4STUj8/nOxP3RZjcvt/lYkmkuxMoaMEsirRB+SCnQ4JvFdgC4R7Txt7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV8iEcVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV8iEcVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D75BC4CEF1;
	Fri,  9 Jan 2026 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960482;
	bh=iZiQFYKoiMxWUfU0BLB0bquKeMtkMPxrS6v6kXLwMRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV8iEcVYFhNumr4Buc5IH1HSjqoWaIWLBbU3CbWUC8wuR9swdttNTt7W1q6pyglvD
	 Ts688CPXhJxywgoyknFnWbDAQqk8yItEs0AfL22Y6WAwsctXFxyT42z/T69iWJNaVd
	 ioIzaL5/u8ks4fLS/89t0u8nR3PRe56am+vIjP0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 418/737] floppy: fix for PAGE_SIZE != 4KB
Date: Fri,  9 Jan 2026 12:39:17 +0100
Message-ID: <20260109112149.720434261@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rene Rebe <rene@exactco.de>

commit 82d20481024cbae2ea87fe8b86d12961bfda7169 upstream.

For years I wondered why the floppy driver does not just work on
sparc64, e.g:

root@SUNW_375_0066:# disktype /dev/fd0
disktype: Can't open /dev/fd0: No such device or address

[  525.341906] disktype: attempt to access beyond end of device
fd0: rw=0, sector=0, nr_sectors = 16 limit=8
[  525.341991] floppy: error 10 while reading block 0

Turns out floppy.c __floppy_read_block_0 tries to read one page for
the first test read to determine the disk size and thus fails if that
is greater than 4k. Adjust minimum MAX_DISK_SIZE to PAGE_SIZE to fix
floppy on sparc64 and likely all other PAGE_SIZE != 4KB configs.

Cc: stable@vger.kernel.org
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -331,7 +331,7 @@ static bool initialized;
  * This default is used whenever the current disk size is unknown.
  * [Now it is rather a minimum]
  */
-#define MAX_DISK_SIZE 4		/* 3984 */
+#define MAX_DISK_SIZE (PAGE_SIZE / 1024)
 
 /*
  * globals used by 'result()'


