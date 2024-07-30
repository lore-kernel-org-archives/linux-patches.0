Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358B18801C;
	Tue, 30 Jul 2024 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356394; cv=none; b=K3kEpvyd1NYQcnMKbqRmxyHdxEODAAOnEqcl0g6g62B1j96avUXI0w9/hjQ+ezT6ndS2ok0QvE1yvUa1P+GaxYwTXHk7qZqN+B4ly1m7qx5K7fWQo45fQ4G0Hu1RVOYHeaXCSX/XD/kCImc/+McjlX1JZq5RKO9MOSf4Z5eKdV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356394; c=relaxed/simple;
	bh=oUae6dsyvUGKK5ZGCi1EpCLO9czP4jI/fzCWqH/VShE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mz2J6JFplXPGZC/X0KbcniEoALM1yjzcnayrE2oV+/hB4c3TdKE/TNb3aancxXQFAd4LGiJhldbiPjIgiaRmwnsRISsXtQ8WlFtEgBehZ1P2Yz+n76Rt40NPq+0kegQ0tARUwc93a8llW8SVVmp8sgopxpkFG9kFilPB+z533yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxiaWOLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxiaWOLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A383C32782;
	Tue, 30 Jul 2024 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356394;
	bh=oUae6dsyvUGKK5ZGCi1EpCLO9czP4jI/fzCWqH/VShE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxiaWOLh3HzqDl+8GTfV7thjk/Vf5qoHbMMM129wBQoxYen4epkQypIm02fcHD+Kj
	 jS3ui0oNy9T/+3YidXS72+81lskFuFmrt5ervy0weK9un99ZShLShZB1BduR+AEHIg
	 zSVSKytyHasoYOSGZCOqPz7Wyz1U+ziI8u+Kpeio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 146/809] firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()
Date: Tue, 30 Jul 2024 17:40:22 +0200
Message-ID: <20240730151730.372408829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1f9160c4195f..3f4758e03c818 100644
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



