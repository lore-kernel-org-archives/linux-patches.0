Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57505D528;
	Sun,  7 Sep 2025 20:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276686; cv=none; b=VlmtUo11LYqEP3EhpKlCifYOsziQV7MlxxoK9wPwKpMH1/MNqlfu1huzr2VAUWucZGydOU+DbyfgKT+AA8bNz0wCrpYIKPxJicOx4SHxmCtFuKUNhyAkDBIwZ+SgxLJ+est1YnRfTkuUvWZGWgwAZ2xL9SNV3/hwJIUfWRpjfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276686; c=relaxed/simple;
	bh=/nWa69YyEo9gI+g0tylMWRIEdR0MLukCGgjSdYD1BJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCrmpPEz2z5B23AAn3Wtj3rf/ZIytImNB4Mpmr/j4fkQurt2G0+cJxHCVabaYeD6/ITHJMvdxNqNx0U8RC6ykLActh2OSVFWzJlKdBBznuZP+PDgH6sVs8sO+5Iym6ciLNkRq66qEZGTPrHL6GCo0G6REBas29ZWWSTyr2WEugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc/1nLqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc/1nLqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCED6C4CEF0;
	Sun,  7 Sep 2025 20:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276686;
	bh=/nWa69YyEo9gI+g0tylMWRIEdR0MLukCGgjSdYD1BJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc/1nLqHtPh9Xk93daq/eLzbLN54QlT68/A0CO/0d5JM4zd/LLEt/bdeqXR3iD7VI
	 /LPPkqIOaeu1ScHhJkcHrxumEtSewGIsIoAjz9NNCAvlUAZCK5HWx6LELuv3/NmRku
	 9FCBiYMSiiOKbo2sDFar9II5YAF9j3d8R/s58DaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiong <liqiong@nfschina.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/121] mm/slub: avoid accessing metadata when pointer is invalid in object_err()
Date: Sun,  7 Sep 2025 21:58:33 +0200
Message-ID: <20250907195611.811975508@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -988,7 +988,12 @@ static void object_err(struct kmem_cache
 		return;
 
 	slab_bug(s, "%s", reason);
-	print_trailer(s, slab, object);
+	if (!object || !check_valid_pointer(s, slab, object)) {
+		print_slab_info(slab);
+		pr_err("Invalid pointer 0x%p\n", object);
+	} else {
+		print_trailer(s, slab, object);
+	}
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 


