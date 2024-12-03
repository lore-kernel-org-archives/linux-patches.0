Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEC881ADA;
	Tue,  3 Dec 2024 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242395; cv=none; b=ELTcWBk/LyTUqotDkPFvbDpz9b97XnxQKrXtRcvZEF6OhwiRsvV+MqJsqlXG0bD2abtPY+ZBvXE1STd5f1LW3D207mY0KHN2/sFgNpaLaW6UpP1298QRzFzWKPMsecp1A1DppxoCdGoj12Eu7A4GOdh88QSDGLL2fMgkDMIQpDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242395; c=relaxed/simple;
	bh=68R12clyfr4duXqHHbqUXLFnoZ7D/OmTN/5L/ROO/m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljNvLmKWPlZiwrZM07RQJpSacnEjle5TkAZRIdfYBA5kla0FY/JJGt3XhWmp7cdnDoW2HiffFClZEySr1sbdYeWAT1TByc/ZSs14kCS1yFPyIQWrb+ETUa8UgDvpOKmQf4xmzU3uKjYH393p0R/QpCOa/TLso9Z2TFA8xfhtjDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnHVKsTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnHVKsTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F257BC4CECF;
	Tue,  3 Dec 2024 16:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242394;
	bh=68R12clyfr4duXqHHbqUXLFnoZ7D/OmTN/5L/ROO/m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnHVKsTpKgaLNsK2k6wYah7tBbqQx/F2kAyhqwkYl2Lytq5kmQ9tlML869OD+VG75
	 Ojuscum7ux/BJIXO8GoHd5drbBH81EwTFpGuDFD6gM3U/OF7fsZTeggIuwt57Z5iMO
	 i/WCE3M6jdRY2PLkZUrfX4IpOmtP71e/ohV1VG3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 691/826] io_uring: fix corner case forgetting to vunmap
Date: Tue,  3 Dec 2024 15:46:58 +0100
Message-ID: <20241203144810.711681747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 43eef70e7e2ac74e7767731dd806720c7fb5e010 upstream.

io_pages_unmap() is a bit tricky in trying to figure whether the pages
were previously vmap'ed or not. In particular If there is juts one page
it belives there is no need to vunmap. Paired io_pages_map(), however,
could've failed io_mem_alloc_compound() and attempted to
io_mem_alloc_single(), which does vmap, and that leads to unpaired vmap.

The solution is to fail if io_mem_alloc_compound() can't allocate a
single page. That's the easiest way to deal with it, and those two
functions are getting removed soon, so no need to overcomplicate it.

Cc: stable@vger.kernel.org
Fixes: 3ab1db3c6039e ("io_uring: get rid of remap_pfn_range() for mapping rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/477e75a3907a2fe83249e49c0a92cd480b2c60e0.1732569842.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/memmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -72,6 +72,8 @@ void *io_pages_map(struct page ***out_pa
 	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret))
 		goto done;
+	if (nr_pages == 1)
+		goto fail;
 
 	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret)) {
@@ -80,7 +82,7 @@ done:
 		*npages = nr_pages;
 		return ret;
 	}
-
+fail:
 	kvfree(pages);
 	*out_pages = NULL;
 	*npages = 0;


