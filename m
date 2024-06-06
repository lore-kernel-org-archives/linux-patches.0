Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9E1BBBED;
	Thu,  6 Jun 2024 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683498; cv=none; b=YmXcmgRYd8TARuQShWhewPFsKj2U5of8CZkbUYl6gf+GvX5x2dXBS8G2fegqfOVK/iVJ4Zj1L7jLdE9kW8vrG9or4aJEEs+EiXQ717OPXDLK+c/DTXSpVxnhlvIVbWWpNbWjHV7YNuKKLVehUtHbnGpjt+I4YU5vbjdIyOOTIW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683498; c=relaxed/simple;
	bh=Y/ZL0wGfhiZWp9HsYYQsT6LxGVdq2XYA79msaeNOfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOjNgRMTM7a27+klZNxzzZQmQkNUvuL7NcEUucIGmCUkEg5ZxStGBFOYLYBI3VwJUW6G+ZxK4QvIeY1g6DyKtTVEKrWnRuHamoznUOKH2blQpUD55ipwEkIidM3OQswfbCmBpJgXBz1J8kW8GCO4VFhiayPPEB13Ons4WYBqugI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gy6FpJhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gy6FpJhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C73C2BD10;
	Thu,  6 Jun 2024 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683498;
	bh=Y/ZL0wGfhiZWp9HsYYQsT6LxGVdq2XYA79msaeNOfZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gy6FpJheJjfEL8X5cC04aKndMIdjFwHkgW6fYW+ebjOq0GssyjbWWo6+Xa9K4UvIQ
	 +yeeqZK/farHvbOmW3Sddn/60iMERhc0LaIOF4+EjF78IMWFT9U/mvCE/Fa6IDDOTL
	 pKA9byGKjyjsAffgnPTwgv30lUyOX5cX80UO6/Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.1 388/473] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu,  6 Jun 2024 16:05:17 +0200
Message-ID: <20240606131712.679053283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 9fe2816816a3c765dff3b88af5b5c3d9bbb911ce ]

Do not check for !data->completed, just always call
cancel_delayed_work_sync(). This fixes a small race condition.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: 490d84f6d73c ("media: cec: forgot to cancel delayed work")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index c761ac35e120d..6f6c7437b61bc 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -909,8 +909,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	 */
 	mutex_unlock(&adap->lock);
 	wait_for_completion_killable(&data->c);
-	if (!data->completed)
-		cancel_delayed_work_sync(&data->work);
+	cancel_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
 	/* Cancel the transmit if it was interrupted */
-- 
2.43.0



