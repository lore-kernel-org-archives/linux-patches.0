Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606A1AA793;
	Mon, 14 Oct 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918707; cv=none; b=YIpF+pFbYYWYK/3cMHENdcLcK4UJw5vU3YL4n1Uqst8djulBpzATyb4lj+xoGl6N6j0VwKeJmFll9kGkqkMUPUq6/6LPAxWPeFxDdeNqra93tlXfR9GTyr9hbyRYxAct6aRX/iZ1LXr9QVZCIe3stdYnJXKRvZOp3NxrLtwC27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918707; c=relaxed/simple;
	bh=o5w3q98MHN1EGXiR9TMS6QGWGfo7oFatSWSYGjhHq8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfnLONar+ZO9MdGamSIVROP59NmWbmLzP6hh8gLPCy83h3iHAD7DgBBvbbI0Llal6R1i4mSJQXKJKc4Pl8K06MKrQChHipAhVkFe5II3Cq5EGQh7LrWpQG8eg/27UovH20EJU/Nid3uZQJ3clL1mVSie9ZWgWWC3qhPDJlmlyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hblCh/Gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hblCh/Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A9BC4CEC3;
	Mon, 14 Oct 2024 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918707;
	bh=o5w3q98MHN1EGXiR9TMS6QGWGfo7oFatSWSYGjhHq8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hblCh/GjthEHstqGVeHjTqDEqJr/45/eGTScs9UuclwR6MBFfNKcq4OE9d92ZeSVR
	 LBrw6tk+SLZRUpLz0mXK30nNbk8ZFoQNplqSWTEYRuHYMhVd0PeIyMq15BLAvRnvnd
	 +Topc7ALqjLad7k1reg0D4VcrBZaETUQVvkQ2o+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 358/798] mm/filemap: return early if failed to allocate memory for split
Date: Mon, 14 Oct 2024 16:15:12 +0200
Message-ID: <20241014141232.005642258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -867,9 +867,12 @@ noinline int __filemap_add_folio(struct
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


