Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A7C31ED83;
	Mon, 29 Dec 2025 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025540; cv=none; b=cTW/WG69s7JSxIJtWEgUxmw4y5CNxpBM+/KWtRIxUUF+WXUATF3pym09Ew89bECAcrHUFSc934SYPqSpc2+glx9Cm6wpQKGbTU4reBM8LjPLjvIIqPV6GMo3+Zo7iPn9n+hWitM7BvMxGddQK5z811b8O/TJPlzgiClyJaM3p8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025540; c=relaxed/simple;
	bh=li9Lpd+pF21T7/399oEArHwULO29hHRptC/2cAv/5j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/7EkbMF3AF0tFa0SjY92P9yNQY9uBn3D4vDqPWrWAnoHoWTcyfGRcb11tIiAutc0zSTTH/HL/S+g0nEE0dQ4SKY37Nf7dlZtRvRWgYOvkcfWgCjbUqyJKPxxySMvmMbuZO2nTVWBr9c1iZoHNXexnUZQISbCSG31Bw9J9p2aOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oa/qgvOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oa/qgvOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38ECC4CEF7;
	Mon, 29 Dec 2025 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025540;
	bh=li9Lpd+pF21T7/399oEArHwULO29hHRptC/2cAv/5j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oa/qgvOMSoXmeuka4VLSuFEnH/ShGunBPrwdMlQjKGWdRzW6SNcYurM9dx3r0oBfZ
	 P0xBZDBWO2wtBdBGNJdk5Kv0yULIPMeFdab7Sdx9dk1zHAy0sKpLHrS/5KePXq37Xd
	 uoflTwifXeBRr6yl41UmzE9GBI+ZoPYlPJTdz07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 250/430] floppy: fix for PAGE_SIZE != 4KB
Date: Mon, 29 Dec 2025 17:10:52 +0100
Message-ID: <20251229160733.555878823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -329,7 +329,7 @@ static bool initialized;
  * This default is used whenever the current disk size is unknown.
  * [Now it is rather a minimum]
  */
-#define MAX_DISK_SIZE 4		/* 3984 */
+#define MAX_DISK_SIZE (PAGE_SIZE / 1024)
 
 /*
  * globals used by 'result()'


