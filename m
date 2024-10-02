Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19071D0B91;
	Wed,  2 Oct 2024 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880604; cv=none; b=GqC2kETFUM54tzEoNK+E507uoXbPgoPB7d8riU75ud7DQSBDeAW0QqmW/+p/n0SVjqcaTmDOt8EcBtBj1rG87pyrUiHd2IDok6eyZBCvQoVmae5BkOm9dim4XR4cICuUpHT7KNBgcUJvG/yeMfKA7jKftpWFGfnwoFMRSrSaPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880604; c=relaxed/simple;
	bh=ffYqCF5B07lPd7HAK0PbGp12cEDLQoLdUqj/qxde1y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtQby+6bRx6cJRW98amYrvG2y5I6DhPfoNUWP7Yde1NnLA/6KybJlbL8htcBRoXtfo0yu0cqf44a4UbWfr4cgUN7h6LKuqBlKUMBM4D/WNINlqP7xX0wBkQVIp57vSXAaxPAw371qqsmu8VWG6Gi/8a5SEovDk9D9hZMKG+umJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYyw0bMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYyw0bMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C5C4CECD;
	Wed,  2 Oct 2024 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880603;
	bh=ffYqCF5B07lPd7HAK0PbGp12cEDLQoLdUqj/qxde1y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYyw0bMQ6VKNztv6AVykGG6G+j3vX6I4LqsXIXkPjyZoS941Ge2ZoDWgc9ve+2p9e
	 U6ClBhzwp82FstfwxxcHYNbl6LnzpeD1k5Wo3yksu8XdnIM+zMb8pyVI2FsxLuUSqr
	 7VVuLeKhYeI1mOh92DCPxJ7N+6rZu7VwQMZO/3O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 516/538] mm/filemap: return early if failed to allocate memory for split
Date: Wed,  2 Oct 2024 15:02:35 +0200
Message-ID: <20241002125812.813490132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit de60fd8ddeda2b41fbe11df11733838c5f684616 upstream.

xas_split_alloc could fail with NOMEM, and in such case, it should abort
early instead of keep going and fail the xas_split below.

Link: https://lkml.kernel.org/r/20240416071722.45997-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240415171857.19244-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240415171857.19244-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6758c1128ceb ("mm/filemap: optimize filemap folio adding")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -872,9 +872,12 @@ noinline int __filemap_add_folio(struct
 		unsigned int order = xa_get_order(xas.xa, xas.xa_index);
 		void *entry, *old = NULL;
 
-		if (order > folio_order(folio))
+		if (order > folio_order(folio)) {
 			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
 					order, gfp);
+			if (xas_error(&xas))
+				goto error;
+		}
 		xas_lock_irq(&xas);
 		xas_for_each_conflict(&xas, entry) {
 			old = entry;


