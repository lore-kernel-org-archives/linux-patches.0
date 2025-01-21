Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E381F470A;
	Tue, 21 Jan 2025 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482484; cv=none; b=ufG+RMn3v5al9eDdnvxM9gJvyvQvtWp8iQMUK4xevWGdFCo98VgqpRO14eR32rvAEBoV/p2/mz1RkkpWmEOig041dA5NNpyHLS+vEmwQ/nufAdEPNf7J8BtY/iNIgmuZIT9Ul/jpTXe5vey9pySO122mDg9H7XYgRIyvOb/I75A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482484; c=relaxed/simple;
	bh=win7LY7PuD5mTZHhB+nhrTDhpaCS56lPs51cweQHKsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSGF2yccK5mKTBW46py6RTBgKDP/qHokWQxaIyQaEfw9PpxohojJzUsCCRoO2rpLoVVApgqQJj60UYlvMAH5qbQmBAjtT53PYrepVSoXnzbE4GtGwjzF30h+T1rDIuU7Yiu0RQ4cowGGnYIgGSdR6CHN0cOWgDT5frb3nLKuhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeaNr6FK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeaNr6FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A05C4CEDF;
	Tue, 21 Jan 2025 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482484;
	bh=win7LY7PuD5mTZHhB+nhrTDhpaCS56lPs51cweQHKsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeaNr6FKQ0+dwr4nGANAy2xRyCoPd9HswwvmdojjrMh1dZOnbIfJtqugBCwrw3Or5
	 z09VwQaK98CeyuKK6W8RDVZMKgb6qrePb2EoweOY8cBtpKn2aDdsCme5oSLW5km0xT
	 KBBwnS1WRQmF68mFZozuhTwJZneesE+xiLztWxzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 092/122] filemap: avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:52:20 +0100
Message-ID: <20250121174536.565017918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Nelissen <marco.nelissen@gmail.com>

commit f505e6c91e7a22d10316665a86d79f84d9f0ba76 upstream.

On 32-bit kernels, folio_seek_hole_data() was inadvertently truncating a
64-bit value to 32 bits, leading to a possible infinite loop when writing
to an xfs filesystem.

Link: https://lkml.kernel.org/r/20250102190540.1356838-1-marco.nelissen@gmail.com
Fixes: 54fa39ac2e00 ("iomap: use mapping_seek_hole_data")
Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3004,7 +3004,7 @@ static inline loff_t folio_seek_hole_dat
 		if (ops->is_partially_uptodate(folio, offset, bsz) ==
 							seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < folio_size(folio));
 unlock:


