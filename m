Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A56C3DEAD8;
	Mon,  4 May 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903696; cv=none; b=tuHZtRuj4Ce9UYRoi5TKjfzKUaJUtdGP/B02KVpg0MSciX5xHMztg+ZWD/NgwuCOS4AVwEHxtXZResIwtBxSJIK0p81/nTpUFxL6e7gL8bp6yOrnsuMhy3jKBUB8Z8344plqrSee0OMVaRfyc1KcDWnCRR4NXqctm3G9IN/gJlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903696; c=relaxed/simple;
	bh=QaS37jN/+yM49O4To3/A7PORvF7vk5iXIKEmNWPrlRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTUc34ax1Y9NfWwroH1KeQ15nRZQGq2P3xl14MsmLgEAGTjvSsGOx6w0tNdcJSJ10aIMwcWABHrnlk/gLwy/z1LTDMPh50cX7uF7N4KhJ+8dRbocnK7d8wfJxYfElCFS7unS0kIfZZJJ9vMPWFFjrqNv9ihYrdqhF+goTmJksp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+7J6LFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+7J6LFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30B9C2BCB8;
	Mon,  4 May 2026 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903696;
	bh=QaS37jN/+yM49O4To3/A7PORvF7vk5iXIKEmNWPrlRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+7J6LFlEOUsvT4MZa+LIXzmCLI7wZ+CwC2BZtyDq82yifqRVqV5wA2HwgxFUYVvX
	 QLonPuLUPdb4LfG5XQqd8OjnNEkr6cGy3p4r26Vv3448Lz0WZrqUWBsoa6VKCM2CNr
	 AiHzICc7KpKKffpmCzDOJFRWsG3aW7i1NsrNAH7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Qu Wenruo <wqu@suse.com>,
	Avinesh Kumar <avinesh.kumar@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Geffon <bgeffon@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 027/275] zram: do not forget to endio for partial discard requests
Date: Mon,  4 May 2026 15:49:27 +0200
Message-ID: <20260504135143.947346255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit e3668b371329ea036ff022ce8ecc82f8befcf003 upstream.

As reported by Qu Wenruo and Avinesh Kumar, the following

 getconf PAGESIZE
 65536
 blkdiscard -p 4k /dev/zram0

takes literally forever to complete.  zram doesn't support partial
discards and just returns immediately w/o doing any discard work in such
cases.  The problem is that we forget to endio on our way out, so
blkdiscard sleeps forever in submit_bio_wait().  Fix this by jumping to
end_bio label, which does bio_endio().

Link: https://lore.kernel.org/20260331074255.777019-1-senozhatsky@chromium.org
Fixes: 0120dd6e4e20 ("zram: make zram_bio_discard more self-contained")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
Tested-by: Qu Wenruo <wqu@suse.com>
Reported-by: Avinesh Kumar <avinesh.kumar@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1256530
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2308,7 +2308,7 @@ static void zram_bio_discard(struct zram
 	 */
 	if (offset) {
 		if (n <= (PAGE_SIZE - offset))
-			return;
+			goto end_bio;
 
 		n -= (PAGE_SIZE - offset);
 		index++;
@@ -2323,6 +2323,7 @@ static void zram_bio_discard(struct zram
 		n -= PAGE_SIZE;
 	}
 
+end_bio:
 	bio_endio(bio);
 }
 


