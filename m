Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B20510A1F;
	Mon,  4 Mar 2024 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587722; cv=none; b=uPbejp7U7+m3frbmb+TrX7KsCcPUyB2QRPYyWPNmw4hnBvFQ2LNaIIWNkreqfE3ZwTRdFTfFC2rt3/xCuyRsJcPIFKq3vwUtmQO2lz40vDYj1V8HmUq8tFYUpZtnD+D3IVHMYAHU5SA1NQO9r8zFO+TRH0OcWHQ7jTxU/+cnrlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587722; c=relaxed/simple;
	bh=xm8WhyySrcO1Y6UmIiydfy8YJGDY3Y8SfUqIrkbl/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt1ZF4brsEW7rk81h4tXbkMiztRY48EmuG+gRX3gvwv7pZz9FZUx+szqSw2tjSPYbTfKvQcWY3CgHAIAVYdWU3Nxihmd6AIU6jeyXxHmqAOaBfy/cragAqAjE5/Ov0JO88EgQXmXhHTY0XU0/oBO15mZyj8Hr0D71TR5kseZTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRf1Mrjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRf1Mrjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3E5C433C7;
	Mon,  4 Mar 2024 21:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587722;
	bh=xm8WhyySrcO1Y6UmIiydfy8YJGDY3Y8SfUqIrkbl/aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRf1MrjqeC1DqqVF0ET9Omdir3y7YlhkmvcJa74UsVhEzHIqFw8hfLCk0pp7eXw3F
	 48jpfXvhErVFA/nz/UCeB+q8N2S+v7K/3g1YjFGNY3PzTPXRTcV4MdEus5gKvsvOpA
	 5toiEOY9uj1jgVOOEP5zSGjcZ7E7oEuAVJ2MlrNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 040/162] tls: decrement decrypt_pending if no async completion will be called
Date: Mon,  4 Mar 2024 21:21:45 +0000
Message-ID: <20240304211553.128053716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index de96959336c48..9f23ba321efe6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -289,6 +289,8 @@ static int tls_do_decryption(struct sock *sk,
 			return 0;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
+	} else if (darg->async) {
+		atomic_dec(&ctx->decrypt_pending);
 	}
 	darg->async = false;
 
-- 
2.43.0



