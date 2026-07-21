Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B69403B1F;
	Tue, 21 Jul 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654805; cv=none; b=scm0ZuKNAzGvgOGiJW8AY7NNmZKkFCh+/5wgySdxvHwIOWQ1D54NOxnhOYPRLLcARKdf/9kxdMIF0MlGVCK1KLkZQWTfkm39pUoqmANvhRwHhI7JQnMCMMO/UQ7wl+h4LvgrQrdSnZYGPktzHdjMIil4RhaVZHmnHXogVnbQvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654805; c=relaxed/simple;
	bh=3JDTbBfQnvwDFhS0aZNQ2zDQtdBi30BSPCMl/f84eVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdI+t+mg3fwcGBLImQv7SYUhGH64qqZuZCyhQM+X9olSOeoUXpORAQE0aKYVUizZU9bkK6THaRgHPC5FVjSuOZ+u4hJwrlQe8UWQ2eCCrcXYAXho5X9yxw6EdwxYiK4G5Pw+ryfGbM8gIgp5s78COhqKUIOSG+Oy4seAd3FyFNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWrZkiwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWrZkiwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EA81F000E9;
	Tue, 21 Jul 2026 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654804;
	bh=6efMpcJgjke695SaO3y1sX3YzsAUatFZQSIZsuHUAQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWrZkiwalqSEmBWdxTETmb9pM2sA+TrPAD1uZiRcz7sKk8fB/1ICK8mnkK5/PllKW
	 hFa1kenBs6nASw/LjWp0ycKukfT+T8WZAR8fvVJz02zYuxcZTjnxIbIbaPSDUGX9CA
	 TFLT0HB6pUDXpa0WRfkCyz+9kGkQGP/Te3iipCNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1842/2077] net: sparx5: unregister blocking notifier on init failure
Date: Tue, 21 Jul 2026 17:25:15 +0200
Message-ID: <20260721152636.183547015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 483be61b4a9a6df3b7cb277e8f189e082dee4cb8 upstream.

sparx5_register_notifier_blocks() registers the switchdev blocking
notifier before allocating the ordered workqueue. If the workqueue
allocation fails, the error path unregisters the switchdev and netdevice
notifiers, but leaves the blocking notifier registered.

Add a separate error label for the workqueue allocation failure path and
unregister the switchdev blocking notifier there.

Fixes: d6fce5141929 ("net: sparx5: add switching support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260623115714.2192074-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -765,11 +765,13 @@ int sparx5_register_notifier_blocks(stru
 	sparx5_owq = alloc_ordered_workqueue("sparx5_order", 0);
 	if (!sparx5_owq) {
 		err = -ENOMEM;
-		goto err_switchdev_blocking_nb;
+		goto err_alloc_workqueue;
 	}
 
 	return 0;
 
+err_alloc_workqueue:
+	unregister_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
 err_switchdev_blocking_nb:
 	unregister_switchdev_notifier(&s5->switchdev_nb);
 err_switchdev_nb:


