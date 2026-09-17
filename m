Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CFE5452B5;
	Thu, 17 Sep 2026 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661196; cv=none; b=tQEL8PV9uR49VDSt4a9KtisNzl04K0MgC0KRt7u0qxXxtRDHiLso5OpwmiYSukAqDY7Hjf/EmnM3WeGW6Sqgdb2AiaOvP8hURpTCoarpJMBs3aTMOj8bYpfOnHFI1/dTSOenlYIMa7WrGZH0mf0J71h1edYzba0xH7/ijQaluus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661196; c=relaxed/simple;
	bh=DWSLEym1+fo5rSanmDaTe6vUhkjJQAVhiOOG6X9zRlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIv2ZQ8HyeJPm94F3cnAnTUHOFUVv/xjDDd8FF55MmXPGp7c3w2Ln3yjdlpw35WjKIJATwHsoMUxvcXd5RjbgOPrdqJGLzuW58DskQoM7rVNnJEHM8tsKcz2HD4Xm+Fse3Fa8Fekf5AUPGET05CwlvdZdgpUmhf2+Ohemxe4H7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twcCL4Ct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twcCL4Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD421F000FF;
	Thu, 17 Sep 2026 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661194;
	bh=5H/o7mXdXyWzFXN9+NIDA1xb/jnY3HHm6na4tCHeh+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twcCL4CtHra9vw4lU3if5od3WvhBNP7VmSZLGiJ7TwmOXk28mzYWLm8WcipxQdEul
	 EP4Jp4sZ6mh4HCmTYH4pwpeV0+4nBOx2+1SIMvXZrtGFA8blsQfnfTYkRgGeEBce4L
	 atjZD9sebOYvGQokPsNvvleI1JVxC7ElR5Vd/WdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0113/1250] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Thu, 17 Sep 2026 15:58:28 +0100
Message-ID: <20260917151555.076917375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



