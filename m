Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E9E3905F4;
	Fri,  4 Sep 2026 05:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500936; cv=none; b=HtgGSYET/fopehrqvyZY7xP6hW5tCPP/3P6cWQ13qrO2VeXNMNkhqE6boX/nZxCottYKqGZlmQvn/C44hDf5THs0vsNxq2XQI26+LRx2V8nu0NLfjeFrLqLAmhE2gMnPcNEX4bAvmDK5M2eW6tvxB5tKCk00hz5/AoMRAGF/QPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500936; c=relaxed/simple;
	bh=/PF8Xjdm0Rh3X0qbRdvQ+ffJK8dU2saDDjmhNUNwZsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCnC276s1jypWi+qt+gNd1K+SQn4xzrhAsKas+ORECig9hSww5Zz97ZnoQ/CRBi1jk1dXBM9VuorM3rK7zuYiThb2kgh9WLdbHVSpivikzvjFTjOcS7PIYVq3BX7x8EBK08OYajdnbk8lOJcYAUqjG8feAWtlliYehNMHQRYN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zu++NtjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zu++NtjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67131F00A3D;
	Fri,  4 Sep 2026 05:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500935;
	bh=SCMpgixLiWZhg6Qso3MZN+Y8JwGWc36SoE/lk41VggQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zu++NtjCRTf7H02vdLaKzgXUFQ4EaBn0tPpqFA12z/oaQIS8/1Pfq2ZeRDnlz4iAe
	 E7I/C1Oj5UhzMfB28igaTpNit3QUKlCrNDvj7BbWAJoTcxvwjGLMUCtAJdCOIv+dJ2
	 +wfAh0JtxXpMQmSJJBsTsy/9hMMbR885y4v2T2WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 232/552] buffer: avoid tail commit walk for uptodate folios
Date: Fri,  4 Sep 2026 06:56:29 +0200
Message-ID: <20260904045754.746821731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

commit f10b9cc1eb20637351f4e33372bfb464f89de59b upstream.

block_commit_write() always walks every buffer_head attached to the
folio.  That was cheap for order-0 folios, but large folios can contain
hundreds of buffer_heads.  For a small buffered overwrite of an
already-uptodate large folio, the commit work is therefore proportional
to the folio size rather than the copied range.

This became visible with ext4 regular-file large folios, where cached
small overwrites reach block_commit_write() through block_write_end().
Before ext4 enabled large folios for regular files, this path was only
hit with order-0 folios for normal ext4 buffered writes, so the full walk
was bounded.  The ext4 large-folio commit is therefore the regression
point for this generic helper cost.

The full walk is still needed when the folio is not uptodate, because
block_commit_write() uses per-buffer uptodate state to decide whether
the whole folio can be marked uptodate.  Keep those folios on the old
full-buffer path.

For a folio that was already uptodate on entry, the commit no longer
needs tail buffers for folio-uptodate discovery.  The copied range has
already been processed once block_start reaches @to, so stop there and
avoid the suffix walk.

Fixes: 7ac67301e82f0 ("ext4: enable large folio for regular file")
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://patch.msgid.link/20260609035202.90669-2-zhujia.zj@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2199,6 +2199,7 @@ void block_commit_write(struct folio *fo
 {
 	size_t block_start, block_end;
 	bool partial = false;
+	bool uptodate = folio_test_uptodate(folio);
 	unsigned blocksize;
 	struct buffer_head *bh, *head;
 
@@ -2221,6 +2222,8 @@ void block_commit_write(struct folio *fo
 			clear_buffer_new(bh);
 
 		block_start = block_end;
+		if (uptodate && block_start >= to)
+			break;
 		bh = bh->b_this_page;
 	} while (bh != head);
 


