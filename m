Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766661C6AB;
	Mon,  4 Mar 2024 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589259; cv=none; b=NjftJVNs3nn4Nsk4ubBPGroAeDbMVCyP7mqqSPccK9I2M00HGQbaHIQ6XEx2G+R63sXP2XiGweyOIbHk7T8VeOHxl0B9GyQvfZVIk+keEkxFVIMbrCjXlLVM95g2knk06MBa88GnaUF6tY1G504UV92CMjYiT8kC5vW9kvTJeXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589259; c=relaxed/simple;
	bh=2rlpYyX30ZenpOoatbhqqU53mwJDCFTB68kvOMqeulY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvD5JggCAcyE7jnEX78qmNUZ6OLRPMcqO9hLSaCcEvn6yb4TfTNvr1kK2S5syDdAURpvvjDJYgGL00ofyu4+nvFEtUYVs8AnesNuSP0YKgmvbb5zL2g4oHmyxTQYm7C/9qxqpdGEgpYsGLeTWN9wfZrDCRet4iFEJSUBHQuZAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnk1CKOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnk1CKOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A2EC43390;
	Mon,  4 Mar 2024 21:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589259;
	bh=2rlpYyX30ZenpOoatbhqqU53mwJDCFTB68kvOMqeulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnk1CKOkKYGcryQ8i/QDJ55th8OdP3B8LuTz+ipl4XjBEpUWa4/D6kFCnJ4pufo+C
	 HErVV6sL6AOZBOtmohg8ZoaFhdEd8TypZCgJ2vMisnWBPLHELup84c1+PRFeorFqwD
	 u4j64nPWb4PUgXLtQAYJw3Pd9Oitx8tZ9aoygZto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/84] tls: decrement decrypt_pending if no async completion will be called
Date: Mon,  4 Mar 2024 21:24:13 +0000
Message-ID: <20240304211543.671086904@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1a99f9f093b1..83319a3b8bdd1 100644
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



