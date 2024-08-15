Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04A614AD0A;
	Thu, 15 Aug 2024 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731453; cv=none; b=q/foNchiHerH7SOTrt2U3NGd+m78OVypcpkz9phETxwPXg0ahm7iW/rCJqG0U9a7lzSX/5o1fD3mxQSjZK/VBRacY+/kavBlGL8Yz6pocLIpoXT8wKhrv4U0kourJjTvezFHbVn/l/Znm63y5qZeYtgDf11avAvHjtqIqpDLNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731453; c=relaxed/simple;
	bh=taU6sVxxrQi5OoV6tVHb2T/YfEZLKwvWJOeuaF3wzMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+x+ayrNFfM1V561/cZAETE9b7yKtJeWDIAdaQnZM5FychqHe0933EyaR1lqqd/YtLiz8goBWspGXMtH5FD6Col1214TaRFDrzFsMeinG4HZQd72TdovKjudXO6esti1/Fe+dhhkjEU9baNxvJBrbfxAco8BcetJOakpMXiusyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meNnOv0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meNnOv0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2A8C4AF0C;
	Thu, 15 Aug 2024 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731453;
	bh=taU6sVxxrQi5OoV6tVHb2T/YfEZLKwvWJOeuaF3wzMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meNnOv0qfvCAiUBNRAP95RFXgfPXORGzVSrR57j4vcNo8CHGYdpHJS4g1kDngllj4
	 X/k+mGYGtSHkw+7MDb7YrvkTYdJ0WuN2nedPgMIzfNGCdDGrWHqmTVN7itzfwSJ65W
	 STGw2Q8hBzIMf+I/vMS1OKicH46qi/vL8M1u+7B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 103/259] wifi: mwifiex: Fix interface type change
Date: Thu, 15 Aug 2024 15:23:56 +0200
Message-ID: <20240815131906.780942431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Beims <rafael.beims@toradex.com>

commit a17b9f590f6ec2b9f1b12b1db3bf1d181de6b272 upstream.

When changing the interface type we also need to update the bss_num, the
driver private data is searched based on a unique (bss_type, bss_num)
tuple, therefore every time bss_type changes, bss_num must also change.

This fixes for example an issue in which, after the mode changed, a
wireless scan on the changed interface would not finish, leading to
repeated -EBUSY messages to userspace when other scan requests were
sent.

Fixes: c606008b7062 ("mwifiex: Properly initialize private structure on interface type changes")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Beims <rafael.beims@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240510110458.15475-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -934,6 +934,8 @@ mwifiex_init_new_priv_params(struct mwif
 		return -EOPNOTSUPP;
 	}
 
+	priv->bss_num = mwifiex_get_unused_bss_num(adapter, priv->bss_type);
+
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->main_locked = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);


