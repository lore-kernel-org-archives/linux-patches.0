Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065575;
	b=O5WEkRCQJ61yFI/yl80SYqOvc4X2jlUQKmY26/t2sTt0KGkRwFNLjA7XympPxv4uivXB
	 +yOsGDiuURGb0GByKn5RXET1yGGjV5aC6gzdQ7fkdTEOZNy/BwaKN65VUKxWuhDFUisff
	 R0/m9UkS4ZFOx8W90Ld+oBY8xD+2Hxggs5PCDz/TaIjCAhzD5QY/qPVHkzUluA4sWGn1p
	 ZCLoeBmrViV2eMR2MamwerEE4A0SFEd+BB8zwbXdIJjk+kOp7+eUOqBzmhoh60d6YfsHD
	 ovh7mYlfD5xPtsat9aRd0qNGtMLAL+8rnd1bzcUybGxV8g1m9Or1EOu4SoyRnjdzjRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTklK5f/yiFUX04cJqTGo9qupwdselhz4DXyPEwybJA=;
	b=eHCTB33ZBlcF469MeaZHxP4EA4X0+sVKJrgTvlBwdRSse6wA5RSAizVMiCf/iroPXlsl
	 zU1OTnCTKrXyt/hLZrznomJTecC0B5HHaS2rdFFneGiyRROqZqCIYuzFNzkdMh0yYLbTJ
	 flVoqUMVuaUicgX+Y72dRmOWtQz5Cf8cIJRFg7kd4MOiN/NkQqcJkR5fz63GAAjQGKKt4
	 DTFZeOtDHRm3wv7F42hNqHU9uIMA9it3pxeyYIZiwo58eZf0HPq4MarEgMGRoq0omspU2
	 PojpnUgapr/WAWuauYBjXeqTls/gsUfO9LFrucQTsabMleeinrfSh9xUm60J5xtCTZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCCOaTsh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A4606A32C;
	Sat,  7 Nov 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCCOaTsh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31401F0089F;
	Sat,  7 Nov 2026 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065575;
	bh=PTklK5f/yiFUX04cJqTGo9qupwdselhz4DXyPEwybJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCCOaTshq5HQCVDP2VY4K/iEC75zJv5tu29v5sGHYFwQ2y3v3Qm27NEotSMnTGflk
	 daINEhhQYxLgl4xhYeTMsv8nigp9oox0D9uZRkgBsuAHwEZ3OiQK3SzjadrmRzinlJ
	 EIyPkkTMvGs6aKYy9Nx8BEqyQrsykM4c3JeW4yg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1236/1257] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Sat,  7 Nov 2026 08:58:52 -0500
Message-ID: <20261107135013.476607640@linuxfoundation.org>
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
index 2c869b7dec973..61794b9cd6be6 100644
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
 
 
 int aa_label_next_confined(const struct aa_label *l, int i);
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 82742a4710552..42ed476fe89d9 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -387,7 +387,6 @@ void aa_label_kref(struct kref *kref)
 		label_free_switch(label);
 		return;
 	}
-	/* TODO: update labels_profile macro so it works here */
 	AA_BUG(label_isprofile(label) &&
 	       on_list_rcu(&label->vec[0]->base.profiles));
 	AA_BUG(label_isprofile(label) &&
-- 
2.53.0



