Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D07A2686B9;
	Tue,  8 Apr 2025 11:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112708; cv=none; b=qw2ghG7wfbk6c3rx4rP5ldqN3gOi8VsLDGWmI7K34xaZ8znn3UsyugLy+Xw9FUoLS3ojjly4Z+o3sla87Vbt9ykpqUfjQgC4H5WRAtml3pOuOj4JykAgxusfcJtWijxxuUIUnDdMr04qjpKpgfsDO53iVPaaEhmtO/IoE3FZ0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112708; c=relaxed/simple;
	bh=1eVbQNJXL1TaknzWtcZzNoYtu8+IUnB8iAkS2TiitII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOsMHxuAOF+tLe/eJDSQxS9jImhqhcdhAI7grdawaBXh+KnnGgK3xVpVdiAKudKQEIWu+WfhpuBIA2YWSzKM2S2VkFRD65TX9466ilomb20lZFoefDGWl4LXT5xsW2oopWHF/KdCuYrPqd13cdGLEKDo/WsAy+YWGBJ/ckXcZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mstH2P7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mstH2P7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B3C4CEEA;
	Tue,  8 Apr 2025 11:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112708;
	bh=1eVbQNJXL1TaknzWtcZzNoYtu8+IUnB8iAkS2TiitII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mstH2P7K4DtrmkoaK50pU6Nu66hAtEbfOtGTNT31bqacjC9LjoMRg0tjfQA3x2sOS
	 tUwH3/KCpkL7zSXO7CK0lZGvBhtXSprAPxG20q+L0CEXS3XHnsCdyHfSOPmafTeSk7
	 xsyImlp0ZDFJs0/6x0ZUqSM0swjhZzR5RFpnl29w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/279] x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Tue,  8 Apr 2025 12:48:32 +0200
Message-ID: <20250408104829.823755351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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



