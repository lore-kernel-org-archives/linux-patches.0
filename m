Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8631AD402;
	Thu, 15 Aug 2024 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731138; cv=none; b=DQR9YAocX16bDhbfGnoxNB6Ws8aZAOpUbbItlDgeCalixwMDySNIbwlmLOeUvzd10ILGvYq9gTaaXGekDLVIEstCJoBPmqDNakvD379N7Mu8nYss1nmh62aG9By1KdN/ZRN/Y8+/Na68cNYxSzK90ZE5kWYWd7MqqGcchJ1hGIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731138; c=relaxed/simple;
	bh=4K42+R24VngEO/HvYTVnNCzptKq2OcWrkRXBq2WCHEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=px7p2VR2kNU4U7R4v4pV4GQcgAMjR3261tv2QkayBRnVwkeg9kdBtem/AgXHrzknPfqNbs6vKFYlu1Tk2IVrkWy4NR9ogBcLQJeTiL59VH5/Wgg8fdNJnsHXumkyThwV0aYenNpnI5hRiHPLRymq2AaladTmTfm6JjelwwlhBsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YauKikYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YauKikYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0220CC32786;
	Thu, 15 Aug 2024 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731138;
	bh=4K42+R24VngEO/HvYTVnNCzptKq2OcWrkRXBq2WCHEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YauKikYtNE+NHzTaDLHUEXnxrdX37jKKjT4u28SviKcrIi4DgvbBrQkUz3tQRofkU
	 m/F0fIOw1oJzpu7S1kzGiWsqc1BCxE8q5ULNCoeTnjIjZmyQreKNyByPWrWeaXA/EE
	 ZSeE0jTurva+sN1AhN+I/QcI+ty/005ItmI1Qiu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/259] firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()
Date: Thu, 15 Aug 2024 15:22:40 +0200
Message-ID: <20240815131903.846610314@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0779513ac8d4f..852d911c78f6b 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -186,9 +186,8 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 	if (ret < 0)
 		return ret;
 
-	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
-	if (ret < 0)
-		return ret;
+	if (!wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2))
+		return -ETIMEDOUT;
 
 	ret = mox_get_status(MBOX_CMD_BOARD_INFO, reply->retval);
 	if (ret == -ENODATA) {
@@ -222,9 +221,8 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 	if (ret < 0)
 		return ret;
 
-	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
-	if (ret < 0)
-		return ret;
+	if (!wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2))
+		return -ETIMEDOUT;
 
 	ret = mox_get_status(MBOX_CMD_ECDSA_PUB_KEY, reply->retval);
 	if (ret == -ENODATA) {
@@ -261,9 +259,8 @@ static int check_get_random_support(struct mox_rwtm *rwtm)
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



