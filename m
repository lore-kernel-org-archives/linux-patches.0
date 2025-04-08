Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79049224AEB;
	Tue,  8 Apr 2025 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115559; cv=none; b=gh4P/uZNkaJWpx2MgWWKnNWvI+u/aAQ4aVBJG3TDQ3V5UpjrV+6kdZrelsWmeTF+ZiHrf5z+FT1Fn9pfauvRVnROlaJM2f3kbd/W8pNUtyYIz8e+iSW+uwrWNWNibMzZc4sb+7P8Z76Kk0fJ7AUGz/7AS3Ef5iQ3tvILQmis38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115559; c=relaxed/simple;
	bh=5glWdCR8L9PQ5l3I90v20uA3htfyZxsSF8xA3Atu05c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay8zAuafTldzBUbX2lhYOmHbRJIEHmvyKMb7wIYkitSbVjBa6OC1OLFKaTyqrB/EzOELW/2ZsM3/k6B0mk6ojcLwbhPbhAIfANyqBfwR/UBhiMrCmvbV3BIFY6wNADTDQFD2xZ12ta3EwprXLRBZvlwf9wuYh7owiI7wfj7gI+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6SZH573; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6SZH573"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99E6C4CEE5;
	Tue,  8 Apr 2025 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115559;
	bh=5glWdCR8L9PQ5l3I90v20uA3htfyZxsSF8xA3Atu05c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6SZH573uAJyjILmBAZav+t/dXOjUXggCe9Cvm4WpDpAVE7YkoFQM/LSd/7cxmAB2
	 1B4aaOAuE1iLC3BZteACItA20L6djnnZNIL+eQMBv5cBx5Xokftljz8iesAfxo9GAN
	 100DE4cqL2F5V9V6n+PWFysRulRXJWOSBwsvdX0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/204] x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Tue,  8 Apr 2025 12:48:52 +0200
Message-ID: <20250408104820.348797736@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 423b21e80929a..55ce39b6b1b09 100644
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



