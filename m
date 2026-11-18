Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059816;
	b=B/m9HHSl2JQr2z9jRWxXUEHpaWFGTp/p3XTHtLmnIYNfjmHcloHHLIz5Qy2U2qRBmtSp
	 Mn+BqLe6xmqhM0e6I3YKLnh9vbY2i84/dnfyCtQgzP3aD4FDtdD/et50fSSLBAGxFacu7
	 mXALsAVnO66ds+SWpPviKIR0z3VzjwKhcT4L0WS346CHAA/GIDYS3VrIU5/1fYECteMPn
	 5VrLw3Al2E0l5r9lFlg4onA0j0PyCE6vjsj4Tx+4dIirbHlkp/q4pRVF2HDCTeXCOraiv
	 TS5LVdvoAjj1sSnq5Ds9njbh/eBpFUDifCJmtu3Yfg99jNnniO58WIyAkswIFygRLdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0H/aXjtUJ76NYv3jyggJmT1S0Kc/yOFuRIcEPE15cY=;
	b=QGfZzbXjb/hoTH5U8dt3k05VoQj78PIVpEGKQiwc+30LS8WN4KRnXqrLWt0hFbP1M99W
	 H9GwpSj/D68Yel1AiSvGRfhTaavZX4OXt+4f+oL/frzPFfS1Ars0Q5vJ6Eq9/rXwwFOCt
	 houKZwIHwSEL78VtMWGSc9fGNaDhcPCFUsehy5M7EcQvHZqSbHKlEemjGI3JWZMJsGTqW
	 dLTU8/hH1i/VEkfc51eNKjfvvEYOGYSIX3sTTpf1duHwRx/BjO89amw5NkHtF/XVylL0J
	 /ea+hvtuymRcRTFbqGtbD5utDnY82rfzIwwSpAMfZYeXW6DhKCYfCuBSy5oVYaT9N8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4yaSK8Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817C7606A320;
	Thu, 19 Nov 2026 03:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4yaSK8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B0A1F000C4;
	Thu, 19 Nov 2026 03:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059816;
	bh=x0H/aXjtUJ76NYv3jyggJmT1S0Kc/yOFuRIcEPE15cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4yaSK8Zbep7S9MknnJy7smzgv6KXkS7eigvptBXSWVTEIxmde8pJqmsqMIoBuFRp
	 g4E6WWWxhhICLAQenZcp6tOXOl4rJDv4dsNiKFT2uhPv9RVzRcHs3U/kbIvU/FWren
	 FSMj4LhGuQnQtROqL3w7IG/8p1ADibLb5Lp/a2IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0936/1848] apparmor: fix refcount leak in aa_get_newest_profile()
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118145956.027641754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context around labels_profile() for differences in surrounding macros and declarations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/label.h | 6 +++++-
 security/apparmor/label.c         | 1 -
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/include/label.h b/security/apparmor/include/label.h
index a987bd117d88d..e7e0f3e0435fc 100644
--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -148,7 +148,11 @@ do {							\
 #define __label_make_stale(X) ((X)->flags |= FLAG_STALE)
 #define labels_ns(X) (vec_ns(&((X)->vec[0]), (X)->size))
 #define labels_set(X) (&labels_ns(X)->labels)
-#define labels_profile(X) ((X)->vec[(X)->size - 1])
+
+static inline struct aa_profile *labels_profile(const struct aa_label *label)
+{
+	return label->vec[label->size - 1];
+}
 
 
 int aa_label_next_confined(struct aa_label *l, int i);
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index c675a11d8a551..f14802e2c2264 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -377,7 +377,6 @@ void aa_label_kref(struct kref *kref)
 		label_free_switch(label);
 		return;
 	}
-	/* TODO: update labels_profile macro so it works here */
 	AA_BUG(label_isprofile(label) &&
 	       on_list_rcu(&label->vec[0]->base.profiles));
 	AA_BUG(label_isprofile(label) &&
-- 
2.53.0



