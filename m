Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203313624BF;
	Wed, 30 Sep 2026 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790709; cv=none; b=K+4qUDPRYkE/YSlpHWmCrXk/Ro2nok4oSsY2kiLUkrobxH9DCA/YkTdKp6Vt5CCtbhWYZPizvB2W7uvZcnzA3khtEWdubbR3XT61J25fORFr/LnAxSAMWytPMADNF6b9wGD6fSx3iAEsC1IZUmRXyS6Da2gZtdFKAsmNbrx18F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790709; c=relaxed/simple;
	bh=Y8Ek5eHL1fdputWUZRpsBlAyLv0rH7b5FAxuXhBGfSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+7th/kHxNB3FgNl5QbwHStGstIhWhy0uuJMDOyR+taHwZ9V2JJXlDxTuMyOxPldxwga+M9A5G6R2pfwiNKTxXGI9ow7lhe1F9jN/AdK/y4aCjUsWYArsswjpAPouxcYXBLGK39jI9b2vI9BowV3IaBDhG+lAXr35ZZ/3z2JL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqoYQbiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqoYQbiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F411F000FF;
	Wed, 30 Sep 2026 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790707;
	bh=2YOtB8DE8XxacGjY1D4cLQ2oUwr0qOhQm1AG8kP9eQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqoYQbiwPFjKBC4klFfOPxscYmpSDJSfE+r2I5HluUcAAbfSoNLkqxtFqIlYVDGJo
	 4IpbBBGpZ8ru7bdu+5k2O5POpgXFqgJkvvVizVltMeEiMMzJJDdppweo+wqkIGWm3/
	 mns6jpVfCbtCFP7wFym6pB5/ESjfD2/aLw+i5qSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/752] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Wed, 30 Sep 2026 17:18:19 +0200
Message-ID: <20260930152358.780518002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 895f4b9ce8c6b..b6b66f34cbf93 100644
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



