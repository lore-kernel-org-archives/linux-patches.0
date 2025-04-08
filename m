Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374A81AAA32;
	Tue,  8 Apr 2025 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116084; cv=none; b=XwLapWi/XrO8lBBIyQNsP4zRjNxqAeGAm2vB7RSNFntAcOxxKOnXmH3HK1joOH+SXRW84rynmzDxubLVgrnzoWSc/TP0FBcM6gbXBqedMcFwiB+yVOMjHYEkS/aTLVWwQ0j8McjhqmyCFuPiUYSKEI5FP9bvXzVp4AGntPMpswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116084; c=relaxed/simple;
	bh=77LWS7bY4MPHjB8uq4xePK2z2TenaUr6WLcmOXgOIIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHEfV3K0Ms2EanfRW1ucsmT40dFiMMQeUFURFT4ix7KRrtx9CisCdIWSfm+CIArKBeZxGCJFUGL5b/met1t507Vy6Ga9mb0xr6EdnZu7vbJy2JKEuILS7MW5f8DwaftbVwjJAjPd2gFW70In9iiMjRFuyjqd6hQr5mwDWIfbw4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o07eWT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o07eWT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F94BC4CEEB;
	Tue,  8 Apr 2025 12:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116083;
	bh=77LWS7bY4MPHjB8uq4xePK2z2TenaUr6WLcmOXgOIIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o07eWT6oNnc0i5TQcxjfVbnj2ToyA34jygF8RIj1LMbwI7b159IyuWKWGSAF0mZ+
	 2d028b0FxFAiwid1rmCLkZLMGLfpeKDnBOZRXizMkf9sWlEl4vy9WzyC625m+b2hzP
	 quuF70GZWPPh1B1Hit8cxFRIupBoOOa9535v0McQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/423] x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Tue,  8 Apr 2025 12:45:28 +0200
Message-ID: <20250408104845.742102091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 33ea120582a638b2f2e380a50686c2b1d7cce795 ]

The CPA_ARRAY test always uses len[1] as numpages argument to
change_page_attr_set() although the addresses array is different each
iteration of the test loop.

Replace len[1] with len[i] to have numpages matching the addresses array.

Fixes: ecc729f1f471 ("x86/mm/cpa: Add ARRAY and PAGES_ARRAY selftests")
Signed-off-by: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250126074733.1384926-2-rppt@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/cpa-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/cpa-test.c b/arch/x86/mm/pat/cpa-test.c
index 3d2f7f0a6ed14..ad3c1feec990d 100644
--- a/arch/x86/mm/pat/cpa-test.c
+++ b/arch/x86/mm/pat/cpa-test.c
@@ -183,7 +183,7 @@ static int pageattr_test(void)
 			break;
 
 		case 1:
-			err = change_page_attr_set(addrs, len[1], PAGE_CPA_TEST, 1);
+			err = change_page_attr_set(addrs, len[i], PAGE_CPA_TEST, 1);
 			break;
 
 		case 2:
-- 
2.39.5



