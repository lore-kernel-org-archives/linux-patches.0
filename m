Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF44D199389;
	Thu,  6 Jun 2024 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682997; cv=none; b=e12JlECfBNa/LL3bouspm0GynZ1SbZoCe/SM8USSy1c4LdMz6yHP7KjGm08iiPH/zo0Ws/6XpZ4KI8Zm9zV48UkeMf+K5/dcJ4EOyN0xRLGS0wxcjytJRycNaJv8pfPQ3Bhf5k6fmulovEEw/dU7LvOQQMZkB6tds24fpPTV2KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682997; c=relaxed/simple;
	bh=kG1ljDVLnbr8ZjwiMDlCol8hPdy9RG4ztuGswpZN6DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTVjPYyWzTUKo9tmYw71SPiFkjM9dfXLFFVYRW0sCD6UpoSMxMmaeEVTxK5l1jVXe8IZInSvXx/0poXWUxbgQQwlw9Ru2DUvlMaltZK5If+zkM2+AR7nmcoYdXsv7j2NTuNP0bOGCugunWxabD5PmtdgfPStoH5fM/wsnEhDDk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVv7uURm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVv7uURm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCA6C2BD10;
	Thu,  6 Jun 2024 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682997;
	bh=kG1ljDVLnbr8ZjwiMDlCol8hPdy9RG4ztuGswpZN6DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVv7uURmUT4s+OvksAz3ITvMI1b5MRFPRSIZP0jgDaSVX0gsUR6TttP7rFaeP7rvh
	 Ksa3TGbSuarxzhS/N+Yf406QRm2W7UjUWe+Lff/4th9A87DjaIv5vGvVScNiqgyaH0
	 gf7x6J9zU2OjixTmiozmCbDumMGQFoN6DbcrJ+dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.9 198/374] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu,  6 Jun 2024 16:02:57 +0200
Message-ID: <20240606131658.479441013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 559a172ebc6cb..6fc7de744ee9a 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -936,8 +936,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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



