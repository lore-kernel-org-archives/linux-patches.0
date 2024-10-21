Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1D91E9081;
	Mon, 21 Oct 2024 10:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507580; cv=none; b=VI5SHR+SbxmFz6zRz6xTktn2KDGY7TVb+qOn41tqpm+I9EDyQpiLZwxj3oEHnnMkst0CHxrWlNXYsIv3E+a/BAO+oahah72Jozy396OWtFkBsJKdrNTRCVoomU3rLz3yB7/PKuTaiiBAoUDa63+R3R2Ihrg9MsJJIMespJ9QEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507580; c=relaxed/simple;
	bh=H7DoioIL9Kc8dXU5TPeIy6ZLJsdxKnRVOTKvDfykPYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcA8u9+0h87Fojvd/QMs1k2sGorji7wXixa7/pqbPHqUiom1fHc+UmM5F5VOgjJv2+r8dvBToYSrxFDlEGkPT+6nfZEn8q659puqoMv3MbXdbufAIOrZffZwu5RDexApUnnLQzqImZhYkvamLZ8c0beaKm2M22EiFpj1XHGmgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0fPHSNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0fPHSNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D58C4CEC7;
	Mon, 21 Oct 2024 10:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507579;
	bh=H7DoioIL9Kc8dXU5TPeIy6ZLJsdxKnRVOTKvDfykPYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0fPHSNGgAQFvnHrqzIT0lOZN6D7J1j85ws20UVZ/p5VjASHC0KoBP5ykdiwR0dNH
	 l46wNd2EoW10TRQQQ1toARdNbw2p4YfOJxDy4RQE2o9lDQEsyYBKvqis7lGJr6+7AJ
	 DZS9oQ5lDPI3/Ssg23UU2LJsfTQ8UtVK+Os38nZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.15 32/82] wifi: mac80211: fix potential key use-after-free
Date: Mon, 21 Oct 2024 12:25:13 +0200
Message-ID: <20241021102248.515694729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 31db78a4923ef5e2008f2eed321811ca79e7f71b upstream.

When ieee80211_key_link() is called by ieee80211_gtk_rekey_add()
but returns 0 due to KRACK protection (identical key reinstall),
ieee80211_gtk_rekey_add() will still return a pointer into the
key, in a potential use-after-free. This normally doesn't happen
since it's only called by iwlwifi in case of WoWLAN rekey offload
which has its own KRACK protection, but still better to fix, do
that by returning an error code and converting that to success on
the cfg80211 boundary only, leaving the error for bad callers of
ieee80211_gtk_rekey_add().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: fdf7cb4185b6 ("mac80211: accept key reinstall without changing anything")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Sherry: bp to fix CVE-2023-52530, resolved minor conflicts in
  net/mac80211/cfg.c because of context change due to missing commit
  23a5f0af6ff4 ("wifi: mac80211: remove cipher scheme support")
  ccdde7c74ffd ("wifi: mac80211: properly implement MLO key handling")]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 +++
 net/mac80211/key.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -511,6 +511,9 @@ static int ieee80211_add_key(struct wiph
 		sta->cipher_scheme = cs;
 
 	err = ieee80211_key_link(key, sdata, sta);
+	/* KRACK protection, shouldn't happen but just silently accept key */
+	if (err == -EALREADY)
+		err = 0;
 
  out_unlock:
 	mutex_unlock(&local->sta_mtx);
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -843,7 +843,7 @@ int ieee80211_key_link(struct ieee80211_
 	 */
 	if (ieee80211_key_identical(sdata, old_key, key)) {
 		ieee80211_key_free_unused(key);
-		ret = 0;
+		ret = -EALREADY;
 		goto out;
 	}
 


