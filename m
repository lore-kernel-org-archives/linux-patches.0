Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893D31B424F;
	Sun,  7 Sep 2025 20:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276072; cv=none; b=ry6Zd7ZciXVVcNLrreaA4JsGJGC1iiD1ZAvwbdYdfElIC4tS1WoiGay6RpZGjCwGG8NChEod4adNm2hihFAQmNttFPM0nu6PKUXXhTqyKQ2I94U5mmhKsUWyoOuUTHlfazqYRl/BWa9JGF1H6w1PADSvUdTGJ/SM0fGi38SXxv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276072; c=relaxed/simple;
	bh=tZM9X24HLYmAprcD2e6fC/geX49FocoUWDtihRNpW5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjWxzlYupUFop1/xCLZae5N8uPpBHYjLOHT/FgaDBTIdHif4ACwW+W0Ytsbv8GNwhB/DfqGqUPQewFrl/N51Ag8np/rK58N/7zDZ1+J4fq5Pg0jSvL8au+h/L9D7f2CrhWqDygiwUMzN+FYZGhtp78NJjgFj3rksTaBj+ocRQPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU6p83I+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU6p83I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB2BC4CEF0;
	Sun,  7 Sep 2025 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276072;
	bh=tZM9X24HLYmAprcD2e6fC/geX49FocoUWDtihRNpW5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU6p83I+HFx5+lh5NoHpm5rwPEISoYnyuFK8I9f1tsOPnMUydBhSRttFG7fOV9f4P
	 o/qSTMfSvyKSihgI0dwAuVZ2lwNVwRjkCZNMt36aq0/cIdUfdLk99RBdr+UMtkh6Yi
	 vHKqjsDYnpMHWKw8ut+l3OCBiIN55JKQHMlHnXRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiong <liqiong@nfschina.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/64] mm/slub: avoid accessing metadata when pointer is invalid in object_err()
Date: Sun,  7 Sep 2025 21:58:36 +0200
Message-ID: <20250907195604.905205454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit b4efccec8d06ceb10a7d34d7b1c449c569d53770 ]

object_err() reports details of an object for further debugging, such as
the freelist pointer, redzone, etc. However, if the pointer is invalid,
attempting to access object metadata can lead to a crash since it does
not point to a valid object.

One known path to the crash is when alloc_consistency_checks()
determines the pointer to the allocated object is invalid because of a
freelist corruption, and calls object_err() to report it. The debug code
should report and handle the corruption gracefully and not crash in the
process.

In case the pointer is NULL or check_valid_pointer() returns false for
the pointer, only print the pointer value and skip accessing metadata.

Fixes: 81819f0fc828 ("SLUB core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Qiong <liqiong@nfschina.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
[ struct page instead of slab ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -864,7 +864,12 @@ void object_err(struct kmem_cache *s, st
 		return;
 
 	slab_bug(s, "%s", reason);
-	print_trailer(s, page, object);
+	if (!object || !check_valid_pointer(s, page, object)) {
+		print_page_info(page);
+		pr_err("Invalid pointer 0x%p\n", object);
+	} else {
+		print_trailer(s, page, object);
+	}
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 


