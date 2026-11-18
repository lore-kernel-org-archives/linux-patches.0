Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022519;
	b=h2U8+GMrcDIe29p5NyhzvM9ZKZFXEETgzPPEUM2tPu1oD1snrT84YR+u159iA0ImLwA1
	 /8gN/0cZplySVomo1j3zZnymK26nXL3R0cUOnaW8gqFrE6RmR6iIo+y02dzMX9WIt2iVw
	 H1UiavARWkVbkV/PB3RaSfQk/o8umv7zPbbGf/5UVBWab93OoOsYhLKsIcMmjKK2uCPv3
	 VKZNks1ETjM+xAvMGmSqqxWc6eGvWhR8aVHubRltAd6sS+f4G01X3ZOArlj09m+aadEFR
	 Dtg3hwdVLwrhFkYPtFGFIoVsdlG+xWvj4sjcZqM+GLw0t1hCWgNz/oIixG1F4ks2hnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cylHTxcyzaXTV4D4nOjrXhxF15iurNs9B7/mRy5Tzj4=;
	b=HQ5iL4/yCeglHG4VYU8fmXvXPoKUhs01UPi2BrjdhqIkjjuDhIRy51m8ICliHhLUFOSf
	 kwWWcB7XMk+XVhVxY+/cgIujr9ze6zIJS3wgZuhzzRx/Cy2KLi4bXaQN/KFVwKhnOBujj
	 RTrgVdTsrU3ALTnGNhKXLIwBvWYT30UH7bo/itfquUI3k6NnPgWvgmVWMTS7h1oZ6/vQ7
	 Vba5sp2tlEuJhipxP1vWFIbeVb4l17iYwcoLgM18QWyBsxdNVwkQeXD+ZKMepkbrOzeC8
	 TZ1pC9tR1BiRR+H/2scl9APzOwJON5IohjvDAkr1QFPhbt1jLSu+7yuDt3bRy9gCKtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usdJHE5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFAF606A32F;
	Wed, 18 Nov 2026 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usdJHE5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306661F000CE;
	Wed, 18 Nov 2026 17:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022519;
	bh=cylHTxcyzaXTV4D4nOjrXhxF15iurNs9B7/mRy5Tzj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usdJHE5KJyPPyfTr6YJnIjqF6Mo6/E0CMOcx71/sClbsOqkvb62IfPMfy+EjkwAMO
	 31C7ClWwicRnlY3rK+DaMnsGiA84/zs6YBN8x0kV03U1mjqdG2JJzTtrlto7vP+8hO
	 Jd35zArMItMHSdiq0hFaTJKxEosEemH6vGxpbKNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0041/2151] apparmor: fix profile leak when a policy load fails
Date: Wed, 18 Nov 2026 15:29:36 +0100
Message-ID: <20261118150123.194772291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 69e6c93d2ff04..50dcf0147ae2b 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -408,6 +408,26 @@ static inline void aa_put_profile(struct aa_profile *p)
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
index 230d8428b4d31..e582df9327037 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1434,6 +1434,9 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	}
 	list_for_each_entry_safe(ent, tmp, &lh, list) {
 		list_del_init(&ent->list);
+		/* new was never added to the policy tree */
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 8dc2adedc7ae1..3e16612d2284e 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1556,11 +1556,13 @@ int aa_unpack(struct aa_loaddata *udata, struct list_head *lh,
 
 fail_profile:
 	kfree(ns_name);
-	aa_put_profile(profile);
+	aa_put_unpublished_profile(profile);
 
 fail:
 	list_for_each_entry_safe(ent, tmp, lh, list) {
 		list_del_init(&ent->list);
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
-- 
2.53.0



