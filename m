Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165854704F;
	Thu, 17 Sep 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667401; cv=none; b=Pj7CtMUe4IPLPVlJ+Wu7XekajotCplqXhBmCaFilaOV8rd/PgO/KaTve65sZZ7ae0jblAmPOWma+pOdCWIX/NISmckoi8ZgJQdNOnx63gZIlseeg0d0SNLTCO/J67993fmDDQGVmJ9hAZrWGuduX55a5NrN7ZMkpAgfpAWxWzKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667401; c=relaxed/simple;
	bh=/T2eXMS+fe31F4pMv5s+bjD9wdKPjFmno7AxsKJsY+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5M6+7pkRYE6M+ea1Bt/IuZ05+pvWI2YNQVEPllD4MwE0PkeiZLzUjZyfXmgeXqCo+8vZPFqD9BwBnHhhgQ3BB0wgKbF8EMXlLhaCKK6/uHSWgriNgLJkr2o/QcZLMwXQbwMizkhHkJ3HC0R8dAAJOk3UHsIONN6crWvDa2nZ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9IrUbd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9IrUbd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90601F000FF;
	Thu, 17 Sep 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667399;
	bh=ny9UKR25vcx7Tbskukf3uvxmO4wDNoCuKwfJO39Hm80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9IrUbd5AClL5FgH498nT7gGhh6x+l3Mewi36fCjAa0zK5J922y4Xd6hMKar2Woo7
	 uJXri2smwDxMWOUnLHaTUVp2pVr8xgtgfGhcf7CuA1D45HcJQyOvcqQt5U2qqpd9Ia
	 0lIhwRKlAnBfwRVoJVHvlUDjzTR3Uk74snuJnGOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0079/1102] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Thu, 17 Sep 2026 16:00:22 +0100
Message-ID: <20260917151541.456711701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit c93a5f038ccc11ed8558ce642f62d5ede701a348 ]

Check for a NULL pointer returned by asymmetric_key_public_key and return
-ENOKEY in this case.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Kamlesh Kumar <kam@juniper.net>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/digsig_asymmetric.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 457c0a396caf3..17219424a34dd 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -108,6 +108,10 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.hash_algo = hash_algo_name[hdr->hash_algo];
 
 	pk = asymmetric_key_public_key(key);
+	if (!pk) {
+		ret = -ENOKEY;
+		goto out;
+	}
 	pks.pkey_algo = pk->pkey_algo;
 	if (!strcmp(pk->pkey_algo, "rsa")) {
 		pks.encoding = "pkcs1";
-- 
2.53.0



