Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F717332C;
	Tue, 26 Aug 2025 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208410; cv=none; b=pp5AWHbo3aNU9fZ9OP0axcXNdQAKJntxQvIE713sFjl+66e67XgV3M28b+cwewnw8BIRyBgzFoAlnt4LFHbKicbG4w1tOTmwMXuq+7DQxil9bzMjhWOpDP3pbbUip/78pmcMpf3bmr/CSFszUDx8TqVvxHxQ4MqmYAdluQBMyBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208410; c=relaxed/simple;
	bh=kyd5+5dGTlHqEBbKoqPlwNzwWXUixynv9NKozWGq9Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSrSglocUTPeOkAhmg31+bu/L/jqH+KnUgYryxgBhCZXjiVfnaQB9l+GNeifgWDkgSlJ+jfQT4S7f+ougGL/ZoQPzh7N142JFp2mZCX2TJg+BRbLnKM5K6lLF5H+noLCQ2V+DYT4iDVYRP/4xDY6q3kHOtPs0dFjptbZwwRs/IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gbui+Nk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gbui+Nk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9368C4CEF1;
	Tue, 26 Aug 2025 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208410;
	bh=kyd5+5dGTlHqEBbKoqPlwNzwWXUixynv9NKozWGq9Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbui+Nk3xCr3tl+9VUO1D+CFskavgQzrXpEGonbbVzwGYPgoNRCxvDg/Y7W479cOc
	 F+JY7VT3gj7p383GNN7vAU0408LEiLwXCXAqM3ToG3RdMBbPw51X118Qxrz2b15/m3
	 6zty2X6DV8ven7Rc+R76jNXm9E5VG5RY5TQjVUB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@toxicpanda.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 073/322] readahead: fix return value of page_cache_next_miss() when no hole is found
Date: Tue, 26 Aug 2025 13:08:08 +0200
Message-ID: <20250826110917.390261525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -1750,8 +1750,9 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long nr = max_scan;
 
-	while (max_scan--) {
+	while (nr--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;


