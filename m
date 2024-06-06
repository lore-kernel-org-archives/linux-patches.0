Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8771A0DF1;
	Thu,  6 Jun 2024 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683694; cv=none; b=KUGYtZgjUpLJRmPMDwJiW8S3oenZCflyLZshl8HqeE2nRY3yZ+3m5rHK34KdcPTDopu1d5NsBhPqOyI8xDVo6ZCeBKIx8/YSAAWks2RF42UZnE+ozq8LU2KTRZ0Ego9B6KCUf1H2Md92Kf7KcpYavm7BAXMPO1U4rz52b5/f3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683694; c=relaxed/simple;
	bh=PVTG0H6TNWGLhYKrEz/4+7mezVBxLca+Gvl1luCIF+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSLGDSYBzzpzscCeLkMyrjqIwedr8SkBR/W55IGhe8Gbm7+6zbAA3aNHTG83V4B5wnP6r77mjkCQUohZRa41cDd0Z+DjI+lR+IqM+35e95nhihzpeTXlN2FmmZsqTqyBPkeCqYag24H9ekpYWbw122CYcvAemVWFEJ32VfwXe7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhlFQUCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhlFQUCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6718DC2BD10;
	Thu,  6 Jun 2024 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683694;
	bh=PVTG0H6TNWGLhYKrEz/4+7mezVBxLca+Gvl1luCIF+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhlFQUCDb+0wVwjHgCELpjLiJ4HglCCJjfrVsGnPc+C+XbsphVdESIZ99QPWWQYnV
	 hh6uQVgtA9AKdQKBTzoZnIjbnAyogKzntbBIbt7K3CVjXC3cX3mOvAgyN6Pp1uZpt3
	 Xq30d+8jctwoeMXQ2xWbNZoJgd/1g6yX6/jT2CPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.6 607/744] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu,  6 Jun 2024 16:04:39 +0200
Message-ID: <20240606131751.955385764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed1fa07e70b57..99c14942f2813 100644
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



