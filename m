Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A713FD86;
	Tue, 26 Aug 2025 13:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215398; cv=none; b=phVZJM1ENVYJ+Q+Wz5MesT2gUSGyWjNcWJKEBhkih26sJaza9ltqjw6Qj4rmaVUTOlzT/myF5i+0FPjpqNGy98fTCMpeU9cWngopF/2RAV6tTl1opTlONZd+dDr2g7U4m0yc53Y/cO9Y0vGF0uSk11C7/iV28Fj2+51Ue4A9wqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215398; c=relaxed/simple;
	bh=rgRHP2BkVYtuWhHpc4BVLxTGpQxgBPa4o+5gohdbLMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvYKZXWmIvnccVCqkoICP9FchEOAekEcDvJ84AN0DSvR3a4RIR8bAkvMcgyqGkeFhvcIZUuzB5FLXrAhmw5j8JQYYWTMCIRFZ0d4f+xsDrO1uK9n06jrwcBiMc5zc0LtMVG4mzGP9S/dolaRN6hNRpA4glUle/ijDj2QVoSeuuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNBwm1sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNBwm1sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C38C113D0;
	Tue, 26 Aug 2025 13:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215398;
	bh=rgRHP2BkVYtuWhHpc4BVLxTGpQxgBPa4o+5gohdbLMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNBwm1skZKZBU7PnbWIe+njjfo8k3Nz3SaSPYwgmjzo5fUdi/Av4+lzKXUqwuz39U
	 sPU1v6IF5N6LgG4dbKX/BKjNKejFPatGQPrgW3WzM+0fPgvbxTEtegYqFk/5juGl4U
	 GpD5mI+RPcrXAkoIaJ7MDwdpR3N8WBQIMW+bdCT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 019/644] memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()
Date: Tue, 26 Aug 2025 13:01:50 +0200
Message-ID: <20250826110946.984455140@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 21b34a3a204ed616373a12ec17dc127ebe51eab3 upstream.

A new warning in clang [1] points out that id_reg is uninitialized then
passed to memstick_init_req() as a const pointer:

  drivers/memstick/core/memstick.c:330:59: error: variable 'id_reg' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
    330 |                 memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
        |                                                                         ^~~~~~

Commit de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull
warning") intentionally passed this variable uninitialized to avoid an
-Wnonnull warning from a NULL value that was previously there because
id_reg is never read from the call to memstick_init_req() in
h_memstick_read_dev_id(). Just zero initialize id_reg to avoid the
warning, which is likely happening in the majority of builds using
modern compilers that support '-ftrivial-auto-var-init=zero'.

Cc: stable@vger.kernel.org
Fixes: de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull warning")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2105
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250715-memstick-fix-uninit-const-pointer-v1-1-f6753829c27a@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(memstick_init_req);
 static int h_memstick_read_dev_id(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
-	struct ms_id_register id_reg;
+	struct ms_id_register id_reg = {};
 
 	if (!(*mrq)) {
 		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,


