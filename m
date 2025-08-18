Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D159320CCA;
	Mon, 18 Aug 2025 13:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522903; cv=none; b=RLe5A0DxJlUKGh4aDGsxx6Z7WSbtrpyHk2bc9B4/2TVmpQ5V8hIBHe/cEwS+2uT7n8XATXpaAfLtfoOV4jGhi2TodG9tYrYFnHDZuFo8z8r6cuMfM232k1b1jZ1eQcQDBLBxV/bE0SrRtvwWWY/j5qpgcwABktJ6OFM8T+mNOxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522903; c=relaxed/simple;
	bh=dWMfGUfyM5kesF9Frf2WsCScVJALtybvl86V+1tTL1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTJ2wi3GhgMaeXUm7Wa79qzmCfKOLtb+fkQc3z3D/gUVPTFVYkwIHQnp9ensgNCcXjX5vTJvIWUC8VP/ug8lfF8MMpJC7qGtedLoylfaIx4a5itmleJNpjcLaCiQ8TeNPkvkW01za3dFZ5VENaQ6JmYViCprAhh/2lb61lh/6+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyLnZ88y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyLnZ88y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25F6C4CEEB;
	Mon, 18 Aug 2025 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522903;
	bh=dWMfGUfyM5kesF9Frf2WsCScVJALtybvl86V+1tTL1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyLnZ88yrwptIBlNL9UuuZVzSwBZD6RMyV8vHhhCcurXP0X9aatg+1GfidDjm0ppO
	 SGNe4vuqCQXY06nxFXOY1xOx3r70TaoDPo/MrfjMBnDG5VCtOp0MJzFl7k21Y+BCZ4
	 9MtzNACRQCHLEbCFkGnN6OvThbK2j3lg6/jSq/Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23727438116feb13df15@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 003/515] io_uring/memmap: cast nr_pages to size_t before shifting
Date: Mon, 18 Aug 2025 14:39:49 +0200
Message-ID: <20250818124458.468092545@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 33503c083fda048c77903460ac0429e1e2c0e341 upstream.

If the allocated size exceeds UINT_MAX, then it's necessary to cast
the mr->nr_pages value to size_t to prevent it from overflowing. In
practice this isn't much of a concern as the required memory size will
have been validated upfront, and accounted to the user. And > 4GB sizes
will be necessary to make the lack of a cast a problem, which greatly
exceeds normal user locked_vm settings that are generally in the kb to
mb range. However, if root is used, then accounting isn't done, and
then it's possible to hit this issue.

Link: https://lore.kernel.org/all/6895b298.050a0220.7f033.0059.GAE@google.com/
Cc: stable@vger.kernel.org
Reported-by: syzbot+23727438116feb13df15@syzkaller.appspotmail.com
Fixes: 087f997870a9 ("io_uring/memmap: implement mmap for regions")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/memmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -155,7 +155,7 @@ static int io_region_allocate_pages(stru
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	unsigned long nr_allocated;
 	struct page **pages;
 	void *p;


