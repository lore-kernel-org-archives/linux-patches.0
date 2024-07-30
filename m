Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E390E1A76A9;
	Tue, 30 Jul 2024 17:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360212; cv=none; b=o4OJ0+G/SFkzJM3gHt+dPpoKAl/fJFbT03OMJU7jBZnRQU96rof1qAwQcccFn3NQmGgcczZlnUj/vFNpGDRCHe0E8Y+R58iKaQc1wV7VrfWcC1rCNGDEjbgEVwzad0UnVlPq8wL1s/CFyR4wTWdB+k4nc/qt+EzaA7ppD4haSXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360212; c=relaxed/simple;
	bh=lId9ng286TPYdwzZRlP0gx7rF25sV/ObJtCdmsFceHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGT5vXjGW6ztEBIpOQdbJNv2NinN0J598zKHibK0c1XGamyWhMgp1KScts1XNAoTZ5fiUYfa8r8vAkTSN0V0PKXniblQGCWS0KA7GtOudYNp1RqWjevQqk7q9jLWRHPWbDZCVqK1erJeyhVP4eS/aWGKdZB/ta5CII70nKBT6oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptl9RBQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptl9RBQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B96C32782;
	Tue, 30 Jul 2024 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360211;
	bh=lId9ng286TPYdwzZRlP0gx7rF25sV/ObJtCdmsFceHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptl9RBQDPiOyQVO6TW86t63CG25x0zsryR/eroY/8GsJZ9tHBVZ0lJtjrHtakJm+S
	 BU8ewVY96XQGZEJ2YUXGJ077MoXuaoOntLnmVyzb39TY3FvPIIGNxeI+eL+7IHKb30
	 M43CX3XhmdPSB6W1NHU9qqSiKWfleKUk29EJBOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.10 599/809] wifi: mwifiex: Fix interface type change
Date: Tue, 30 Jul 2024 17:47:55 +0200
Message-ID: <20240730151748.488522345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -926,6 +926,8 @@ mwifiex_init_new_priv_params(struct mwif
 		return -EOPNOTSUPP;
 	}
 
+	priv->bss_num = mwifiex_get_unused_bss_num(adapter, priv->bss_type);
+
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->main_locked = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);


