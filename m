Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021231;
	b=c/nujfamxiadTkH6JoKC303ZVy9XroHWGdR+/j8VUiGUIeedmWSOknFnd3TUwUZhtZpT
	 dBTaEv2/3fEZSySWatZ8+jHN15hVjn7ykAAvXB4RKr+T/Ls6ieSnjvxwNFl2nsY1Fhtpu
	 deDRtnk5ywI8u/4frhw80g/ItrEzp/ovpM/Ip5Do9RT0vgfk7gT8sGZCOO/fslczUU259
	 dOZUze8sagm9UiXvW4JTyDzWZ1rLuc8coNuknmep1d8OlIVQ/x9NpxBprmC4hqvqkLYLc
	 Vgb/BbAs/+UyBWRv+bb0d533aoLIdg1brN0Q8COWA2//gkr98Cfla9FCaHbrYDxps5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJ4x6VSDBw56F0lqQ9I5ubZr9ZrE3Q3enBs2bkOCYqw=;
	b=VMiyCzYdRIFlYJcE7iwICnQMugYrSSsi6xJIUX8z2j5vU5Jo+1jwhjHZtPBgwOzsPkuv
	 KVvkvNJZa650hSCFgaWe7V5iANnKgVP8E1Ele3vFP5vhP1ZgUhn2TADkT0m/57eq7MLg8
	 qRFtOjKUcU3aQuaOgWiN5mAILy2Dk9pORWE2VnMpxbCsn1OZmCFe0eyjgJ0CD1E1onchY
	 a0YwMXj8oJCG/x3mhAox+GV659lrR57BPR4mZd3bscolzMzqLXEbLKi9F8LrjuCxkWX7o
	 WVdWfaACoDrUnIpLsDjjbPus8N0i269C3qpdMXpgl+4KOXQl98URg4ZDMao6WtfpUdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6P9YJkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48629606A320;
	Wed, 18 Nov 2026 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6P9YJkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BE1F000C4;
	Wed, 18 Nov 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021230;
	bh=uJ4x6VSDBw56F0lqQ9I5ubZr9ZrE3Q3enBs2bkOCYqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6P9YJkn9fMjxI0uL0NRkgrhCBMOQvivFUkvjZ5bZUy2xs0GwRXsbowu0mooz68nY
	 L7YuzHF+LTEUU2KTpHcpVLePkxvBKdz5ousePftCbzeIQ5iXcwsKMOfsRnK4/uqaqD
	 j4wCQsp0fOPuDrf0U0UObAAQ+zbP09VcQPAn0GcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2192/2651] ipe: fix enforcement audit
Date: Wed, 18 Nov 2026 15:57:12 +0100
Message-ID: <20261118150404.663677000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Fan Wu <wufan@kernel.org>

[ Upstream commit 0e5f66bf052223aa5c8caeb8554a7577b54c302f ]

ipe_audit_enforce() starts an audit buffer but writes the state change
with audit_log(), which logs its own record. Ending the unused buffer
then emits an extra empty AUDIT_MAC_STATUS record.

Remove the unused buffer and log the state change with audit_log()
alone.

Fixes: a68916eaedcd ("ipe: add permissive toggle")
Assisted-by: LLM
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/ipe/audit.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 93fb59fbddd60..a299bb35e0d19 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -262,18 +262,10 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
  */
 void ipe_audit_enforce(bool new_enforce, bool old_enforce)
 {
-	struct audit_buffer *ab;
-
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
-	if (!ab)
-		return;
-
 	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS,
 		  "enforcing=%d old_enforcing=%d auid=%u ses=%u"
 		  " enabled=1 old-enabled=1 lsm=ipe res=1",
 		  new_enforce, old_enforce,
 		  from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		  audit_get_sessionid(current));
-
-	audit_log_end(ab);
 }
-- 
2.53.0



