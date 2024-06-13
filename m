Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4512C81F;
	Thu, 13 Jun 2024 12:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282012; cv=none; b=IlWuiFT9JfjfvyJStRYvpdev3kgaApiwsJHua8t7GoIaFyQzhEovUQimQGpralsogBkn74/HrFLIdv+Z+CwqBkRXbinIrn4ekWjeO8UaXh8J4WbnUZ0bBWA3Gxl76O9yGYsar+pOhG8tcF7TNIY7Hj4ZzsglwPR4ycKHvycmYdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282012; c=relaxed/simple;
	bh=XknhAIpTihnkOLT4KbnwR/6GzI6r6DgUiuXhYr90+rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJPzQsra62OazFUCcoRByW96JFVwrsg0EC13M+UkmvRpPVt3d7cUIRO7rrIRgCFjlCMmwZXp/3aCNsemeVJ7ZzB4Oiz0X4gBUDYP71xt9+mmPt4qJZMgt9SQvRQyUA2r5JS3ZiMRCMZD7Pi6cenfO/HcyOpTxvPa+LwnstJRjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j19t1Xxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j19t1Xxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05AEC2BBFC;
	Thu, 13 Jun 2024 12:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282012;
	bh=XknhAIpTihnkOLT4KbnwR/6GzI6r6DgUiuXhYr90+rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j19t1XxowPwAL24Re8CJp/2w1o6+TLpMkda0ygN/Fw55/IEgKo5s3LXhYl5gG4eS6
	 4EO8Q5Rew/pXHcygGR54KRKkYpCf8pBabVMAqkRfE0A7e83TxvGwJqNoUix7h7XP2B
	 mEFy29g8lKW8QbQiywWTOAq2AUzXcQwaRA1NoX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/402] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu, 13 Jun 2024 13:31:30 +0200
Message-ID: <20240613113307.325099918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit 9bb1fd7eddcab2d28cfc11eb20f1029154dac718 ]

The return value of dvb_ca_en50221_init() is not checked here that may
cause undefined behavior in case of nonzero value return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 25aee3debe04 ("[media] Rename media/dvb as media/pci")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ngene/ngene-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 7481f553f9595..24ec576dc3bff 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1488,7 +1488,9 @@ static int init_channel(struct ngene_channel *chan)
 	}
 
 	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
-		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		ret = dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		if (ret != 0)
+			goto err;
 		set_transfer(chan, 1);
 		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
 		set_transfer(&chan->dev->channel[2], 1);
-- 
2.43.0



