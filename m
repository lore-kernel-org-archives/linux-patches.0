Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F323633344A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301227; cv=none; b=rae4fNiOp+ZFe5QNRscwMwzho+DReD13wubQTrFCgcNM2HQRImzfwqr98Kc74Wo2UVfpSzs9lUNweqPpVUON77RPJae+BoyHT33vyQlS6vmJjak69Zvur+yyoYlItcfu2cXBf6mGAtoMW+d0ZNXN0H6xzCZf66iaKxr8eNX9m0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301227; c=relaxed/simple;
	bh=dH/i1FBsguOEmUILzyVjTdcuHv2E7eXf4aeX/spdWmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvNEa03+A9u8NkAFfeqKf2wMLKgDjZX47W5bCkYYJhHz8cmDi3P9BaOqvSo6XXrZzvjrYdus5g4yh12H7MTwksP6sHTdJq2Cy7cJ98xBVxHKcAs9+FmHaklgmP/iMM4Bdi+r3FZUyt5o1KBztwLY3KqulUPsCMHOowfSSf1mVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ls/vth/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ls/vth/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C607C19425;
	Sat, 28 Feb 2026 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301226;
	bh=dH/i1FBsguOEmUILzyVjTdcuHv2E7eXf4aeX/spdWmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ls/vth/F0+0Eu4G5crIb9EvHJXLkMvi0+pjMfLA+pHot1i+7TdQSkglwVZ+bYQA+3
	 R01zuP0mgD4cmNSZa76FPCzz9ABj3tJ6L3qlKbQG/LdwWZg8qcKxxNRJipJElCVhV6
	 9FzgFIx5GPr1pqt5F3RR5SmGYn8aSTT2Vhw11dIrc+H7iDr0JMpW+pU0+SG00l+SMS
	 /eRB7Ng5A0VaNVn6TrQlxCzoDn/vtieDsbcbnxCd2LoQyrDSZaZXEq4rHGwcv3ekhD
	 xxTo++rPy7pbcZ7j7OboWcP+AzVXT4IRbipFUzMD8vLw5auMyiPKCk/ShVQonMTqgC
	 b62jX+qyTgNvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 404/752] espintcp: Fix race condition in espintcp_close()
Date: Sat, 28 Feb 2026 12:41:55 -0500
Message-ID: <20260228174750.1542406-404-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit e1512c1db9e8794d8d130addd2615ec27231d994 ]

This issue was discovered during a code audit.

After cancel_work_sync() is called from espintcp_close(),
espintcp_tx_work() can still be scheduled from paths such as
the Delayed ACK handler or ksoftirqd.
As a result, the espintcp_tx_work() worker may dereference a
freed espintcp ctx or sk.

The following is a simple race scenario:

           cpu0                             cpu1

  espintcp_close()
    cancel_work_sync(&ctx->work);
                                     espintcp_write_space()
                                       schedule_work(&ctx->work);

To prevent this race condition, cancel_work_sync() is
replaced with disable_work_sync().

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/aZSie7rEdh9Nu0eM@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/espintcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index bf744ac9d5a73..8709df716e98e 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -536,7 +536,7 @@ static void espintcp_close(struct sock *sk, long timeout)
 	sk->sk_prot = &tcp_prot;
 	barrier();
 
-	cancel_work_sync(&ctx->work);
+	disable_work_sync(&ctx->work);
 	strp_done(&ctx->strp);
 
 	skb_queue_purge(&ctx->out_queue);
-- 
2.51.0

