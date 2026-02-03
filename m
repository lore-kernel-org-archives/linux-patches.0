Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9826E3BFE4C;
	Tue,  3 Feb 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134380; cv=none; b=ps3AvHPEBF1HFVidkGfssVXucZ30JENoNkICX3MzgZZwg4CDyt3W3eNihW/rrvMjSbBZnbnnvta21bYgmdFOiPoANL5g0VyZQ0JQXIzKQLksj5EfBILcO3FEg5HKk8ue6HqAN94vJRhbL4xmJV6igeeZLLXWvdlys5UmTAcV828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134380; c=relaxed/simple;
	bh=IKknAjUnvYGCSIkwoN1i/VXk2ndWUt+86bc6pwza3zA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=jsO+AgeoKnnzoGnEbMVXZhUnN/htFORNcc2pAGaM3KcEw8G5EOLkfwfyfj8q2JOz+HM3L/u06eOaeOdRQxdUUUrgw3grprexaK6fykL7aGY77gbUyTGf64KeJN1fkwCOPDL8STgVRPE4rttsNQ8WsV6+gvmi/iF1CnbioAgFjRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjDkMfpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjDkMfpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FB6C116D0;
	Tue,  3 Feb 2026 15:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134380;
	bh=IKknAjUnvYGCSIkwoN1i/VXk2ndWUt+86bc6pwza3zA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=RjDkMfpbUgy6gBNcxBITbSiVyL0paF+wIxksc6ZWXVeBMivmq8ZNOrzzB1vUagekL
	 zhcDRLcrcCC7sUIyiD6Xq6sprvgGks1t/hf0Ggu8lHaurQ7Uc5+eZnZ7UaMfJz0+dZ
	 N/PDlmTP3PlF4wJEOXeRxOQh4Nx2jvZr9PXMkiN4=
Subject: Patch "iomap: Fix possible overflow condition in iomap_write_delalloc_scan" has been added to the 6.1-stable tree
To: 681739313@139.com,djwong@kernel.org,gregkh@linuxfoundation.org,hch@infradead.org,patches@lists.linux.dev,ritesh.list@gmail.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:08 +0100
In-Reply-To: <20260123063300.3820420-1-681739313@139.com>
Message-ID: <2026020308-annuity-stimuli-fd4d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    iomap: Fix possible overflow condition in iomap_write_delalloc_scan

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     iomap-fix-possible-overflow-condition-in-iomap_write_delalloc_scan.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 681739313@139.com Fri Jan 23 07:33:06 2026
From: Rajani Kantha <681739313@139.com>
Date: Fri, 23 Jan 2026 14:33:00 +0800
Subject: iomap: Fix possible overflow condition in iomap_write_delalloc_scan
To: gregkh@linuxfoundation.org, ritesh.list@gmail.com, stable@vger.kernel.org
Cc: djwong@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, patches@lists.linux.dev, willy@infradead.org
Message-ID: <20260123063300.3820420-1-681739313@139.com>

From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>

[ Upstream commit eee2d2e6ea5550118170dbd5bb1316ceb38455fb ]

folio_next_index() returns an unsigned long value which left shifted
by PAGE_SHIFT could possibly cause an overflow on 32-bit system. Instead
use folio_pos(folio) + folio_size(folio), which does this correctly.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -903,7 +903,7 @@ static int iomap_write_delalloc_scan(str
 			 * the end of this data range, not the end of the folio.
 			 */
 			*punch_start_byte = min_t(loff_t, end_byte,
-					folio_next_index(folio) << PAGE_SHIFT);
+					folio_pos(folio) + folio_size(folio));
 		}
 
 		/* move offset to start of next folio in range */


Patches currently in stable-queue which might be from 681739313@139.com are

queue-6.1/iomap-fix-possible-overflow-condition-in-iomap_write_delalloc_scan.patch
