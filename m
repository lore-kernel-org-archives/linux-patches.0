Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DB721D00E;
	Tue, 26 Aug 2025 11:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207216; cv=none; b=uJfSvx0I8wRqO+6hgrx+EFxNWZKytBTnvwkGjIoC03AQhLXNRwABMr5TRriVXk8s0QwcIygVJuM7GDzI+RtOWAJt1d1sas6Z4ld24ElzlR7Wi5F2FEgjfvHUjzNXdKP9MCKWf6R/6Ua1EkcfLDZoKsYoZRbe81anLUMFgtfVbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207216; c=relaxed/simple;
	bh=/sY/2tpCN6npTnUy18LW9l8yytKwSGP9G4A83O7+x9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMcfW21FPOVEe9NW7xaLwJIvbTtkEG4b1nyOgmcs69d43LIxMc+VdxG1nuNaSmjUIxeO98ecn3/jM/+UjxftnSAZF/WRUOoVzMozuMhE2wQQArIprQ4dJ8rsh0+yyQoTgMqR4NTIwTJPHsvZNth7Jqc7BOpxqsZ+ZU8Ulx/iwJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPL5wAOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPL5wAOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A20FC4CEF1;
	Tue, 26 Aug 2025 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207216;
	bh=/sY/2tpCN6npTnUy18LW9l8yytKwSGP9G4A83O7+x9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPL5wAOB001IyppZ8tuNZSv5/4zsz4UuTyJTKv9ecFwLzxJpefnOjSF2mvimgo4xY
	 gClD0KgKfVMEHclg6jUIO0jaiqsai2BrE3sc9kA+6IOC1VHdrH3qfVKdL+TxHBpV69
	 DnG2rVpAD+qJUI6h393GxLOuDi89ZEE78hVWSdDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@toxicpanda.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 096/457] readahead: fix return value of page_cache_next_miss() when no hole is found
Date: Tue, 26 Aug 2025 13:06:20 +0200
Message-ID: <20250826110939.749740107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

commit bbcaee20e03ecaeeecba32a703816a0d4502b6c4 upstream.

max_scan in page_cache_next_miss always decreases to zero when no hole is
found, causing the return value to be index + 0.

Fix this by preserving the max_scan value throughout the loop.

Jan said "From what I know and have seen in the past, wrong responses
from page_cache_next_miss() can lead to readahead window reduction and
thus reduced read speeds."

Link: https://lkml.kernel.org/r/20250605054935.2323451-1-chizhiling@163.com
Fixes: 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no hole found")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1778,8 +1778,9 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long nr = max_scan;
 
-	while (max_scan--) {
+	while (nr--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;


