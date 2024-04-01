Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D413D961;
	Mon,  1 Apr 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988102; cv=none; b=tlNzLma6Xdre8jTBrUUlIsvETFyYt1IweaUDwEqO3wx81OUNtWSYkBHdyn54EXPKb1FhMmm887El3SGhBOp6OTJD/TFmxKLWDPw9MjSMw7GTqYBsbqwnx6XxdzCgJQaSn+eWubbeWiA5h1xKlQKlnRG7iWgqum0UEyagtgnxKyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988102; c=relaxed/simple;
	bh=nC9mRdXnAu3BUrWFVRocod8BLs3cA8bG4AnlUQX+I7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aANNZvJcWVWSNqWgOygFMrMJtQU4DyJQLSq7UKThDetK/Xs8IgxMy2IwI+cKR6Y5Do17O9D/ZXkWDnYjvsrTNcmFycq34rI9WRbCIl3eu6WGX9MGK9TYZA2az7afnmH2s8qHMkvreyhERpxp292qlD093orz1/gZls0cS6GVxBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOxUhzxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOxUhzxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9689BC433C7;
	Mon,  1 Apr 2024 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988102;
	bh=nC9mRdXnAu3BUrWFVRocod8BLs3cA8bG4AnlUQX+I7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOxUhzxzwXpr4aQpEd4yp4YtagkQHG76PHs8amzEPZyR7gqUO2URBH3KDHpLJqGID
	 sEhzjnDGFiewfFHa5zS+r7iiCGY6VveD4S22euUzMzkXdd5mj/kCUCzusWnUkNntYb
	 vd7FEPnLrNzoRXGQx3LN8KnH+KJ/gPy2VpGMARQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 085/432] mmc: tmio: avoid concurrent runs of mmc_request_done()
Date: Mon,  1 Apr 2024 17:41:12 +0200
Message-ID: <20240401152555.656468350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index be7f18fd4836a..c253d176db691 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -259,6 +259,8 @@ static void tmio_mmc_reset_work(struct work_struct *work)
 	else
 		mrq->cmd->error = -ETIMEDOUT;
 
+	/* No new calls yet, but disallow concurrent tmio_mmc_done_work() */
+	host->mrq = ERR_PTR(-EBUSY);
 	host->cmd = NULL;
 	host->data = NULL;
 
-- 
2.43.0



