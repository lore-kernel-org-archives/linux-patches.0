Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF45647AF66;
	Sat, 12 Sep 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218818; cv=none; b=oAlJt/C7FWbIdysnGTov2zvNVv6Ft423Wr/shASSMlhetkOeERVlloocFXTow0N7sZ7kKmC5UHtmW90jP2R8j7tLbfc96gF2O8pPksU+jX+YMSUKGNjeF1/VDktxV3yQD4siX/kCS6U+T30Ic9LGaljLnBUvRNZUbm7kJ9a3OSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218818; c=relaxed/simple;
	bh=Q8Ej521c1SALFFELLwuMqneLvC2SAy1AHlfC7H1DoMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZNOP3YwsmzP3gKIzCfXCxiEP2ko0hjxeecsCM0D/9RFEfSHjjOA4PmJ8q5kqWSqcoSQq1923bj1aWn8kLaHaO8X9qaGa7DP+EsfoyyCdbKI8yZe50J1i39ZrIJYKxlwNB6nAxLktSkc6rJytPAqXXd5YmWqvYuoNCrzlry1nTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaoCgzvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaoCgzvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68EE1F000FF;
	Sat, 12 Sep 2026 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218816;
	bh=6jMoWuUa32C+03Q3dkNZhD+TZwNIJwfqdvWL8er2Fro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaoCgzvCXDdfK6y3M9wxMFHQYHENa3fSYJk7ldyzZYSyf9i5AjhMU1OG9pIMJUAio
	 GvCAIZ2jN0o04kyU3UjPGMPlWz4RAMBkozF9n3SNDD5HUo4PH5NpEiHB4b+1VigiTZ
	 CzHVIZZPc2CqweL1RORlXlPpJ+eiHvM27lmetdJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1223/1376] net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()
Date: Sat, 12 Sep 2026 09:00:49 +0200
Message-ID: <20260912065634.805661638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e08150baf0aa1..de1922f93ef25 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11335,6 +11335,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	free_percpu(dev->pcpu_refcnt);
 free_dev:
 #endif
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 	kvfree(dev);
 	return NULL;
 }
-- 
2.53.0



