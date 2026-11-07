Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062685;
	b=FvxnAQiH8rGVvXbvmnENT3oNjzlsVbiFLWQYiRPGqT92HZAuhQWBJ6dQXY8FwK6UKRLO
	 GTJjOJ4IH5oaZ8Hm3CDfmolbecE9M1KALRbbcDVHQIQLUc/RZ3atc8anZFevtfG5S6vzr
	 7HE1D8cTyZtwIt+SEGpCjGdtBPV8Vn/PuqrO8Oy+rJSOlxhulY1+s8Cs3H6d/j0McYVKc
	 BzmPtmoWdC645aXvi0HW5Q87RYWRR+byMS1aBB4DBZeM8wXUbAuWaOqEOxZ11Ec+Qwt3L
	 nNM18m/5CW8q6lWp9+fVLrBp4GAco8v5ZH0VDtwqbxjfaeu0IVRpkvGGCsZGY+6y45w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEr8RK69ILcIis3U5wsNEIyVXQrX3jyd9fW83yfJsfc=;
	b=YWx6LHQy9RaaX6eOhRMBCU1e0P+SlqTSInjAaGwerv9V+Uj6PEmw5SaUeeRqN/b9mRqk
	 hSJp514sfoVtcfflr1aczAs0NFXnmeMqMr3n4QsB4YjUya1CfUt+lY4nh7UiGbK0pDSNn
	 kxMjO+2Vry/CKESoisF9AKpJUQYohkfrnjSU95C5+/ZaB5E5w0h5cK5yWwlvIqedOSwYV
	 bcr79+lOMHN3cFEIgJbIbiKeADved4EsNDMHAv0SveLnX5/yoYM78jEFqGzCbcApPkajK
	 RN+GzZS0LV1l9957ON88bYoXkhyQpcwtqO6HQjnd1yso+4W+E+h8+LB0/WQB1y4fO4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b8wmMq/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C67606A330;
	Sat,  7 Nov 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8wmMq/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A861F0089F;
	Sat,  7 Nov 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062685;
	bh=dEr8RK69ILcIis3U5wsNEIyVXQrX3jyd9fW83yfJsfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8wmMq/fCYUw2l0TxrgPkgxeP1+81OBcadea7TpjchZ42nAWf79lWzwaSnv043JHT
	 KPysL7YQyBVg9baQIYUgxj5IzF4HevQOeus7eIsGsqfpeEEtPJL2iambOgsC25mPEZ
	 XnmNbnyqTv7TQP6cB0ouN7NJD8maGvVgd2WJUIkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1524/1536] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Sat,  7 Nov 2026 08:59:00 -0500
Message-ID: <20261107135040.683230981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca505d4c3a10..a687be022ad17 100644
--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -147,7 +147,11 @@ do {							\
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
index 04fe4d16952d1..6508f13e9544f 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -382,7 +382,6 @@ void aa_label_kref(struct kref *kref)
 		label_free_switch(label);
 		return;
 	}
-	/* TODO: update labels_profile macro so it works here */
 	AA_BUG(label_isprofile(label) &&
 	       on_list_rcu(&label->vec[0]->base.profiles));
 	AA_BUG(label_isprofile(label) &&
-- 
2.53.0



