Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93377BAEE;
	Mon,  4 Mar 2024 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588698; cv=none; b=eEOPKlZNUL/ZfVxBYvlMsKKbnCaOZP+CAlC1S6AFPMEGJnZDsx91EFJsTV6sGyfmTxiErQsvdeJvqubNyT4Gxs/NiOXhQBpwBVOiGZC6AIcmY+ef+GWdugqj5t4NyzVmtqymaoDAIO9U4q2Rhq5fjF46smbj3WR24d0FLALOUTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588698; c=relaxed/simple;
	bh=ti0H7dU2hmqdOcgLjganOQ9Pg9ntidTNkJLuuI4T1JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukNBsYs5WcVP4YzteF5ywP1NJFtgV/8cElVmRXza22LLIBMHRy6AvGmDwMi87dI9FPGr/v3ZY8JuhS1eBUed9apalGGozhsGmqdTRUn9hG76SD2NTPGofujwzRit3YMk3h06MaPYjt1RkXQg+V/zoPEWJ/iNOWJs8QlTvFUVze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vavsoGlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vavsoGlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA20C43390;
	Mon,  4 Mar 2024 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588698;
	bh=ti0H7dU2hmqdOcgLjganOQ9Pg9ntidTNkJLuuI4T1JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vavsoGlLGbMzzwJ224YZJQfZRqqv0R9sCBTIeEbIREHBV2mC0oMI5HfYJPa/KrW7w
	 0kf/1zXNY218KffMsUhiM3JGNpVRPkCCiiQ5M5DUzEEJWR96l039Yy9vpBLp0dtMUG
	 H7RooPKOFWtbS33wQRqRYJn5Vp5kVSOZeKrWHcMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/215] tls: decrement decrypt_pending if no async completion will be called
Date: Mon,  4 Mar 2024 21:22:05 +0000
Message-ID: <20240304211558.946021614@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit f7fa16d49837f947ee59492958f9e6f0e51d9a78 ]

With mixed sync/async decryption, or failures of crypto_aead_decrypt,
we increment decrypt_pending but we never do the corresponding
decrement since tls_decrypt_done will not be called. In this case, we
should decrement decrypt_pending immediately to avoid getting stuck.

For example, the prequeue prequeue test gets stuck with mixed
modes (one async decrypt + one sync decrypt).

Fixes: 94524d8fc965 ("net/tls: Add support for async decryption of tls records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/c56d5fc35543891d5319f834f25622360e1bfbec.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 93e1bfa72d791..c6ad435a44218 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -273,6 +273,8 @@ static int tls_do_decryption(struct sock *sk,
 			return 0;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
+	} else if (darg->async) {
+		atomic_dec(&ctx->decrypt_pending);
 	}
 	darg->async = false;
 
-- 
2.43.0



