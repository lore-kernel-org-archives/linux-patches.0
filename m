Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B21B3C2790;
	Tue, 21 Jul 2026 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649645; cv=none; b=n21ycNx5nLH5Cca0tr+CaF7B0ma9lDNnCx90nC1wg/uhCn/PaL1ZfsccSB/Ba3YGfgTRdq5ynsrId4bCutsN25ID/0yUSdaj5+GerFEqwk3IkwaRriyyeEi9yxZYT60T36V+sH+aGVi18QrZ5o5JLP3CMK3eQeRhLfi0LbQHjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649645; c=relaxed/simple;
	bh=T78mj+0z3N/GrwkjAljGCvNfXRq6wU1NrBnDUi7j3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf5BtRscIdTzsDGXoF2iUflbFviKqOEPmvTzxon3GRWjXy78g1BIZ2GCZ9MH6P04N+NPfS/cSAZ78W/zK7ZHzIpUoO1mjvvIyY04No2dGprcV0yp5VQgdOckYGFoWQt4ocr4kdniIjoSgoRcbdGhy87fFki/++j8yLClfKvkjnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAKisv/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAKisv/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEDA1F000E9;
	Tue, 21 Jul 2026 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649644;
	bh=n83dMt7n8AKFBavhUsmDeNvjcCZAJdJ1176/LP46p8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAKisv/OcVurEbyWjNz/K66qn6Fetw3nxYV+pd/oF1QHPahSS/mKETUc6GfnQPdBg
	 WQKtD7Ey34dI3KioTUoVUKhvtD3u5Ve9j6NA1gtkzTSIma/BAqvk3e3ychVGYOqXUz
	 rbosg+cGIaXCbkXNl01Yzl/nmtoorhqH1xXGNP3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0656/2077] cxl/test: Fix integer overflow in mock LSA bounds checks
Date: Tue, 21 Jul 2026 17:05:29 +0200
Message-ID: <20260721152608.277456792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 81eafcada109b653977c4dfbd2b6a72470025a01 ]

Pre-existing issue discovered by sashiko-bot.

mock_get_lsa() and mock_set_lsa() validate the requested LSA range with
"offset + length > LSA_SIZE". Both offset and length are u32 and, in
mock_get_lsa(), both are taken directly from the user-supplied payload.
The addition is evaluated modulo 2^32, so a large offset combined with a
small length wraps around and passes the check.

Rewrite the checks to first bound offset, then compare length against the
remaining LSA size.

Suggested-by: sashiko-bot
Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Link: https://lore.kernel.org/linux-cxl/20260605143748.235271F00893@smtp.kernel.org/
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 2e9a5f151e983d..9a7cd3f46a1ee5 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1063,7 +1063,7 @@ static int mock_get_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(get_lsa->offset);
 	length = le32_to_cpu(get_lsa->length);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 	if (length > cmd->size_out)
 		return -EINVAL;
@@ -1083,7 +1083,7 @@ static int mock_set_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(set_lsa->offset);
 	length = cmd->size_in - sizeof(*set_lsa);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 
 	memcpy(lsa + offset, &set_lsa->data[0], length);
-- 
2.53.0



