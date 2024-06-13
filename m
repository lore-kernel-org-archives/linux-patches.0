Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3662181AA7;
	Thu, 13 Jun 2024 12:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281319; cv=none; b=okIsW56pX6PWq1kf9dxjoLqKWHHW8jZC1tng4gEU8MFHaXFkQwqfmfwb37tyyq3q5m575YRHMI4AQyV3ExEFKkzZpz9lYwPu3kN3xrUxW3CsNzW2RmrBdkkB6b363mGZrx9tj2RdHkpSTNotyNLXdnV9ASDCzFlObWZc8gaHLdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281319; c=relaxed/simple;
	bh=Xh98LQWtnmuGQf5l10OhpWs4PFbB2lWNxx0Hal2RAyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVdqlkV9v3a8rwIsfwno6zrxwZ8FL52JDdc0G93zw3uKvZ191zxP4La4asi6mH6ldx4abgaKzaZEJ8vJ3Tq9y8aR5rv1OwO3SSeCNJXMXtv8ekShJGweJd1YApNWSX5/aD1ocRTwakYXYRYl+vRBFvYb7j+ivzEVaK53X/FARAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxeW52wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxeW52wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16C2C2BBFC;
	Thu, 13 Jun 2024 12:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281319;
	bh=Xh98LQWtnmuGQf5l10OhpWs4PFbB2lWNxx0Hal2RAyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxeW52wKNw/IvkEFHcshYWyDqbP0c6KBqX/4vU3N/LKBzPx93ubllzCbm2Y98Wz7C
	 ioQ/wxm1zae9jTCrybkKKAKZvUP4k35UChuVLhwCgg+GuxJ0rBQ759FUKY/Kbb9Qrm
	 dFtF31xcxS987Igm/n6GePAdX0EgIYTAoGYHM564=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.10 214/317] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113255.832979433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
index 2f7ab5df1c584..78027f0310acd 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -913,8 +913,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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



