Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A111519AA;
	Wed,  5 Feb 2025 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764286; cv=none; b=SNyE1/fqqZhTOqDEcnWZThLW9PTEyo8ESjvWJrvSUmXSssA/SOFfkYz7vDFKbml+w1eS/9fVyNqy1lFv1VmSQLV8CjIfL3BK23FiNx0okuH49F6W1+v+8KS67QfqMZ8c1dnv+mlQhANBdO3J6tUBsnYMPSctqvqe4QepBfXmuew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764286; c=relaxed/simple;
	bh=5GOlIOm9yy0zRwFkIB/m7iqV9IvDt6XkPwXDUeS+YLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnszeWrmlPE4SHTtdKidmUGTGndqSlAMQAUMFMPYEZFzhSNImec8FgIZMrpsUwa8fiQLnwrFZ2eqUaHnZcc42y2NSP+gJAPWIRz6LJpDEmtEDY/NZUrsKvkD6VbDlNncgb23yWg2nNgoPt5ljSQqP4z9bfZScFyk04zWzuE1Ceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ge8Ti1Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ge8Ti1Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5174BC4CED1;
	Wed,  5 Feb 2025 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764285;
	bh=5GOlIOm9yy0zRwFkIB/m7iqV9IvDt6XkPwXDUeS+YLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ge8Ti1YtDEcD6uNYAruwpi+LIUWPnyk96wgz2QMPieQKTSr0xzq6VUZEVZlhzhZ8H
	 DniirPPvsVi0nzKsNTDwdaJjIQl+O9Hx8lJdQDPyjqbvfrFhUalWCP+n+dcxhOR5ss
	 n8RPcjF0Q7w7VoSpda/IVImtWiitOI6/58qMBvwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert.xu@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/393] crypto: api - Fix boot-up self-test race
Date: Wed,  5 Feb 2025 14:41:17 +0100
Message-ID: <20250205134426.347704408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3a6086042530..f287085a21fa2 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1059,6 +1059,8 @@ static void __init crypto_start_tests(void)
 	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
 		return;
 
+	set_crypto_boot_test_finished();
+
 	for (;;) {
 		struct crypto_larval *larval = NULL;
 		struct crypto_alg *q;
@@ -1091,8 +1093,6 @@ static void __init crypto_start_tests(void)
 
 		crypto_wait_for_test(larval);
 	}
-
-	set_crypto_boot_test_finished();
 }
 
 static int __init crypto_algapi_init(void)
-- 
2.39.5



