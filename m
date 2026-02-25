Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06FD1EB5E1;
	Wed, 25 Feb 2026 01:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982918; cv=none; b=gcO5qleyok45C0xNFEZN6rc7Q6ohL3s7AjetRGkclybPTRXNPXKkr9qwPK/jkzjaiKn1RILReXxH4h4Ek9pZX9Up00gCEdan4GyRGijfQJMZDghNTRQRCO48NkvxqEdo0epfqGWsSHIztMTgmpJEYJbHJxDFO8n4RPr1f5nmpaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982918; c=relaxed/simple;
	bh=V20TP94DhIPX/EYP9nz0T7tSdB2IDzqDU+fnXklvyyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwFK2leVsxejA2VaN/c7LLkw/lSeYGtKqnjnf5YknMfKBSbIAPugst+16w2LgUvFWrbvYm6f2l+EVWaj6dqRsNb2LXHRSeZnmgtHRr0cOFnESKFo/LbA9STIT3gXZ5Y1xZpv8o/mMxYoeWKh/H1SdTMxeeWgPAkR5fDZ4ojPr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd5psS8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd5psS8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90174C116D0;
	Wed, 25 Feb 2026 01:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982917;
	bh=V20TP94DhIPX/EYP9nz0T7tSdB2IDzqDU+fnXklvyyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sd5psS8gpD5NC47I4tT2fDK8blzmsdTakH3vCK04nN01c6vHVfVrzpQ+CrveqixkD
	 4T56NpLZiTQu4x3rS3PPWVNaeSIGUeYXpmOK2bR3/0jiRI8hPwJNUn380NMmPBzXSW
	 nllohgdC9HFFVdEotTBALnFS4XnAQ4TvhSP3cDxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 097/781] crypto: inside-secure/eip93 - fix kernel panic in driver detach
Date: Tue, 24 Feb 2026 17:13:26 -0800
Message-ID: <20260225012402.068709825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b6e32ba6d32503440a3e3e16c8d0521cbb7e0c5d ]

During driver detach, the same hash algorithm is unregistered multiple
times due to a wrong iterator.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 0b38a567da0e0..3cdc3308dcac8 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -90,7 +90,7 @@ static void eip93_unregister_algs(unsigned int i)
 			crypto_unregister_aead(&eip93_algs[j]->alg.aead);
 			break;
 		case EIP93_ALG_TYPE_HASH:
-			crypto_unregister_ahash(&eip93_algs[i]->alg.ahash);
+			crypto_unregister_ahash(&eip93_algs[j]->alg.ahash);
 			break;
 		}
 	}
-- 
2.51.0



