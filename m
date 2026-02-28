Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA76C346FDB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302331; cv=none; b=DW0KjdpZYdKnEzzZjvvpd6yAhrge+Ls4kx+K+FpHgvrbtC7ki1YbobrSkSxLxizq7/ImTPmYvwARo0RaFCVKtgM7ZrSQlaEz/GSqWcqvakY8i/mfbid/99sKbRAhHJa4/evwBCe0pnoh+pO6yoVFUZ2YXdmAtZc41mXBwSNJMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302331; c=relaxed/simple;
	bh=l60rLUv/1rBpY2EE6cMDOavrb5NY8VvK3x+Qf1zvtgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvqwEApKg2WjmHbSW0gu1ZMpzPw8ZjUv6kB499dcZCGSBc9LTVUMh4rmYpNckej2kS++Vj8Jl/UZnHSxSP9AHXqAVvwaINy+ChpTGbMoSvHVSOEur+1sZegee8XGiNtiYmK+IQfuytel68l6DZmqh2Lhb6mL9RGq+gpDnDH6Two=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CT5tamEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CT5tamEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22296C19424;
	Sat, 28 Feb 2026 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302331;
	bh=l60rLUv/1rBpY2EE6cMDOavrb5NY8VvK3x+Qf1zvtgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CT5tamEGJdF5y5Hg71u33sEKvZU8p0V36jKRfmFJfgjx+haRv/ehTwVcbZOpm5jtW
	 rPreeVvAzQriWSk+lACZDey9bzp7XlCfu8IKsEVNDzP1ONRqkDOA0yvmHKYDR8UEsM
	 ROnC/jd4qQQysVVVgHLB7krXzQmQqlnfz7Txaamwd13h1vThy1p7ZzNpJbYkQztys/
	 CrY4vvQFK99a88zMTMJsxePrM/FR/ugTzHfD9R2JiHHP7+dSdyfdj/r7T3QA1aD40Y
	 CAzKJW/bXav0+qb4PA/FIVPQ7xsPaF9EXstkMVvdGeApSz0jp+8e/GfOskLWphYK8n
	 eX+GwehwyRhcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/232] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:08:25 -0500
Message-ID: <20260228181127.1592657-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72f12683611344853ab030fe7d19b23970ed2bd8 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But my static checker complains because
the limit calculation doesn't take the first 11 space characters that
we wrote into the buffer into consideration.  Fix this for the sake of
correctness even though it doesn't affect runtime.

Also delete an earlier "space -= n;" which was not used.

Fixes: 68d086f89b80 ("i5400_edac: improve debug messages to better represent the filled memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/ccd06b91748e7ed8e33eeb2ff1e7b98700879304.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5400_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index f76624ee82ef7..5b1188f1b5705 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1024,13 +1024,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
-	space -= n;
 	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

