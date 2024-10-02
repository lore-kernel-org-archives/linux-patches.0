Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F45C29CE7;
	Wed,  2 Oct 2024 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877224; cv=none; b=MK4RJUHnIvNlAAUpQy8vaGPHxIpl4b2ZgjPdveZztuJuIx5INolY7UiZUyyFoew8FiTZ7YUqbneApiBZMlVKvY88NZ404qsmhefS4vYcYBACkeitx73hxwp4VJuMVZD+/eAkm0/BqU+bQ5Rjpj3k2Mo9fiYBE7rK7cfLqakBLFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877224; c=relaxed/simple;
	bh=tywfhx3bppqJq3tyc2VusZhYmnGMoziwmf5Y+AgDoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5HIwwRRcgzGHVKD8pfcK/sgQLlEGpKp6dRtZGzApAdwqpSAPHF6DjgLOiqAXhTDA3tKk5bha44AVy38l3BDKJNikzhIbVnFTs69jtlRGtvqOcDgP40E0qJ1G1kNNTXOtgnlPiex/205Pqdk6rWDkpdxBgAbzMWN+zK3bE5LeKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LArfEecf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LArfEecf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD99CC4CEC2;
	Wed,  2 Oct 2024 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877224;
	bh=tywfhx3bppqJq3tyc2VusZhYmnGMoziwmf5Y+AgDoDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LArfEecfk+I3M2CPkYTeizYLGPgFuxlQZptou0xBaEkoxUU5A+IsJcTdLUvxEMlqO
	 sw3aNtCao9hO5HRSLYiRlJ8ZbhFAkVPAn/zv/GDcXRY8OkldP41PlJPmJiAiab/0t9
	 kwk3pUuOL0VKgm7NSD713Bkomnz6grIi9vY4WQgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tobias <dan.g.tob@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/634] wifi: ath9k: Remove error checks when creating debugfs entries
Date: Wed,  2 Oct 2024 14:51:51 +0200
Message-ID: <20241002125811.538230681@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit f6ffe7f0184792c2f99aca6ae5b916683973d7d3 ]

We should not be checking the return values from debugfs creation at all: the
debugfs functions are designed to handle errors of previously called functions
and just transparently abort the creation of debugfs entries when debugfs is
disabled. If we check the return value and abort driver initialisation, we break
the driver if debugfs is disabled (such as when booting with debugfs=off).

Earlier versions of ath9k accidentally did the right thing by checking the
return value, but only for NULL, not for IS_ERR(). This was "fixed" by the two
commits referenced below, breaking ath9k with debugfs=off starting from the 6.6
kernel (as reported in the Bugzilla linked below).

Restore functionality by just getting rid of the return value check entirely.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219122
Fixes: 1e4134610d93 ("wifi: ath9k: use IS_ERR() with debugfs_create_dir()")
Fixes: 6edb4ba6fb5b ("wifi: ath9k: fix parameter check in ath9k_init_debug()")
Reported-by: Daniel Tobias <dan.g.tob@gmail.com>
Tested-by: Daniel Tobias <dan.g.tob@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240805110225.19690-1-toke@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/debug.c         | 2 --
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d84e3ee7b5d90..bf3da631c69fd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1380,8 +1380,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
 						   sc->hw->wiphy->debugfsdir);
-	if (IS_ERR(sc->debug.debugfs_phy))
-		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
 	debugfs_create_file("debug", 0600, sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index f7c6d9bc93119..9437d69877cc5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -486,8 +486,6 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 
 	priv->debug.debugfs_phy = debugfs_create_dir(KBUILD_MODNAME,
 					     priv->hw->wiphy->debugfsdir);
-	if (IS_ERR(priv->debug.debugfs_phy))
-		return -ENOMEM;
 
 	ath9k_cmn_spectral_init_debug(&priv->spec_priv, priv->debug.debugfs_phy);
 
-- 
2.43.0



