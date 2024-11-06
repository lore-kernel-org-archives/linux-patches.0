Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06C1D2784;
	Wed,  6 Nov 2024 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894880; cv=none; b=rK1NlkBQ/SIcx33qXrXw/u8J/C9JlTN6JH5/bA45JkLm+s6HNdiUplNGd8YkAz/MehCm7NCghIK7TTOUgHGivLHNw5iZqKo2sICaBaEjUavsH1uDZQQZj4b+dPs1xeBupBnuRZz9aj7ckVSyHDjm6TH9SPPIERXWkKRHCqFS/q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894880; c=relaxed/simple;
	bh=wpn3cJfL+NKY4LvYIci+NVimYVDyW3rS4WyK3lrplIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7dcDdBHEGIqgBS2+lyrVo4Z6qvgSopYHTN9s0fOAh/LXzlJ/AhVczbq6dSMVKthgGGnt43/zNxJWwg6v2Jq6N5DEmegsxg3rkLAqCP9KuFk/Hpxz95k4FhKt/wYlSF0T2A+q0VW7p36eplE5bP5j5Db7X9IIywy4HTJmzWiNgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N76aPzCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N76aPzCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69714C4CED2;
	Wed,  6 Nov 2024 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894879;
	bh=wpn3cJfL+NKY4LvYIci+NVimYVDyW3rS4WyK3lrplIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N76aPzCQ41IdCdG9x44johhh5/YaXCGPvq0F/sjg4/wZ7oVy86CY9hulZGJVNf6mb
	 d3nqIJr8wUYSDA2Cpwt9tBNXsPVHHhz280Gz68VrWnXJtYxtxm1aTaRZEm8VQ6k+CK
	 KKNZYxSCZ0MNZK7byQqpO1ZDNdq4tN0dzAmb68sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tobias <dan.g.tob@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/350] wifi: ath9k: Remove error checks when creating debugfs entries
Date: Wed,  6 Nov 2024 12:59:18 +0100
Message-ID: <20241106120321.621996329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1700d23f0aa9e..9440d6bfea922 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1384,8 +1384,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
 						   sc->hw->wiphy->debugfsdir);
-	if (IS_ERR(sc->debug.debugfs_phy))
-		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
 	debugfs_create_file("debug", 0600, sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index e79bbcd3279af..81332086e2899 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -491,8 +491,6 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 
 	priv->debug.debugfs_phy = debugfs_create_dir(KBUILD_MODNAME,
 					     priv->hw->wiphy->debugfsdir);
-	if (IS_ERR(priv->debug.debugfs_phy))
-		return -ENOMEM;
 
 	ath9k_cmn_spectral_init_debug(&priv->spec_priv, priv->debug.debugfs_phy);
 
-- 
2.43.0



