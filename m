Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B48A355037;
	Tue,  6 Jan 2026 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720194; cv=none; b=aNYiSS2oVSDtb1kf9+/Lhozf8fvtHsi4Ki+Hbizy6cUPRzSfxG3tATmX8U7K2DBd9Uv8OREjpgPH/E+1QwLVgjMkHoFT+dLqLc2RdY7iUurJeB3MqIMCsuZiHmiCaQ/evBvFcLjJVM27OUXphnQ6aJV9RfwmDz2FtFGFyLNCSeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720194; c=relaxed/simple;
	bh=vgpEEZ6DHhrSTwQeIZpVWfABf0Kr3VlmZZjEbAoUy6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6JIBthDzjpaB/EX5mBxorIc+S1yu38iTs2iD5IdmY4gX2ZZC9yjrRcu8fBXNYutJ4rxn2xwibgGQHztQi7IUbYTS+F7GeUn/BWJnpQ9A+WzMOwR2ZztHCdKvRo5UNEc1yxBP3d80iilRUoFIUjaWHm23u/NTC4Jczs+VNpdrTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzB2iVQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzB2iVQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0226DC116C6;
	Tue,  6 Jan 2026 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720194;
	bh=vgpEEZ6DHhrSTwQeIZpVWfABf0Kr3VlmZZjEbAoUy6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzB2iVQTf1LH72l05nIGvEQ4uJNtUkfmesx6nmLdfazrdbwMi/UsuZC7DSDvUkoAE
	 vjLLCeF5DD5HJY+fjkttqDnGfk0B5IUFLGWn9sxCd9lmyy3NdhACSAu894hE0v4jxk
	 cxRaHrBsMQ1EWkcFpKe6VrkNEUAJjYlG+pvyJlOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 162/567] floppy: fix for PAGE_SIZE != 4KB
Date: Tue,  6 Jan 2026 17:59:04 +0100
Message-ID: <20260106170457.321693589@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


