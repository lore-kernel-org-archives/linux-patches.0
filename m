Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A63DBA1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYTFdK3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFF8C433CA;
	Wed, 15 Nov 2023 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078362;
	bh=4q/mKnusCY8woNu1q286Db7ABLkMbM8vl4FHY8iKFBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYTFdK3l1f/e0fJYZGojlljdcrpxMwntwqJ23lPDVLuB0eB1C2FKjXEhkdm9BAhQf
	 ydpEfWQV46IAT/hG5VweIxecQTfCbkGvQdxaYORGr17hhHbL7cPVHR0glPZ08BI0w5
	 YpwqAbqNxJJ4APb0OHuTM2v0aNYX/zOGPne+MU9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/379] apparmor: fix invalid reference on profile->disconnected
Date: Wed, 15 Nov 2023 14:25:27 -0500
Message-ID: <20231115192700.048724908@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 8884ba07786c718771cf7b78cb3024924b27ec2b ]

profile->disconnected was storing an invalid reference to the
disconnected path. Fix it by duplicating the string using
aa_unpack_strdup and freeing accordingly.

Fixes: 72c8a768641d ("apparmor: allow profiles to provide info to disconnected paths")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c        | 1 +
 security/apparmor/policy_unpack.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index fbdfcef91c616..c7b84fb568414 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -218,6 +218,7 @@ void aa_free_profile(struct aa_profile *profile)
 
 	aa_put_ns(profile->ns);
 	kfree_sensitive(profile->rename);
+	kfree_sensitive(profile->disconnected);
 
 	aa_free_file_rules(&profile->file);
 	aa_free_cap_rules(&profile->caps);
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index fbddf6450195d..7012fd82f1bb1 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -656,7 +656,7 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 	const char *info = "failed to unpack profile";
 	size_t ns_len;
 	struct rhashtable_params params = { 0 };
-	char *key = NULL;
+	char *key = NULL, *disconnected = NULL;
 	struct aa_data *data;
 	int i, error = -EPROTO;
 	kernel_cap_t tmpcap;
@@ -710,7 +710,8 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 	}
 
 	/* disconnected attachment string is optional */
-	(void) aa_unpack_str(e, &profile->disconnected, "disconnected");
+	(void) aa_unpack_strdup(e, &disconnected, "disconnected");
+	profile->disconnected = disconnected;
 
 	/* per profile debug flags (complain, audit) */
 	if (!aa_unpack_nameX(e, AA_STRUCT, "flags")) {
-- 
2.42.0



