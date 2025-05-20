Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BD24418D;
	Tue, 20 May 2025 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750786; cv=none; b=cMr6raUT6jhP/q1uEu4ImRH8WmzY3VvsbHg42zwXEf+Q0Qii+mz2gpFP12VZpnVxgvzkFbGf+wyZOk9DfedGzU2lo1hJlnXqxLOjY3x99WkqDLlkX5JLMmHMTJdcNcd2FIMyL9olkY34R2+EfBubyRQMB3/jg5UAnB2I2M+Lnug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750786; c=relaxed/simple;
	bh=j5nWYrck52xAsuc8r7hxTLRyroppZT5kv4OfK6Wc/n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDY9Ic1Iv8UM6mH2ykP2t7/laQ81gPeR9BnbecSXbe/p78E8OUmzuonMXKO74oGtohPV95CZtSfSVIYmSZfnbKKIIBwoOvS8S0Y6AFxvlf5x4J4bKvyvKpWFIcn6I5fhI2rp2zbJpFx9enm/PfEJzay3Iyg57yXjnQ7VLiiHcTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18RhOrpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18RhOrpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DBAC4CEE9;
	Tue, 20 May 2025 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750786;
	bh=j5nWYrck52xAsuc8r7hxTLRyroppZT5kv4OfK6Wc/n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18RhOrpK9ns8dbS5p1PQ+C4utVLfK2ryM8jR6Xozq4Vd00nrD1hvrrz6MlU9P24ng
	 DOhxRXyvEX8Wdgb5f851BPO89YtGELUIKbhcPNGuycl/Tosdy0WjAOUUPpgpuX8KVb
	 4QtrJdv/zguPVRzlStFDKiOrHlplvKKzTU1orMUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b8c4abafcb1d791ccfc@syzkaller.appspotmail.com,
	syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 121/145] io_uring/memmap: dont use page_address() on a highmem page
Date: Tue, 20 May 2025 15:51:31 +0200
Message-ID: <20250520125815.291795901@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit f446c6311e86618a1f81eb576b56a6266307238f upstream.

For older/32-bit systems with highmem, don't assume that the pages in
a mapped region are always going to be mapped. If io_region_init_ptr()
finds that the pages are coalescable, also check if the first page is
a HighMem page or not. If it is, fall through to the usual vmap()
mapping rather than attempt to get the unmapped page address.

Cc: stable@vger.kernel.org
Fixes: c4d0ac1c1567 ("io_uring/memmap: optimise single folio regions")
Link: https://lore.kernel.org/all/681fe2fb.050a0220.f2294.001a.GAE@google.com/
Reported-by: syzbot+5b8c4abafcb1d791ccfc@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/681fed0a.050a0220.f2294.001c.GAE@google.com/
Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
Tested-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 76fcc79656b0..07f8a5cbd37e 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -116,7 +116,7 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
 	void *ptr;
 
 	if (io_check_coalesce_buffer(mr->pages, mr->nr_pages, &ifd)) {
-		if (ifd.nr_folios == 1) {
+		if (ifd.nr_folios == 1 && !PageHighMem(mr->pages[0])) {
 			mr->ptr = page_address(mr->pages[0]);
 			return 0;
 		}
-- 
2.49.0



