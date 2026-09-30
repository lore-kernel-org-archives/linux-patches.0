Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C14D37AF;
	Wed, 30 Sep 2026 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793985; cv=none; b=UodwU2MzcsWzsLNntEBkdobkRs8h7pdahkHfXPgDhWKPMFRqRGXFL/6om8QThK8XcWl7VIYO+g2HQrOAIVKgcdjSke9ir9Pg77O0QJAmxU5feOEISJSfOlLg70hsrky1eKohygA4f7pdLhZ/cTUvo8Vi7+AbdoBF/HW0cyk9kOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793985; c=relaxed/simple;
	bh=P9OU62F9DjEvJ1FtV5GfGP6RHTUxP4zYeGeO6G99eqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6F0ERTu+Y/2IDrG3Z3LzmaRFBPVrF1CHwck6MGLiKE5vr/MapJuFo3j1Stk5wa7afmyxXMaMsmrufTFEFhsdVMCj4PP2IAvLvhCfdyWOpxNLisIdkiB1qRlF1G0CTuT6P1QqPzBjdVYjbW0Xv88k8iw//G1fmq0yHCnAFXUu1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3BIc1D5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3BIc1D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F6A1F000FF;
	Wed, 30 Sep 2026 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793983;
	bh=uHT+LMFxckmb2iObzcT4drcOni7QfJEOZf/59mn77J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3BIc1D59nGzBuH5b+3a0z6aEcyhsXvxqIuk8N2eMra2hyXjjBbqXGvIbrO/k48Sh
	 iAyr6chjaGtucCUxSyXcGvQTMlEzLOc7xrE5gKRgG5OOkkAaTCHJb5kUGb/VIsfBy3
	 +iXp3o256qXASR+y3FF2ta5AqNlOZ1Hl8QkoZc0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0049/1193] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Wed, 30 Sep 2026 17:12:13 +0200
Message-ID: <20260930152435.370344182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



