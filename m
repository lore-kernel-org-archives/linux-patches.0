Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065586;
	b=Nw/AINvvT2vymc8bo9iTDMIxEjsGitVDCgdOfik+HS/Ox2elKAlFRxOBCKBEu7Yv130x
	 oZLh/qSm/+9pBYi1TVAFW5F6mdU+N41RNE0ZLt+b2eKZ47d4p9dpyEELWKAY6CUJjsdij
	 1gMCMo1VE08oR2EFEdGCuSYpXc2R0lkFJBG6FDhcrs2bV4f+26BjdNSic+gqRowQTFKlW
	 sd5E6hfNBI3SVduJG3Dh1JFiHwclerUxnKTKvajadcQEVPo9bCv96eP4rePnSFI8UI8mI
	 kpJr46vMRYBrlLY1f1TxADOpWQdxi4/fJu8ijJwB/m0ayjwa0jyvUci3+xUVAboH8cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMHiGTqpiJnWl270B6kIjsX9cBJAvuQ1NbOVP4CgsGk=;
	b=DFZEZezJnH249+rmhSibZl7oPeZh26PlH9sggkgrF3T5lffWwnQC0gPJQh4Oxzg1OrkN
	 yjSC/ka5Z8h0/huuuz6nTBAX7PaLby9frpU08HB6c0HG3suy2xtJ834QRXXvnS0q3mJDs
	 vp88b/gge9VWH+L8YKnpq1vsWLsXdhEZJYe+zPz0YpGmj8luZhjfGOUNrzPd5doLf1ZX3
	 9j3BIcG/JuRrCz0YK/au9ZqJr/KLZh7A/GeyR+wU5jCOqUioRgNewdeunF6cW+fAohOJh
	 HNmTsIADDv65XXCvDKgJKv76MmQN9nCRWBNPZqe6yhEoIQf+B8I/OFNxxn6O4ZMSHbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfgDOIv3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7097A606A32C;
	Sat,  7 Nov 2026 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfgDOIv3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F03B1F0089F;
	Sat,  7 Nov 2026 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065586;
	bh=UMHiGTqpiJnWl270B6kIjsX9cBJAvuQ1NbOVP4CgsGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfgDOIv36GUf8oE6EoyQ1AqDukluQ9Qdl4hQ/5tGEPgcLesA2NSdNIfozynfhp3eh
	 o98th7W2XhC8D9RSHGugjcsf4eHzGjhaB0yWAqsAK4Pdd/gUapKBP3BhdEZ0dAIOEI
	 xoDPgf/bvj0zB1HirGygt7diZTKuaeEkHQYOgLUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1243/1257] apparmor: fix profile leak when a policy load fails
Date: Sat,  7 Nov 2026 08:58:59 -0500
Message-ID: <20261107135013.661256695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit ce94927fa4173fcc1eca27bdc65a140064c8f1e6 ]

The error paths of aa_replace_profiles() and aa_unpack() do not break
the refcount cycle between label and proxy. They just aa_put_profile()
the new profiles, which drops the label refcount from 2 to 1, and the
proxy keeps the profile alive. Every failed atomic policy load
(e.g. "profile can not be replaced", or a later profile in the blob
failing to unpack) leaks every new profile in the set, along with its
proxy, rules and its loaddata reference.

The leak is usually not visible from userspace, because the raw_data
directory for a failed load is not created, but it becomes visible
when the blob is deduplicated onto an existing loaddata, which then
keeps its policy/raw_data/<rev> directory forever.

Add aa_put_unpublished_profile(), which drops the profile's own proxy
before putting the profile, and use it on those error paths. The
proxy of an unpacked profile is always freshly allocated and not
referenced by anything else before the profile is published, so
putting it is safe.

Fixes: 637f688dc3dc ("apparmor: switch from profiles to using labels on contexts")
Cc: stable@vger.kernel.org
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/policy.h | 20 ++++++++++++++++++++
 security/apparmor/policy.c         |  3 +++
 security/apparmor/policy_unpack.c  |  4 +++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 0dcbf8cf1029a..bb851654cb80f 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -436,6 +436,26 @@ static inline void aa_put_profile(struct aa_profile *p)
 		kref_put(&p->label.count.count, aa_label_kref);
 }
 
+/**
+ * aa_put_unpublished_profile - put a profile that was never made visible
+ * @p: profile  (MAYBE NULL)
+ *
+ * A newly allocated profile and its proxy reference each other
+ * (proxy->label holds a label refcount). That cycle is normally broken
+ * when the profile is replaced or removed, which redirects the proxy.
+ * A profile that is discarded before being added to the policy tree
+ * never goes through either path, so break the cycle here, otherwise
+ * the profile, its proxy and its rawdata are leaked.
+ */
+static inline void aa_put_unpublished_profile(struct aa_profile *p)
+{
+	if (p && p->label.proxy) {
+		aa_put_proxy(p->label.proxy);
+		p->label.proxy = NULL;
+	}
+	aa_put_profile(p);
+}
+
 static inline int AUDIT_MODE(const struct aa_profile *profile)
 {
 	if (aa_g_audit != AUDIT_NORMAL)
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index f6f7cdcb62126..8f23f99d2a58f 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1460,6 +1460,9 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	}
 	list_for_each_entry_safe(ent, tmp, &lh, list) {
 		list_del_init(&ent->list);
+		/* new was never added to the policy tree */
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 1ea89e9c53fff..99dd61e3b1038 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1816,13 +1816,15 @@ int aa_unpack(struct aa_loaddata *udata, struct list_head *lh,
 
 fail_profile:
 	kfree(ns_name);
-	aa_put_profile(profile);
+	aa_put_unpublished_profile(profile);
 
 fail:
 	if (compressed_data)
 		kvfree(compressed_data);
 	list_for_each_entry_safe(ent, tmp, lh, list) {
 		list_del_init(&ent->list);
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
-- 
2.53.0



