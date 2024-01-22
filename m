Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14C51C44;
	Tue, 23 Jan 2024 01:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974044; cv=none; b=sBmgZNdaz4Ii81MTRtREVKknCQM7iS4n7HQbAyogItyb4w16iZhNRnKw1XzEQ4CGFaHojzz3qDh9VfkJsp3dsk7cY6gfAcZSWkmYvDbttl9UHm2I+7EfZ9hODZ6o/zQ25+RFNIxEPkmi4/ZfZ7Td02vc5Q95jOIbr7PIe3bwj1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974044; c=relaxed/simple;
	bh=vD4FmNhDUIfx4aSxpYKr05eQhMrXne6BjyvsdYRBhPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUp5FXkvz53SkrYoS7BKH0M7AlEuhEKBg70fWZrPi9xpwKi1aqKcyX+jpl928R9oIYMZ22pJt19shyT+r/1iRSeae+kNL6K/LFzVH4DYnlkR6OTE5O1kcvY4c512a+8SaBiP2ekRb6NvQ9FE/iZlDZhZbLXMgH8U6zFD/rNRJP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ieru0Q74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ieru0Q74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE35BC43390;
	Tue, 23 Jan 2024 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974044;
	bh=vD4FmNhDUIfx4aSxpYKr05eQhMrXne6BjyvsdYRBhPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ieru0Q74XQuwp5QtJgA6h/S7G1HRJ1f71nN2VAp+Fad2syjiCboPQuOsusKc6xlgt
	 KKWyTsVSJqKr+TAavMer/VepO8Y9TnmFNrdFf5qaFwi3fCRsf5pNeADmdvippHVUNb
	 e7kQRSiI/ta86g5Ghtmg3JeIb1BjBmZyhctc3oew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/583] powerpc/rtas: Avoid warning on invalid token argument to sys_rtas()
Date: Mon, 22 Jan 2024 15:51:06 -0800
Message-ID: <20240122235812.686882590@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 01e346ffefda3a7088afebf02b940614179688e7 ]

rtas_token_to_function() WARNs when passed an invalid token; it's
meant to catch bugs in kernel-based users of RTAS functions. However,
user space controls the token value passed to rtas_token_to_function()
by block_rtas_call(), so user space with sufficient privilege to use
sys_rtas() can trigger the warnings at will:

  unexpected failed lookup for token 2048
  WARNING: CPU: 20 PID: 2247 at arch/powerpc/kernel/rtas.c:556
    rtas_token_to_function+0xfc/0x110
  ...
  NIP rtas_token_to_function+0xfc/0x110
  LR  rtas_token_to_function+0xf8/0x110
  Call Trace:
    rtas_token_to_function+0xf8/0x110 (unreliable)
    sys_rtas+0x188/0x880
    system_call_exception+0x268/0x530
    system_call_common+0x160/0x2c4

It's desirable to continue warning on bogus tokens in
rtas_token_to_function(). Currently it is used to look up RTAS
function descriptors when tracing, where we know there has to have
been a successful descriptor lookup by different means already, and it
would be a serious inconsistency for the reverse lookup to fail.

So instead of weakening rtas_token_to_function()'s contract by
removing the warnings, introduce rtas_token_to_function_untrusted(),
which has no opinion on failed lookups. Convert block_rtas_call() and
rtas_token_to_function() to use it.

Fixes: 8252b88294d2 ("powerpc/rtas: improve function information lookups")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231212-papr-sys_rtas-vs-lockdown-v6-1-e9eafd0c8c6c@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index eddc031c4b95..87d65bdd3eca 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -544,6 +544,21 @@ static int __init rtas_token_to_function_xarray_init(void)
 }
 arch_initcall(rtas_token_to_function_xarray_init);
 
+/*
+ * For use by sys_rtas(), where the token value is provided by user
+ * space and we don't want to warn on failed lookups.
+ */
+static const struct rtas_function *rtas_token_to_function_untrusted(s32 token)
+{
+	return xa_load(&rtas_token_to_function_xarray, token);
+}
+
+/*
+ * Reverse lookup for deriving the function descriptor from a
+ * known-good token value in contexts where the former is not already
+ * available. @token must be valid, e.g. derived from the result of a
+ * prior lookup against the function table.
+ */
 static const struct rtas_function *rtas_token_to_function(s32 token)
 {
 	const struct rtas_function *func;
@@ -551,7 +566,7 @@ static const struct rtas_function *rtas_token_to_function(s32 token)
 	if (WARN_ONCE(token < 0, "invalid token %d", token))
 		return NULL;
 
-	func = xa_load(&rtas_token_to_function_xarray, token);
+	func = rtas_token_to_function_untrusted(token);
 
 	if (WARN_ONCE(!func, "unexpected failed lookup for token %d", token))
 		return NULL;
@@ -1726,7 +1741,7 @@ static bool block_rtas_call(int token, int nargs,
 	 * If this token doesn't correspond to a function the kernel
 	 * understands, you're not allowed to call it.
 	 */
-	func = rtas_token_to_function(token);
+	func = rtas_token_to_function_untrusted(token);
 	if (!func)
 		goto err;
 	/*
-- 
2.43.0



