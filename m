Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB673F23D5;
	Wed, 20 May 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296582; cv=none; b=KGmLkrZg1rE8qIAdSBv3+wxWqS9LpnSZz1Xll98bbaFYeyEVfQ0oJPKG3+bgOvJnxHZDG40eNJZDMxsqfCrZ5lA9v25pmHUuYlOURn9sKbbGPVTx4ncCrYckyUyqpkVqmA3J1FhT9G3FOybLuW+LWYBbwwx4p8c/pCz6I2VrsEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296582; c=relaxed/simple;
	bh=dyoxdjztGEA2NnpkTY2HkT0ztfgIuAsuTFlIm3XvvpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBrs4xIJovgWc59pZxAHaeIKppm0QPU/MPNbs7WKVNS5+4ZQ02Vz5dEUrdaKQgj2Yl1WDvEb5rh5KIj+fYcU2Ts8qz5pBqn4rXHd40J9ATu9qGIvnAnQIfb58UsXdCDWUynCfVGje+y6fFql7sqGK4uM9XY2Q3IdXC8IJVjI6AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FenDa0g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FenDa0g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3A11F00893;
	Wed, 20 May 2026 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296580;
	bh=q36p766QKu27++8RJR4BjggsyBd/cq0oobFBlGVkIl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FenDa0g47PJOINBT/tX3tXoEiHXCuFbX9MvmUgh6N3RsQLwQ3uptleIL4075WPZEF
	 e2a1nNuybqSHlhMq5XoVls5XlwrGtIcJH/cPpzuhvHw2SKzrVkuJJ2gBNqzdgV69m0
	 sS6wL+7OCnv8au6sCpJFjUmYUkVavQQTPL6Ewpfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0852/1146] net: mana: Guard mana_remove against double invocation
Date: Wed, 20 May 2026 18:18:22 +0200
Message-ID: <20260520162207.520519422@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 974df81855d23..e5b4f07e009bf 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3694,11 +3694,16 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
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
 	cancel_delayed_work_sync(&ac->gf_stats_work);
 
-- 
2.53.0



