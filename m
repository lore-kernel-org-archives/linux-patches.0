Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7480D147C8B;
	Thu, 13 Jun 2024 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280071; cv=none; b=Ex2M56UFZkHF4kEbV3wqq/3PPBj8po4RhvzSJC9Yn0moBUCtMjEshV8pTlzgGvs5cuKTcVYYxJg2whZhDuFTMs5Jw2+te/iH9LHcK5bn8kLyQ892wkL8qOimPwnxEtVEhfyZL/Pgtczp1M1s/p7e/Zd7yv5iRhPmwqMKX2WbXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280071; c=relaxed/simple;
	bh=Gk4W+LwGo1ju84k4dGjmZ1oise48bYYEDTAfOVyTPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ladJrJCLAOYAiKJEChShQqcW1VaoeckbwkcQS7M71fDjVGWiCLBZcmll01cE3HUiVAKMuDw+ckiaJE+1go8Bdp6Ra2njq9kJh3Y1gGtDHtGS9nCdw0K2FtDYcNOhdWK4HlT/pEc4HqDVotYXyTpOwhZ0y6bbDDQaOqNOyikvggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/4a4LZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/4a4LZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D0EC2BBFC;
	Thu, 13 Jun 2024 12:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280071;
	bh=Gk4W+LwGo1ju84k4dGjmZ1oise48bYYEDTAfOVyTPJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/4a4LZM9tzh8PyQmJdquC1ewMHHKkeDKW2kXoNO3xuLRAXIZiHLyM+hMffncHIZA
	 MpUdBeNCVXk60C107rxyew/yFsAnpBLKu/Y94eMM0BXXx3kA3fq7SR6Dwzj/Z7xfhY
	 cZvAYr5+7Lnip/wvFhm0TRzHdr9H/+YzWiJwXra8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.4 133/202] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu, 13 Jun 2024 13:33:51 +0200
Message-ID: <20240613113232.894526485@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/cec/cec-adap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 4c1770b8128cb..94ddaca496c94 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -908,8 +908,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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



