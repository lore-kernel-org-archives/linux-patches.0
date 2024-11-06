Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3FB1EABA6;
	Wed,  6 Nov 2024 12:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897005; cv=none; b=rZE1QAXA313RFpT5kEEtNzsDayf5OOmUA5dYJbWOjStgDE8H0WTbzFw9uKq7JDmBNDY+bNV6fRHociy1nijwTlg6tCyg5KW8wtx8w+YsZDY5UL1rvwUN79c5UXordwecsGSEfIS6zKtIgU/yC2IdAK+8wR7cldziJtDWTWCGnHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897005; c=relaxed/simple;
	bh=eO54PAidThfIffiwJT9kSmvw+pHdtT0vQYGH2rPObgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKq7dA7xrVyfIJtQSbf6WCJkBFd2kPstOlRlac990bL3jCeJGpei6yTH5Xm7Nym6xxpyQWZ5sU97v7Ti7cga+5/Mwy3nLTgUfLW5jIMAWd27WW1pagEhLPpIu1pW5nQsKCcOB6GG0kI3GwMWrDQuAklSfu9NtNW4PX8MFOWDbOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHHoAbET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHHoAbET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA56C4CECD;
	Wed,  6 Nov 2024 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897004;
	bh=eO54PAidThfIffiwJT9kSmvw+pHdtT0vQYGH2rPObgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHHoAbETqgZzD66/Djq/1tpSQO5KwsdP7eT0Nx9vus5VUyFJc61kaPrMz7igJdyzP
	 Bq6KXifwcnixPwPBoNG4g+UawOAeSzmEIwoR+wLjlGD2JIpDaUgG+7HaIo9MM7fMVg
	 iDwr2xzTjEXv11VQ1tRv8vSG/mjAvjwvm4G/JqvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Jiri Olsa <jolsa@kernel.org>,
	Liu Shixin <liushixin2@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/126] fs/proc/kcore: avoid bounce buffer for ktext data
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120306.205868368@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 2e1c0170771e6bf31bc785ea43a44e6e85e36268 ]

Patch series "convert read_kcore(), vread() to use iterators", v8.

While reviewing Baoquan's recent changes to permit vread() access to
vm_map_ram regions of vmalloc allocations, Willy pointed out [1] that it
would be nice to refactor vread() as a whole, since its only user is
read_kcore() and the existing form of vread() necessitates the use of a
bounce buffer.

This patch series does exactly that, as well as adjusting how we read the
kernel text section to avoid the use of a bounce buffer in this case as
well.

This has been tested against the test case which motivated Baoquan's
changes in the first place [2] which continues to function correctly, as
do the vmalloc self tests.

This patch (of 4):

Commit df04abfd181a ("fs/proc/kcore.c: Add bounce buffer for ktext data")
introduced the use of a bounce buffer to retrieve kernel text data for
/proc/kcore in order to avoid failures arising from hardened user copies
enabled by CONFIG_HARDENED_USERCOPY in check_kernel_text_object().

We can avoid doing this if instead of copy_to_user() we use
_copy_to_user() which bypasses the hardening check.  This is more
efficient than using a bounce buffer and simplifies the code.

We do so as part an overall effort to eliminate bounce buffer usage in the
function with an eye to converting it an iterator read.

Link: https://lkml.kernel.org/r/cover.1679566220.git.lstoakes@gmail.com
Link: https://lore.kernel.org/all/Y8WfDSRkc%2FOHP3oD@casper.infradead.org/ [1]
Link: https://lore.kernel.org/all/87ilk6gos2.fsf@oracle.com/T/#u [2]
Link: https://lkml.kernel.org/r/fd39b0bfa7edc76d360def7d034baaee71d90158.1679511146.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/kcore.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 590ecb79ad8b6..786e5e90f670c 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -542,19 +542,12 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * Using bounce buffer to bypass the
-			 * hardened user copy kernel text checks.
+			 * We use _copy_to_user() to bypass usermode hardening
+			 * which would otherwise prevent this operation.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
-				if (clear_user(buffer, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
-			} else {
-				if (copy_to_user(buffer, buf, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
+			if (_copy_to_user(buffer, (char *)start, tsz)) {
+				ret = -EFAULT;
+				goto out;
 			}
 			break;
 		default:
-- 
2.43.0



