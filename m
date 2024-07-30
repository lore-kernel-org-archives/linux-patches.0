Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0485F200137;
	Tue, 30 Jul 2024 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355290; cv=none; b=u/fHn/zpxiIOFUYeSfqPZwTTBPiIQaSIOtdiGeo5a4XGFxuD7qigTlGn+ytIB9weNImft8tofUng2t7iGuCTUos9h0PIyTpBhOoOKou00HxjUXIsUN/uoze/Jyr8TS8I3wzLo0gduZqslnkihUxBic2tkLjhf/B0Oyjfb1MRw/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355290; c=relaxed/simple;
	bh=kAoiqDJY5ciHFErSR+sdZ7cPwNoqH7v5Hq0lJO085Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/naNFZ8rfJ/qqC2aGrpdQOkGwgYNgi2VcUfEesMy3GMakb6TO3CzTC5LCt1R2F8TZ5Or82DzM3W77+OoPIysDTWBnFjUGfHD+zBcBFnS2ae/Gw664gkzVQa6Hj+6Cr6t26wbU2jl4F2DHwcLFubwoJ27Ru6MvyAYmtvvHx01yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohsSvAqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohsSvAqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A790C32782;
	Tue, 30 Jul 2024 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355289;
	bh=kAoiqDJY5ciHFErSR+sdZ7cPwNoqH7v5Hq0lJO085Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohsSvAqX0jN8cBMhaWPN8VY6hPreJT2xqQcJLAgWNFt2fMp4pDYpGSDBE0N75vfRA
	 lat0sRbWRJwiF3K1fUk13honzsezBSZ1ZganjxBePiw4ZVhWrEJF5zg8gsGL9PnfnA
	 gAIFtsFxNrlcdXinpD3tDICaUnnEhATMEMhch1sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/440] firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()
Date: Tue, 30 Jul 2024 17:45:13 +0200
Message-ID: <20240730151618.885980798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 8467cfe821ac3526f7598682ad5f90689fa8cc49 ]

The wait_for_completion_timeout() function returns 0 if timed out, and a
positive value if completed. Fix the usage of this function.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Fixes: 2eab59cf0d20 ("firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index fa4b904d74df1..98bdfadfa1d9e 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -202,9 +202,8 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 	if (ret < 0)
 		return ret;
 
-	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
-	if (ret < 0)
-		return ret;
+	if (!wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2))
+		return -ETIMEDOUT;
 
 	ret = mox_get_status(MBOX_CMD_BOARD_INFO, reply->retval);
 	if (ret == -ENODATA) {
@@ -238,9 +237,8 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 	if (ret < 0)
 		return ret;
 
-	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
-	if (ret < 0)
-		return ret;
+	if (!wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2))
+		return -ETIMEDOUT;
 
 	ret = mox_get_status(MBOX_CMD_ECDSA_PUB_KEY, reply->retval);
 	if (ret == -ENODATA) {
@@ -277,9 +275,8 @@ static int check_get_random_support(struct mox_rwtm *rwtm)
 	if (ret < 0)
 		return ret;
 
-	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
-	if (ret < 0)
-		return ret;
+	if (!wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2))
+		return -ETIMEDOUT;
 
 	return mox_get_status(MBOX_CMD_GET_RANDOM, rwtm->reply.retval);
 }
-- 
2.43.0



