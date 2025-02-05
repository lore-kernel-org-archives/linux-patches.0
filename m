Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18856155A21;
	Wed,  5 Feb 2025 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765745; cv=none; b=F2ozADKxpSlhHz1SuR1qdFQM3pRJaBP9TqPGnc4f+r6b876oS5MOaivZ31t5uDsvGrFVWb912MdMq1BfietgEhuLyqjvv2xGx26rRQI8FTuy9h1j6LCcIWnrXfdHijUAk+5U6klyz9jAyrbJySbyeuOpK0Agj1UmLHrsSNE59xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765745; c=relaxed/simple;
	bh=IWEZwvNmtgAqKHTsY+o8WIvJy/YC2KfJL7OAGYCOgW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufyg+nw+0pKi2haTuzfs45Ny9R4bs9hlYtYm0bKOyViv+bqggADkx87TL0I0m3vLZ8qg3Naq4GDbJB90H+/TJrd3Lg/buqElIM/W39ubbQatI18n2F3Ox2lr5eTUOJRXx9Qm5yCwYbEPTnCke+2hAwUh/rFrwcuedv1j7swKgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGffvrw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGffvrw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9F8C4CED1;
	Wed,  5 Feb 2025 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765744;
	bh=IWEZwvNmtgAqKHTsY+o8WIvJy/YC2KfJL7OAGYCOgW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGffvrw7e2orw7Sw9Y6Rxe1zUOso9oQOiCtHCNknuAXWgetjnoJoPpiwhAOzymrhs
	 JzSekIgel31kW+8sj1egb+n1U4zvoErYUTL9xJn2mEvIUssqoWpL0G3iq1PU3w1sKD
	 KAnbHg+qoLquJ9o5FYQJc96/hywnUilkpX9vmX7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert.xu@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/590] crypto: api - Fix boot-up self-test race
Date: Wed,  5 Feb 2025 14:40:03 +0100
Message-ID: <20250205134504.768262198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8dd458cbc5be9ce4427ffce7a9dcdbff4dfc4ac9 ]

During the boot process self-tests are postponed so that all
algorithms are registered when the test starts.  In the event
that algorithms are still being registered during these tests,
which can occur either because the algorithm is registered at
late_initcall, or because a self-test itself triggers the creation
of an instance, some self-tests may never start at all.

Fix this by setting the flag at the start of crypto_start_tests.

Note that this race is theoretical and has never been observed
in practice.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 004d27e41315f..c067412d909a1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1022,6 +1022,8 @@ static void __init crypto_start_tests(void)
 	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
 		return;
 
+	set_crypto_boot_test_finished();
+
 	for (;;) {
 		struct crypto_larval *larval = NULL;
 		struct crypto_alg *q;
@@ -1053,8 +1055,6 @@ static void __init crypto_start_tests(void)
 		if (!larval)
 			break;
 	}
-
-	set_crypto_boot_test_finished();
 }
 
 static int __init crypto_algapi_init(void)
-- 
2.39.5



