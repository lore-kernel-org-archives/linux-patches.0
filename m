Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9941DDA0C;
	Tue,  8 Apr 2025 10:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109951; cv=none; b=ah3ik71cLhqHPsnUdB4DQQ7LUJYv08mBJYCufHVrnC03PWqVQ2HFFMf052NKQfJIWTtUS+KDEDwsyLK4tw0HdgLrgS9gunruIvld+cIj3c9ZDtbO1w2go1OC/+xuKZFZmpy4wOvhgDThSgDMEP02Xb4A+1z19jaiMPmiQBEaEDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109951; c=relaxed/simple;
	bh=qncx81VHWz2I++RThpwNIhRr3rSoDho4/oadcDb6ySM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqL4XNcw9cGJSMdvSBgHVnR6sFc6klz8B88xRnEeQ8GUvhXjRSc6KNtuSDNnIl+j19mu4KomROw68UwMHjqH94xh1bWTuBvUDnpyUtNLTvi2Z16y6WDrij5Yqwi84EiKXVL+6P5+wPIMVpaJOBj7L2XMJ6YpvkbLjbzGMRoAeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aScM3jfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aScM3jfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C28CC4CEE5;
	Tue,  8 Apr 2025 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109950;
	bh=qncx81VHWz2I++RThpwNIhRr3rSoDho4/oadcDb6ySM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aScM3jfE5fGy3jJ5ZoPfYZmoqPbwvVJfATLAm1/B77z7RvKefQ8w3W7u8HmMH7o2y
	 WEfj5IjDVxKBy4yxSJqERsvwPohWfim48EuQ8mNfws6THhnrGMzybotdi6yb0tgFZk
	 dQcz2O+yg6CbdPwoixy7bkB6j7Y7/4Tv/z09hWBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/227] x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Tue,  8 Apr 2025 12:48:10 +0200
Message-ID: <20250408104823.709698474@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0612a73638a81..7641cff719bd0 100644
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



