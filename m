Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4374176ADE;
	Thu, 15 Aug 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729441; cv=none; b=FRgbhJ9OU8bDl6ZyhhfKIL4zEtJmiQPisL35zHLLDipkycpyzN0CX5S6GsMVxg/SWRmWEjh9DCtbmkVp6fFRtGQGtQJ7a4cma5p01ZQ9/ZPpbT9c1rIqQeSOhLw5q23qugDKUNh6cnu0NlKSjvvRbEATFM/7o0TbkyZN/4Jm33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729441; c=relaxed/simple;
	bh=1CwEJV1mGaXo4G+Nxkjw/x9T2g5h8MTNFU1E2wGYODo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPFrpD1GzNxKxUVbTyKHj1P4G3Pn/ZPWd9X4TBzC4PxOM3m6OR2wsw8cjnYmthzlqLaCO7/TKUUI9MLieO6ze44bN/T+wId1UgwGkyqgRl8Ko4RXLonj51qTVWQkMnswxCUH3IGrlDL5C8keZUs61SGckyyfp1LBeudps3sinCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feppnJXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feppnJXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D093C32786;
	Thu, 15 Aug 2024 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729440;
	bh=1CwEJV1mGaXo4G+Nxkjw/x9T2g5h8MTNFU1E2wGYODo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feppnJXS/PcmwOU2WZSHsPuktK9f979COVzhpld9EgcpfrJkW8nsJ1V/BeyTXkyMB
	 tZhnTdVoY2snIhJ7FiE6HutfyPG3M0D/CuNLBorykKqa0kqz3+enM5f7WQMThJ4+Pc
	 c5eQSAcdiock5/gfs6CRKJdUFMKh4e7fpCbIMkpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/484] perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation
Date: Thu, 15 Aug 2024 15:18:45 +0200
Message-ID: <20240815131943.871977924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a85d3138839c5..cf0bb42b1569e 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -973,7 +973,7 @@ pt_topa_entry_for_page(struct pt_buffer *buf, unsigned int pg)
 	 * order allocations, there shouldn't be many of these.
 	 */
 	list_for_each_entry(topa, &buf->tables, list) {
-		if (topa->offset + topa->size > pg << PAGE_SHIFT)
+		if (topa->offset + topa->size > (unsigned long)pg << PAGE_SHIFT)
 			goto found;
 	}
 
-- 
2.43.0



