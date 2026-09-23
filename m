Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45527493656;
	Wed, 23 Sep 2026 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173775; cv=none; b=EitagUSutA/8L7VMe7KohCNUA9L1cYmLd9nJAUsS8m4tLnYkVwYiU7dHxRpgwdo7M42nwBOySRt5JhgHOaN4pdChDCi/59b3auaOmZ06rwtOvioZWyeXnqTdWlKIjUUG/52Z75L/TO//5fecDbGI+W3IUOnfx+dsghyClVzyCcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173775; c=relaxed/simple;
	bh=WHKtzZQ+QlJDhX2iJQTxErNfLhpY/hh1cOjE46J6jqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmXNqz5zqSfikPagIVO0Q79cFGgdP7qI7NVW05xncqJ2vPMEHfZQ5ts8LfERQ9zW1EIl0sKz5pEF3pinlJWaNsudZM8ZDbylb3as4V2KoZrJn5dJQTj/QRRr89fFgDT7TUrudarQfKNlnc4850gSzNMAQ/A6ugNWPUWb7T4CnJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d00ge6zH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d00ge6zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C011F000FF;
	Wed, 23 Sep 2026 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173773;
	bh=IjzpZf/c2BsIOz/+idMAbh8YqbOslZLgMs16SNmQhuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d00ge6zHDLMJuXUDm28MUa62Jp1wKqYXqmD1IzDeRtZWbMG2zUBagfD1h1aBz0b2w
	 yLoEMgwGtXajyhXgGO5pZrpLmgytFY4cOielL/uxWCoG+5v5CBfKpG8Ie57mYBejtz
	 /mXf9KMRSWSJV2zux92aTK78zvbR0jaHQ3rlIP4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 340/438] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 23 Sep 2026 16:06:01 +0200
Message-ID: <20260923140653.629864668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Zhu Ling <zhuling0805@qq.com>

commit 08b54e16d547d5c1aa61bf7a3595bb1620975eeb upstream.

mmc_of_find_child_device() returns a device node with its reference count
incremented. mmc_add_card() stores the reference before calling
device_add(), while the card is marked present only after device_add()
succeeds.

If device_add() fails, the callers release the card through
mmc_remove_card(). However, mmc_remove_card() only drops the OF node
reference for a present card, leaking the reference on this error path.

Move of_node_put() outside the present-card conditional so the reference
is released for both registered cards and card-add failures.

Fixes: 25185f3f31c9 ("mmc: Add SDIO function devicetree subnode parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Zhu Ling <zhuling0805@qq.com>
Reviewed-by: Shawn Lin <shawn.lin@linux.dev>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -417,8 +417,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


