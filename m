Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A44F4D07;
	Wed, 30 Sep 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784122; cv=none; b=Cfg0qLfVyRecyTWC9b7bLQP0BzmzOyyOFJlWTl7LTDOIxgC/sIAn+d1rY/KDo5vnkU8wlKR72Uqf+V6CDkcrm/QolFkA+I8cMDeW9tSheFqZJ/JZBJCPNqtjrd7BNGPGlSc9dIVpxEBfNQbi5pbv+/nLM6wpFoiEzrs+vM2mEGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784122; c=relaxed/simple;
	bh=Yt1mj4kXgk1+Bo7/Qo0+DCralYiIP9jxKIHz/DNxekU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5XMAnUMZPu1FxEwCS99+yPJkf6yLf/ymy8ZlO4NcyYhr2Tc2AWnutfgeIdFMBJI6g3pGLXGzH40gC0HeskhHgNcvc1uiQqeL4txxBXh+SYe4Jh1UMLjn2a0mlZZ6IYyw8oXrh/kS8jan7jf3I0feiSTu3QfOmp98onPyefjIS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Lw0Gjkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Lw0Gjkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C46C1F000FF;
	Wed, 30 Sep 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784114;
	bh=fc1p51JOT1SjFm5QnJquBZQYCi6XOLBnEsci8HkMPb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Lw0Gjkc6Yjb3RzPF36mQ/gDqB0Eo2HEGAk7QJ4EsPZpQQsbSW0vMUqzFRcqhq87Z
	 Snjtf3agirheGm1RMGNH6Aqh1BmOaQcfWxKjdDSlJNzRdsyBG3IzJ/zEEnvAlfRcP3
	 EfnOaxweIBcUciOaEh5o74ee/JDct5rJutNXXuRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/982] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Wed, 30 Sep 2026 17:12:57 +0200
Message-ID: <20260930152417.679917731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



