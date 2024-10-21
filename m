Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A381E571E;
	Mon, 21 Oct 2024 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507760; cv=none; b=EXVFDEukkP44U3kcmSaNgeq/LThjRhveTQMraa6WAwpKwsvvuvuPwBomtWAV7C1JgQy4Q+YZoq13zu0VwSE7fqZx3fV+leg0o3Ac9dshoTaZWxccHE/zONx2HzUoOcdIdCnwFI+yFsuovhK6y+Aie4dE4Hvc8wMpULiuNg91fNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507760; c=relaxed/simple;
	bh=GaH8gdxDxvlInyLWwNn9WL9eFXRWmUfp4IbW4IbAG0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RroKZ9IOX2PlMNKqypu401jMX1uUBS2asZzdj6IBAHneyHYPUFYkNtLztRX8A7q2EaZbkLraYFH5xBJJMRn/IGzbsRturXBY9E/3KYpo71QYG/aQKUrxNnuBKSWqyQ5p/HFWidYwrb5OKVDT5/jjtGuoFe4ldg5ZImUPC5r8lp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEZymAjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEZymAjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4077C4CEC3;
	Mon, 21 Oct 2024 10:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507760;
	bh=GaH8gdxDxvlInyLWwNn9WL9eFXRWmUfp4IbW4IbAG0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEZymAjyAENDh5iYrHMVLwRB39rUNwQPYRDykTKCF8LugZcfa6BdpTiV9vk5wDnGB
	 gH+puFooiythVbPty28kGFyYTL+oRYBrmwlhph/7Kx7IeB3ESKNscZBTxIL9ImbwwP
	 McGgr25qKuSoybCjnzkkAoZay6i3h6WQxoUkzFIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.10 10/52] wifi: mac80211: fix potential key use-after-free
Date: Mon, 21 Oct 2024 12:25:31 +0200
Message-ID: <20241021102242.030800433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,6 +509,9 @@ static int ieee80211_add_key(struct wiph
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
 


