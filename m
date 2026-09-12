Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7987033993;
	Sat, 12 Sep 2026 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204371; cv=none; b=pdgAK1TUZMwIyYPczUAJnjP0xPkyPRoCcinLL1kS4xJSQbeJDZSDL6MhqyeIApltXyQX1PsJhfPB440MqSUmcLU25xH/Y505in/OLO8a2C3DmrZViufY3fTHGoOdjE1ak4E8POsCpMW5VwjSiWGQnypwgTKirKB2BEb8cvUbDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204371; c=relaxed/simple;
	bh=GSqUo8vZvcPsxqI5SHOE7inwVqB8Rrd5ezHB7B4e5TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeiCBpYg6o9aFAjE3Z1ypT9lXMhgTzD2/gXFILpCK+dNuUK3ErHw+PnPyu8hMmrx2NlTzXxufFKg6RX/VdHNh3m9muK3zSR8E8898Jjun4Eim0d8ECUx9NK7dZ0KzOvwsPSt1g1GXpY2aZpK4nZRnem/xhvPXk07Ec+hlod0gVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQuNVlVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQuNVlVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF941F000FF;
	Sat, 12 Sep 2026 09:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204370;
	bh=icTGv5Gvg/d5SSh59yjvtdpt6iz5Q/RU8uEHfnLXcGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQuNVlVLDlJYHa2vdCWumydV7T2x6QzjG6GZMC05kjU4Y6AYU21rHQ+7hCKYBJMtQ
	 4oyVppgqSlCw8uklwO80nCYqu5YYMdVaNsJRqfpm/53uXEL6c5n/Czr7fbK/Xx/LOE
	 JFO9tEHTT6TDwABFjuCBYR4FGwHclMHKmuFzNjGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1597/1815] net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()
Date: Sat, 12 Sep 2026 08:55:47 +0200
Message-ID: <20260912065726.481023452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0b1c2af8a22c35cb099c735c2f63ea3ba757557d ]

sashiko is reporting that trying to read /sys/kernel/debug/ref_tracker/*
causes use-afer-free crash when either alloc_percpu() or dev_addr_init()
in alloc_netdev_mqs() failed, for commit 4d92b95ff2f9 ("net: add net device
refcount tracker infrastructure") added ref_tracker_dir_exit() to only
free_netdev() path.

Closes: https://sashiko.dev/#/patchset/56c707e7-1fb0-43ec-b8fb-cf6f451e513e%40I-love.SAKURA.ne.jp
Fixes: 4d92b95ff2f9 ("net: add net device refcount tracker infrastructure")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/b06ce35d-e7bc-47a5-8e0a-e82be7e4dd08@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5ac31370df937..39807b68ff260 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12167,6 +12167,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	free_percpu(dev->pcpu_refcnt);
 free_dev:
 #endif
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 	kvfree(dev);
 	return NULL;
 }
-- 
2.53.0



