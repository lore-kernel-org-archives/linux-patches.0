Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65318801C;
	Tue, 30 Jul 2024 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356425; cv=none; b=Nw4snzRlXY8zRpRTtprJMA3YglVthPcgfUSdXUkOyvR7Ypsxg8buDqOgoCktARXfbt1NPRvIcbA233hZaR9WQMFmhafdHyfeTMbh3nzILZsvw6pmZSr1quKUB0w1ZbOylH6vM92Jo1BYCFZ3IccsrzAyXjA7hTe5jALLgkdu++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356425; c=relaxed/simple;
	bh=QfYJKndXpODvQA6cHGsi0YFPq05Lv0BLzUTP5AOI7KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REa1GU1DQ5hDdx5w3be6dX9TY6BtHY2X0/1HUqRc3XLO4CBAWXjo1VU5S9fOh9RCBuyp8Caru3O/vwMWp/oAREt/0B+Mg36G2zaTVE+yWRAg5ZH46hr957WGbjTPcVwxYJ2CwE1igS4NGgHgWdHt5mkoYrm6saLlHpm1Pm+puW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrQAsxfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrQAsxfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE564C32782;
	Tue, 30 Jul 2024 16:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356425;
	bh=QfYJKndXpODvQA6cHGsi0YFPq05Lv0BLzUTP5AOI7KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrQAsxfY2FOBn/sYR6wrUtS6jqWe49QE9mx7ixBVLRygGAgLue6cBAGQvUvp2ZLBw
	 QXUJGqVGWNPOQQWHMulxv92jnTek8E44Ari7c9GL6ui6ZTnks0WeK8o0nRGl9OMhsw
	 P8pSvErcBUPAbGLu5wDWd9UtsqivifChdimqNpBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/568] perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation
Date: Tue, 30 Jul 2024 17:44:14 +0200
Message-ID: <20240730151645.623063849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 3520b251dcae2b4a27b95cd6f745c54fd658bda5 ]

Currently, perf allocates an array of page pointers which is limited in
size by MAX_PAGE_ORDER. That in turn limits the maximum Intel PT buffer
size to 2GiB. Should that limitation be lifted, the Intel PT driver can
support larger sizes, except for one calculation in
pt_topa_entry_for_page(), which is limited to 32-bits.

Fix pt_topa_entry_for_page() address calculation by adding a cast.

Fixes: 39152ee51b77 ("perf/x86/intel/pt: Get rid of reverse lookup table for ToPA")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 42a55794004a7..e347e56030fd9 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -989,7 +989,7 @@ pt_topa_entry_for_page(struct pt_buffer *buf, unsigned int pg)
 	 * order allocations, there shouldn't be many of these.
 	 */
 	list_for_each_entry(topa, &buf->tables, list) {
-		if (topa->offset + topa->size > pg << PAGE_SHIFT)
+		if (topa->offset + topa->size > (unsigned long)pg << PAGE_SHIFT)
 			goto found;
 	}
 
-- 
2.43.0



