Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037085;
	b=AFjtyruGBGfD2txtkFxFUAY0ne9b+dC/s5ouCR5LGd1R5/6w2f8SoRj6Vj37VNzplOk0
	 gWNiW3UGh6w035BarWwH1VIr8K/VmNz+kSuY+xarEwQJU2x7RZHRuXw1UC85MSDgAVZjy
	 Qz+FS2t/WwDp7ZizGg+sG39pIcikZl/6J4rSmR4xkWrNftn2etH8T3GI1MP1uAzuH8o7S
	 dU1jxbVCXwVjAQEmF77EBhB+TBo/a0PF/idUtzJQO59ehhZBKEyCsXuPLaUoQTBugpInf
	 c0x9pYBT/Kto7whCokcUxVVATNmRUFSp3ct1/XqGRMHO9qHXrxrQCukPTW95UAjihcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rwjGNHhbL4XribA0wr+mq1ZnW7zXL3Cj5c+tLX+fjGM=;
	b=LQLruZnRrEPz3NQBAuL+BdVr5I2WTdB9oM2RR8vvqPeU+3DawfyCt05Pkj6zjrBR4Uyu
	 E6mF60xBxjWm1F/m6hvbnm8g5jJstl88lOUaJK4rEEDMFAO7vm6Kc55CuQKosVdwyRKcR
	 ZCXBqTA1vbuCsUQKnf+UYyO7TuuoXJCXNcxqoux+j4Zsh22SzxaCcwh9TCVgweHkVkQ7I
	 pUbGcG3EJySBrv5X3PR8aPnfU9CaFRHHklkWA8r2TndGp7p2pleG8jz8ojwmq6A+tt3UI
	 fs2szGoNn3zK8pCSOApm76AxJ/nVJxfGUgyo/YxdWRkrZhFXRG99KY9igApMk/dEQeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATCtMCYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F51606A325;
	Wed, 18 Nov 2026 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATCtMCYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C3D1F000C4;
	Wed, 18 Nov 2026 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037085;
	bh=rwjGNHhbL4XribA0wr+mq1ZnW7zXL3Cj5c+tLX+fjGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATCtMCYXBL/Bz5tlib3N2tJWgYyQvU+mzS2osRu/pyqg8j27Dcm94x4xRwQvDJ0Gx
	 pmwoE5N0s3I62dh4+fasLFCVL07SujMcOJpYeFYQ5VMlES3FEZLTje7dG6yxo+oTyT
	 bhngl2MXLAr2cVqWXCYkTwGTMyZIE3KF0MW/ZNfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1286/3318] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Wed, 18 Nov 2026 15:31:48 +0100
Message-ID: <20261118150358.839060450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 55b5372ecf240..9881c6ea6e320 100644
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
index 37282a3c68a72..3d3c55906bf9a 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -380,7 +380,6 @@ void aa_label_kref(struct kref *kref)
 		label_free_switch(label);
 		return;
 	}
-	/* TODO: update labels_profile macro so it works here */
 	AA_BUG(label_isprofile(label) &&
 	       on_list_rcu(&label->vec[0]->base.profiles));
 	AA_BUG(label_isprofile(label) &&
-- 
2.53.0



