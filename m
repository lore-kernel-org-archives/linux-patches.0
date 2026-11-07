Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063791;
	b=iewFCdNqxbASkfCbTJZ40YPR0QshcWcGU3PToE29tQYnzLzMWcxpTLqwC5pr3+opkYA9
	 3kYUvZczCd6tsEk8OBnYzsIwX50icThIqCfKx9hrSm6wAh8eeVU55wXQYTHQsQO/Ovhig
	 X5wP0sgkuMW+REOW08qa4OTMp7dWf4Fgl4UiQzKpPGRZgapaM6pshaCDO80nkX64EOpuR
	 6NsUAf4R6s+tFPbZpqoufVPkuRKzGYZuXDYjz+38OsBVxzRvk9N1DQQbSSTncSvAzxDOj
	 /SoSedV9kyBdQNqbafhPkh3Bm1yY06NeShQ+NY83wZBg8ZXdcqoi53FMRheuwA82nnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jcmJwjBXPNHN7c7z/WgvLcXNYPyCz3cT2PMLQDy5ChU=;
	b=2iA9IFisvIdckXUbK8cwEPRhTYX+CM66OsrgQpNP7UhR5vgb2nG5B2C9pZb/9XlmaW13
	 I2G/pTeg5tJaKgc/B/DIv6QyfM3xRVM/gH8nACAZr873rthzUCr5BHuPeb52EXaZScAbQ
	 XCCVs+e4bkoFor/jQkrdnuzYpdn9SioqGHt9P3r8ZJePoR+Vza0POS973PbsnDaMX7Dti
	 1R+KAMwZ+K52FNyXZ2i0ogM4qnuFVGgfB1PqLuCsogWW2P5h52hQ8aeO9y17szUYTqgi6
	 Ck/vkHwMhbAXs9LJWrSoV59wkoBSwd4zvpznjgdek2FANkIyWhpuMkLRGD9ORhztaeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrKEG8gP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA6360A3824;
	Sat,  7 Nov 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrKEG8gP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8ED1F0089F;
	Sat,  7 Nov 2026 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063791;
	bh=jcmJwjBXPNHN7c7z/WgvLcXNYPyCz3cT2PMLQDy5ChU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrKEG8gP/0rszS2YLvm0z+wY8r8SLdKKwHT22wKU1YkQcEtxB1Em4PC1ZusMuGZHB
	 6hMAyzuRnRzYS+qnFdhQwfEqXBq6WaczFScGRczpABPtHTktr2Ds05zS+g0SjsxnoN
	 RD3/0ZD8aU9hUE/a4MMhprAiftTEecwi1RWCRlQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 853/869] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Sat,  7 Nov 2026 08:58:55 -0500
Message-ID: <20261107134921.702376118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 33ed50716251d5b2875706c40d0c8082d46be0b1 ]

The labels_profile() macro is evaluating its argument twice

  #define labels_profile(X) ((X)->vec[(X)->size - 1])

unfortunately aa_get_newest_profile() passes
   aa_get_newest_label(&p->label)
so every call to aa_get_newest_profile results in 2 refcounts
being taken with one being leaked.

There is no need for labels_profile() to be a macro. Convert it to
an inline fn, which ensures all uses are passing the correct struct
and removes the double evaluation.

Fixes: 637f688dc3dc ("apparmor: switch from profiles to using labels on contexts")
Cc: stable@vger.kernel.org
Reported-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/label.h | 6 +++++-
 security/apparmor/label.c         | 1 -
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/include/label.h b/security/apparmor/include/label.h
index 574be681f83e9..75c49e713a749 100644
--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -162,7 +162,11 @@ do {							\
 #define labels_ns(X) (vec_ns(&((X)->vec[0]), (X)->size))
 #define labels_set(X) (&labels_ns(X)->labels)
 #define labels_view(X) labels_ns(X)
-#define labels_profile(X) ((X)->vec[(X)->size - 1])
+
+static inline struct aa_profile *labels_profile(const struct aa_label *label)
+{
+	return label->vec[label->size - 1];
+}
 
 
 int aa_label_next_confined(struct aa_label *l, int i);
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 5c42cd01ea473..667f20363ebf1 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -386,7 +386,6 @@ void aa_label_kref(struct kref *kref)
 		label_free_switch(label);
 		return;
 	}
-	/* TODO: update labels_profile macro so it works here */
 	AA_BUG(label_isprofile(label) &&
 	       on_list_rcu(&label->vec[0]->base.profiles));
 	AA_BUG(label_isprofile(label) &&
-- 
2.53.0



