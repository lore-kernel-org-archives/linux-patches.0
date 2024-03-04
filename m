Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791A7BAF5;
	Mon,  4 Mar 2024 21:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588113; cv=none; b=Y+PAKx6UK7DbzaXtCRH4rkkyqkNnwVa/I7ekAcZV+f9mWhFKBiNBVoz60IFL9J5xxpioxm9DDbEHG0Ti2gSRskFJgMssLqH3sdRJbS5HDrWqw+YS7EjWX9S9abjcg4p3xrrxxHpg4Uyhs/ZoYwI34oMiX08TgR7+MYbv37lLrI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588113; c=relaxed/simple;
	bh=Yy5TPoqDrUjXWRAOrA3qYS7mEcZtszQ7a2f+KQxtUKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYpQaolqkW9eNqLqPT1JdyiysLlkP19WUjPUASNtnGsBAaeAuoFymv2L82TRfywRIPLNp0hQelEEQO/NLZTe57mWZve04puRnE1x9XgoEyZQC/udP6DTAXyZnIZkev/M+v2NjWyK0DgE3X6NBSN1K8exrliEvHLBSwtYJN6BrUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2dqwgMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2dqwgMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68727C433F1;
	Mon,  4 Mar 2024 21:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588112;
	bh=Yy5TPoqDrUjXWRAOrA3qYS7mEcZtszQ7a2f+KQxtUKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2dqwgMQWlVB7fzCL5+/YslkO8nUniWVj/DeInLH6i27aaN8cI36F/tbvHp8cFA7C
	 39n8f9+NUFl9r2AfJf4jiAI9OpVnzrNHNNfGM7VgIRsung8K6+S660J2t1iqk2fMy/
	 tbSRjVimrS7aEfxUha/4MUw6s3oAXavGGsqrqnEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/42] power: supply: bq27xxx-i2c: Do not free non existing IRQ
Date: Mon,  4 Mar 2024 21:23:45 +0000
Message-ID: <20240304211538.240722720@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2df70149e73e79783bcbc7db4fa51ecef0e2022c ]

The bq27xxx i2c-client may not have an IRQ, in which case
client->irq will be 0. bq27xxx_battery_i2c_probe() already has
an if (client->irq) check wrapping the request_threaded_irq().

But bq27xxx_battery_i2c_remove() unconditionally calls
free_irq(client->irq) leading to:

[  190.310742] ------------[ cut here ]------------
[  190.310843] Trying to free already-free IRQ 0
[  190.310861] WARNING: CPU: 2 PID: 1304 at kernel/irq/manage.c:1893 free_irq+0x1b8/0x310

Followed by a backtrace when unbinding the driver. Add
an if (client->irq) to bq27xxx_battery_i2c_remove() mirroring
probe() to fix this.

Fixes: 444ff00734f3 ("power: supply: bq27xxx: Fix I2C IRQ race on remove")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240215155133.70537-1-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery_i2c.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery_i2c.c b/drivers/power/supply/bq27xxx_battery_i2c.c
index 0e32efb10ee78..6fbae8fc2e501 100644
--- a/drivers/power/supply/bq27xxx_battery_i2c.c
+++ b/drivers/power/supply/bq27xxx_battery_i2c.c
@@ -209,7 +209,9 @@ static int bq27xxx_battery_i2c_remove(struct i2c_client *client)
 {
 	struct bq27xxx_device_info *di = i2c_get_clientdata(client);
 
-	free_irq(client->irq, di);
+	if (client->irq)
+		free_irq(client->irq, di);
+
 	bq27xxx_battery_teardown(di);
 
 	mutex_lock(&battery_mutex);
-- 
2.43.0



