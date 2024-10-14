Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3791ABEDC;
	Mon, 14 Oct 2024 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917394; cv=none; b=gNVyIPKjdMlEKK6WGgdUMtFSQZJUKKBaBwcKBmVavNMWKqCI4a3TkPWkJNDlbZu7AeQlpCjWm8MeLZlViz6CzBk6c3JXuTijk46TKwWI2wk4eUHSMlp9fDr/n4xAYmK0+Z9GYRYaSOubeWPxDhmnJuRnTZrsl79r18x/5gIFjbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917394; c=relaxed/simple;
	bh=l9npX4oWZzoQN679/kLV2OqUxx5w2Rz6z0RUg3n0zio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fY0R5V/Kw9F0QVGdsEEFRGSoaKafNjbbOW9mfuODEc+Gf/55L8w6jwIog4z5qYCjssH/IE6WsuJkWA7T62X0oEMINaezynl7wSfdaJ1isc5X8ei99Cg8gEpM50474Viak2AH8z2GmqHq4RDFOeWogAop1hfd7I8oCskIj6ZElQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf0wwtfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf0wwtfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9489EC4CEC7;
	Mon, 14 Oct 2024 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917394;
	bh=l9npX4oWZzoQN679/kLV2OqUxx5w2Rz6z0RUg3n0zio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf0wwtfRPK0Ij76TADUFAoYaCT/DHI8rKeUEAkwy/tz6lGFw3DVa8F941P5Y4PTgv
	 PORTvmDaqzhGcKPJ9/APH+ICRL3L8e3sE52RgbRbybQ2XCkzN1TL8D7nzG4i3tAHhv
	 w5kBhkpcy5XSOrTHNqCMfhGM7dgZUFp/+uP/0Fho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tobias <dan.g.tob@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/798] wifi: ath9k: Remove error checks when creating debugfs entries
Date: Mon, 14 Oct 2024 16:09:21 +0200
Message-ID: <20241014141218.239831204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 72660a66be1df..9955b9c4df2b4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1420,8 +1420,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 
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



