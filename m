Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045915;
	b=oXGFL2ohldhWD1TNgPqwuGe2LOmJgj0SADE0yJzmiTPKS3+FlsEAi4uEoqrmTAq15dt3
	 NPKRvawdgGdFXa86wrnXqmrZrEkepX7A8Qo/AJZKGq/Bdk2a2K7x27+wsebZTQBVUPHZA
	 EV2F4f0zuqbPW6gASSIjOtD3ZHYlbBCUmTVM7OOlyCcLPlMv4DgUXTeJiSWL425sygYcG
	 gaVR0DhpyLLAjsjoNFTV3rc/2RhoM8ZfQioA8I8X+A5R1/1zm0Kqb79SzoUNxNVBSNP2G
	 BDinhjFCZXgkKJWv5lKGZIDFkfL87DwXaiGzEKUwZZRjDrXyAJOQ90SEqbIFKmrh+Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5hwmTu5/ofe1KfTQdbTW1r4X85GMbwFvqsKRZ86bbGo=;
	b=2UqkXzByEQw7MR4OeqIvReHPCEAXVNYtqiAYOzgdOcjNyfA5II2pnnvbRzNgVnqI6nRl
	 ZrhNdT4zco0CNZ1kOZH06lFbd1K+LL9uySb2Mjqw2RnnCVM/uppT1V2dGddcqCAyObUsm
	 iHuEVxgh8+Rwg6g2cTwWOkf0Nvf9r5xTClFcHffH7uhdw2z1NaXPX2lwh1Pny4KvlJtNP
	 HJIlF/f/v/DXLefA1/1mcmHNRFY/Zjs+1t4L9tCQUwEhE8DgDfJwdPy8tteUjt4udKPdL
	 cfM+Pv9y+oFB36VRikEhYVJPsUzEHD4Z6LpWy8uG2ygdKtlKQD7FUtMzLpJQ+ChY29w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxLnkv5u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664A6606A31C;
	Wed, 18 Nov 2026 23:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxLnkv5u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7654C1F000C4;
	Wed, 18 Nov 2026 23:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045915;
	bh=5hwmTu5/ofe1KfTQdbTW1r4X85GMbwFvqsKRZ86bbGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxLnkv5uuHIhx7bHK68krNyzPRmvi0NqisVKUO3Ho49Xbh2afilOKVOynCaL/C8Cc
	 0xthbIAkYx6O1nLPyKOjSlOT+RIMlyuhap9xcoLYpsLJAn02ALvhWZ51AzrbHbF4oi
	 dyVUG6WTM1hEzbxUBU5efJGVlsW2Y7ZxfkxW0qmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1094/2857] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118150241.013388828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 43565faae2ba5..6429a4e3db2c3 100644
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
index dc12488b5b3da..74b4fd651c423 100644
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



