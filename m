Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386435AC00
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302680; cv=none; b=h5BPI9HsYuCezCrZ9mI9uUItYn4PDmEsrfYsy0jBjKeTv8y+bJccNvFmog59ncr+M8lWHnNt62qDGq8oVP5c/EmwbKYIpYs1JqhaD7sgsBstl09+NgvpCOoVJL3JWd6PMv3H5X8bjOJaVPwVsX9sPmtkB/xE76USSSeDohfEwAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302680; c=relaxed/simple;
	bh=kduh1DwcX26VtBRL/B55zNIspoVqmD7ei9NFANC0vyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzwkfVS9aZnwETMubQqknZiNeWm1Bv0GHo51OmcJmbfez1LtTX3tSndfEQLqkumqLv/nGgIRTGW3f3PU4Wt/NqtIBGVGFnk++4/N0RW1uV9Bepx1j0DNVVrQYjXmZ6bT7caOYvxE/D/e9DgOcj444G+g+S7b+tBVV9EZPyzTmhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecwPQ0/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecwPQ0/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB8AC2BC9E;
	Sat, 28 Feb 2026 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302680;
	bh=kduh1DwcX26VtBRL/B55zNIspoVqmD7ei9NFANC0vyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecwPQ0/bJpP/nMz3wpH4QAC6MWIA6+5USWAdiXV3vuJIZDbrDT2g7DJZFZzlQNn1z
	 jZwG1Op0y3wiqDU/1p++rD5q/BHYYIRqG7SXPAzBkHwhWRonj9nSjluxRxmLMClUUe
	 dMZYxqovX7YQLppbZpZ9PzF83nDoS+R9/ZBmFq/ppRz5b6lGIwAgXMA6ne/PL7Yiqi
	 Nw+r65SO/K8Xrbdw93Q2uVmorIZc2qeWJ7+WavYV5qDk0wKVBLVc9efAbanEYtiWkW
	 E6jIuC4IExN8fvZ/Gc/2JyCWJnruFc7DKGif0nIG6vzJNjgdccq6hmaRxwOod0bTQy
	 /yP9hPhEjv08A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/147] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:15:39 -0500
Message-ID: <20260228181736.1605592-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

[ Upstream commit 7b5c7e83ac405ff9ecbdd92b37a477f4288f8814 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But the limit calculation doesn't take
the first 11 bytes that we wrote into consideration so the limit is
not correct.  Just fix it for correctness even though it doesn't
affect runtime.

Fixes: 64e1fdaf55d6 ("i5000_edac: Fix the logic that retrieves memory information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/07cd652c51e77aad5a8350e1a7cd9407e5bbe373.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5000_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 1a6f69c859ab9..bee3877b76e4c 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1111,6 +1111,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

