Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B3310647;
	Mon, 13 Oct 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368067; cv=none; b=oKiH3iYHeAml7tQ7LOo9RtpgYQBWTjqlLuoxZg+PUo+ibhqNQGDqwfNSZWsZzq3YUjc2RiqZXuvLXPllw5nUcg1cRQ4E5Md2wDZu+CKpB/Fouw3CsMhpZhz/fkrORlDlWx0jAF82b9rE5m3EEENsWP/CFuiABxUFF6TbjrWP2cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368067; c=relaxed/simple;
	bh=SvWC28SMlSKljUxe1ITsFmCT0/fErZvFrhaNeRhmhrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZfrreF6O29esb/J7hzU7EHYrVWuNKHm7mCn9Kp5jWz+IIVmPUq/t0roceX6IM4LVmZjis2Rg5ZEIHdqRdVz1Xrgx3YaTl63wmYn6+78nHxu6PO0o84kbdsLri6h504n0T933M6+LyLOHF1sNQtBKTv8l2LSZ5XArWXKwbCdKP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSAyPOnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSAyPOnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27922C4CEE7;
	Mon, 13 Oct 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368067;
	bh=SvWC28SMlSKljUxe1ITsFmCT0/fErZvFrhaNeRhmhrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSAyPOnK/T2YTmCtShqTS8wuAS1k+mD0x+uSl3UZaUu5nHZ5HihwWWAgZEewcDLRP
	 Xm9c3qx39BJ3KfusQOEkprTRTmE4KSJygitAS7QxA4Jedab3aXpqfIR885A24ahA8K
	 P9DEF0SS5n0qOjTI/gLUDq3yxkx/BbgGL2WnQxZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/262] selftests: arm64: Check fread return value in exec_target
Date: Mon, 13 Oct 2025 16:42:26 +0200
Message-ID: <20251013144326.282435671@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

[ Upstream commit a679e5683d3eef22ca12514ff8784b2b914ebedc ]

Fix -Wunused-result warning generated when compiled with gcc 13.3.0,
by checking fread's return value and handling errors, preventing
potential failures when reading from stdin.

Fixes compiler warning:
warning: ignoring return value of 'fread' declared with attribute
'warn_unused_result' [-Wunused-result]

Fixes: 806a15b2545e ("kselftests/arm64: add PAuth test for whether exec() changes keys")

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/exec_target.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/pauth/exec_target.c b/tools/testing/selftests/arm64/pauth/exec_target.c
index 4435600ca400d..e597861b26d6b 100644
--- a/tools/testing/selftests/arm64/pauth/exec_target.c
+++ b/tools/testing/selftests/arm64/pauth/exec_target.c
@@ -13,7 +13,12 @@ int main(void)
 	unsigned long hwcaps;
 	size_t val;
 
-	fread(&val, sizeof(size_t), 1, stdin);
+	size_t size = fread(&val, sizeof(size_t), 1, stdin);
+
+	if (size != 1) {
+		fprintf(stderr, "Could not read input from stdin\n");
+		return EXIT_FAILURE;
+	}
 
 	/* don't try to execute illegal (unimplemented) instructions) caller
 	 * should have checked this and keep worker simple
-- 
2.51.0



