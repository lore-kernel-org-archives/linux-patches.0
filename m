Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACD675801;
	Mon,  4 May 2026 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903452; cv=none; b=trYGUmcZM7xZyvdoQuxL+aoitVPn7p8aHQrz0XB0db/nngEvEOl20ii72UulVUWy5sZlMEBSIW358G+woY3+flTSkePFqOL2B7v79p5BMnhsiLueAe0ufQw71gZEOWL5qcH4kaLxIg3B1GnggsGwJQmc8PbOCSFNFYp48x79VXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903452; c=relaxed/simple;
	bh=iYHTFJlPyUiYvLuw+ZvdH2kQW/zQuKByIGP8RW5km6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLijlIz50glMvHMI+EwMtzDEEJ4GnBUVvASYtAOurnTIBRBic/zerd+ANKdAiAuGRP8v1MMpjvwJ4mVtVRBXQz4wxTDBwQJcljIvkdSZVMNmaj4TFmvBtawFYSYG6hTBQfSqtWMc/ifma/wNnlpop21kMftGT5wQhF2uryJd7qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwcFN/Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwcFN/Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7768C2BCB8;
	Mon,  4 May 2026 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903452;
	bh=iYHTFJlPyUiYvLuw+ZvdH2kQW/zQuKByIGP8RW5km6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwcFN/EyvLkRozFXzy+gwNIFGgiVDSvS+zfhMKyyu1xbLrbFW0wfjvTr3rky6Dk05
	 ZTKdpqBkMpo5h7hgxez0n6Ta7AUvnXOYVooT+oxSbZO6zu65hq8EwdcsieyY5DkD+Q
	 D5qH50cQQ2ZG5Yh/R2MShgvE39jhAhDCQBemgncY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 7.0 238/307] md/md-llbitmap: raise barrier before state machine transition
Date: Mon,  4 May 2026 15:52:03 +0200
Message-ID: <20260504135151.794897927@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

commit ef4ca3d4bf09716cff9ba00eb0351deadc8417ab upstream.

Move the barrier raise operation before calling llbitmap_state_machine()
in both llbitmap_start_write() and llbitmap_start_discard(). This
ensures the barrier is in place before any state transitions occur,
preventing potential race conditions where the state machine could
complete before the barrier is properly raised.

Cc: stable@vger.kernel.org
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Link: https://lore.kernel.org/linux-raid/20260223024038.3084853-3-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-llbitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1070,12 +1070,12 @@ static void llbitmap_start_write(struct
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 
-	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
-
 	while (page_start <= page_end) {
 		llbitmap_raise_barrier(llbitmap, page_start);
 		page_start++;
 	}
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
 }
 
 static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
@@ -1102,12 +1102,12 @@ static void llbitmap_start_discard(struc
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 
-	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
-
 	while (page_start <= page_end) {
 		llbitmap_raise_barrier(llbitmap, page_start);
 		page_start++;
 	}
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
 }
 
 static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,


