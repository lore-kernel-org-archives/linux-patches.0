Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3693B582F;
	Fri,  9 Oct 2026 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556664; cv=none; b=sd5F8ADA2AlnaXH2ltCChW70+4oA0DQeMUceCUrxHzWo6nNuSqX0yDuwBgcbkT/nvspmejPVy2UQezl9egwcdYiPDHhU7vQdEbOWBLO8qfehT6QocqLEVkDm8KvVL6fNHDH1shoaZzMdR0MaFrT8hcwAxmW0cf8tXi4AtzGSYtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556664; c=relaxed/simple;
	bh=gODcQNVjdpCYV0SuMX8AUGZMxVARoYwGdqFSPKByLuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9UvmCbl2qg84h4jx5ol//hjk2vjtGZg6TkUdzkHc+pdLc0ucTe8RNdHvG16/OZCPActHX4kwA7m/motRLHpoynkSn0lRHw0zO6q7hT0El9EFtRLYbYcSOdD4Kqw9U6XPQj+pCyPKo9t+qBm+0cNy+ZJF8czUpye3co0Fvlup4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=latJwj4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="latJwj4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFAD1F000FF;
	Fri,  9 Oct 2026 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556662;
	bh=/YzPwzUw/KwChVCQ68lyYaaJG1OIkdKcXWdijsW17T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=latJwj4BVw37xQvLwhF488CiWH7Zqqgh94NPAvsLR0fnu95Eg3HyEjZ+1Tz/Tc4lg
	 tqK7Z/IgVWP0dye6t8EOAHTdo107yMA+6UH6rt4nfmB9iU3RDY8Blu73vAoPECPieV
	 ptXKxfa0ttbUC91uu96k7GZwmvGyET8ibn9VMX0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 217/428] usb: typec: anx7411 - stop the IRQ before destroying the workqueue
Date: Fri,  9 Oct 2026 16:09:14 +0200
Message-ID: <20261009140950.889501603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 469600d5d292b1482c90dd6853555821d11b8c5f upstream.

The IRQ is devm-managed, so it can still queue plat->work while
remove() is tearing the queue down. Disable it first.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910011150.2966843-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1566,8 +1566,11 @@ static void anx7411_i2c_remove(struct i2
 	anx7411_partner_unregister_altmode(plat);
 	anx7411_unregister_partner(plat);
 
-	if (plat->workqueue)
+	if (plat->workqueue) {
+		disable_irq(plat->intp_irq);
+		cancel_work_sync(&plat->work);
 		destroy_workqueue(plat->workqueue);
+	}
 
 	i2c_unregister_device(plat->spi_client);
 


