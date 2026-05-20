Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B136405A;
	Wed, 20 May 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299210; cv=none; b=GhlXdX302XUWRoTdEdpgNkEo6mNhIMoBNrgh1xVZ42UchIMWylmP0MQsaxAK2rdWmAVeRAXPzcihvfE/JN95QgBZTUtOHAdpspYheyQ8I7CbwNePJkXwAliQajZy4P+pJd82aeW4k0lfRpnQ5ADK+9CPAmkQAN0+3Jhia8GHIzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299210; c=relaxed/simple;
	bh=lHp8xG8w1UouWNS1bnC0uQuq1G+P+s93QKS9oC99Jc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrTvBrjSzO9QVCr57JwFvZJSiSxE2CJRewQXrbE7i8zVjUsGyMsnnTR5uFVuTuwgHvxT/KFNLCCXbR6Iux56XtHwWsZkSpZH0HK4vNK82Jth/FeMnEkWIcQkx8lNiZzuemoUwxyGb8T9bW6dZsMHsXrHTY2XAWxXn3Tr9y9as5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/29LeOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/29LeOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9843E1F000E9;
	Wed, 20 May 2026 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299209;
	bh=PHfZK+qFn4GNKYHiaPQ3uGQAN4vvW5Voloqt7YbLzPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/29LeOStnxGIBAhG3wBJdI93+xKMNcXb2ykNZ4oFKqh3EFQijq54s8L+3/QB636s
	 SEDm+YTV91WgZjvS5Kpdq+tSc+ZpLEQYcGbJvN113+mW5gEJRQzUNEO3GTKB5UTjrv
	 UerrnF8TChr7olmVMubYM/RRhqVsFcOZZipuoBks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 702/957] net: mana: Guard mana_remove against double invocation
Date: Wed, 20 May 2026 18:19:45 +0200
Message-ID: <20260520162149.763435339@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 50271d7ec95144d26808025b508f463780517d3c ]

If PM resume fails (e.g., mana_attach() returns an error), mana_probe()
calls mana_remove(), which tears down the device and sets
gd->gdma_context = NULL and gd->driver_data = NULL.

However, a failed resume callback does not automatically unbind the
driver. When the device is eventually unbound, mana_remove() is invoked
a second time. Without a NULL check, it dereferences gc->dev with
gc == NULL, causing a kernel panic.

Add an early return if gdma_context or driver_data is NULL so the second
invocation is harmless. Move the dev = gc->dev assignment after the
guard so it cannot dereference NULL.

Fixes: 635096a86edb ("net: mana: Support hibernation and kexec")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-4-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index cd3a435485a19..d90be4142e257 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3568,11 +3568,16 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	struct gdma_context *gc = gd->gdma_context;
 	struct mana_context *ac = gd->driver_data;
 	struct mana_port_context *apc;
-	struct device *dev = gc->dev;
+	struct device *dev;
 	struct net_device *ndev;
 	int err;
 	int i;
 
+	if (!gc || !ac)
+		return;
+
+	dev = gc->dev;
+
 	disable_work_sync(&ac->link_change_work);
 
 	/* adev currently doesn't support suspending, always remove it */
-- 
2.53.0



