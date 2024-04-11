Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F613D24D;
	Thu, 11 Apr 2024 10:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831571; cv=none; b=AzZ38olhZogaQ8K8JbCataMB8Q6eFlHNRFzwPEdIYwTTiokUg0s4XYfc4qiy6NyOJCxc7LzebkN7gqQxInkJrBUdt82b6FXyogUkDieM3KoG8rXQk63vheYecbEoOUYtxmYL6YlDndhfH0FSIZC/Jm4eO2duQcbhOhmzBosC6eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831571; c=relaxed/simple;
	bh=OIxImODTVN6kRzetAfoPU/f618GY39akM0n27A5EjgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGHyZ5KczKO56D2UcctdK7XUtvr83TM8Al/A5ak/TEq+DCt008I0OiYEfI4ygyP1aKXzAoZyktN1/Sixz6ZRxnd4U4chXAu+UV8V57HoOXr5pLd/mZymAq/xTgOcm+zgMeogw7ts86vvzaim+nw6+MzLz4Uy+bFEjyb5PfLGWdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJHhWxg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJHhWxg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA6AC433F1;
	Thu, 11 Apr 2024 10:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831571;
	bh=OIxImODTVN6kRzetAfoPU/f618GY39akM0n27A5EjgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJHhWxg6CDXSLa3XLA4xjvXbIshHlOhqlE/RNVP3lvdtgmD5ugCAM/fK75OJ58Jj7
	 qKRElaMJ1Px1IQXgnDQ2oG6RMsU1AhmSQHYvDXICr0NjXa0U2TlVOlTdPjzG/Yifah
	 vNkXokJCZML3shHryJuP95RE9YAWwm/kAwtlU0ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/294] mmc: tmio: avoid concurrent runs of mmc_request_done()
Date: Thu, 11 Apr 2024 11:53:35 +0200
Message-ID: <20240411095437.208047725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit e8d1b41e69d72c62865bebe8f441163ec00b3d44 ]

With the to-be-fixed commit, the reset_work handler cleared 'host->mrq'
outside of the spinlock protected critical section. That leaves a small
race window during execution of 'tmio_mmc_reset()' where the done_work
handler could grab a pointer to the now invalid 'host->mrq'. Both would
use it to call mmc_request_done() causing problems (see link below).

However, 'host->mrq' cannot simply be cleared earlier inside the
critical section. That would allow new mrqs to come in asynchronously
while the actual reset of the controller still needs to be done. So,
like 'tmio_mmc_set_ios()', an ERR_PTR is used to prevent new mrqs from
coming in but still avoiding concurrency between work handlers.

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Closes: https://lore.kernel.org/all/20240220061356.3001761-1-dirk.behme@de.bosch.com/
Fixes: df3ef2d3c92c ("mmc: protect the tmio_mmc driver against a theoretical race")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Dirk Behme <dirk.behme@de.bosch.com>
Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
Cc: stable@vger.kernel.org # 3.0+
Link: https://lore.kernel.org/r/20240305104423.3177-2-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index abf36acb2641f..0482920a79681 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -216,6 +216,8 @@ static void tmio_mmc_reset_work(struct work_struct *work)
 	else
 		mrq->cmd->error = -ETIMEDOUT;
 
+	/* No new calls yet, but disallow concurrent tmio_mmc_done_work() */
+	host->mrq = ERR_PTR(-EBUSY);
 	host->cmd = NULL;
 	host->data = NULL;
 
-- 
2.43.0



