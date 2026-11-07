Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062799;
	b=nM3cJ88BDb4LCNmy97KEIpPKIxtRTjvKibqEnHt7Ok6FldPDWsVF0jwFqfntFY2gXz6+
	 RP93+sA2dVVD1nuIdijdbng4fT0F2ozXcnHuOy2agpS4CtrTu6Jxh20FHYehieZ1Ja4Hz
	 ZgXHfLR0S1AFCC1vEvF8lWVEd+eTZwrUAOy+a30EA+kTXzmtU+GKMQM3lvNoan8/p8UJO
	 yWmBzH6+yiLQkv+e1+g5JKdrhe1psUsrfglDnIVdYlNzOGi21vvTX5UQiTPculwp7bwyS
	 EpTQu2wtETn+knyCJtFvGudNGexaofw7eMA4XyjWczd4sxd2wuT1v1eyWeB7cZ/E1TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQworxnOIDos2YlAw7mWv6RCbovJTEcVAgYhIsfNyDM=;
	b=LoDFi+F6p2LAGEI7q9hQV9dLJBwAIVq2wgQAcyijuqpOORUxRSGth1DBwkdfUZ5HaWpU
	 uZCqrr9tmpym7Y1WBY3DbtWaAVDIhaCUmmDqHmyKUuebIuqdDXHudtWtE3/KDiB2W33ZN
	 Rw8RZOA8/mmGH0iorlYe+JVo+xd2BTg0/IU9VKRbZ4rDa2OGsWru8UFWeYk3oM8UxNN11
	 mDO7N9kaM5cbSkNU/q8KeSyG82npFRCI3FmEKgiSGNK9C+MlwO1OPYebHKHo5HwULf3hY
	 CCwWBXReuPWV+bEU1PsiKMV95yzH49eNQ1qZrx6oAr9sj7MAJmLdbuMF/oAEEdsuyQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcEn3jJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA20606D809;
	Sat,  7 Nov 2026 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcEn3jJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF71F0089F;
	Sat,  7 Nov 2026 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062798;
	bh=FQworxnOIDos2YlAw7mWv6RCbovJTEcVAgYhIsfNyDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcEn3jJyOvaIAfNTBebSRzEpvYt7Ka2gBkdwNIwZ4afK0s3KAoowd2CQk3gbwD5K0
	 PXT/q3ZSDJHmIHFpjfSNgtddvew/aRT0lD+rKqhnRfaeRWbWFcLHVRjmdpGrqB2TrK
	 1X/mhbGUwhp04huorWMDCAiEU3vvUsURW1O7bpnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/869] media: stm32: csi: correct remote pad retrieval
Date: Sat,  7 Nov 2026 08:46:23 -0500
Message-ID: <20261107134856.071272896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit b83651d321d4fd07979a59f359dcb0266391f17a ]

The function media_entity_get_fwnode_pad is called in order to
retrieve the remote pad, which is the source of the CSI.
However this function is expecting the sensor endpoint fwnode
and not sensor device fwnode as it is currently given.
Correct this by properly relying on the notified matched fwnode
data instead of the subdev entity fwnode.

Cc: stable@kernel.org
Fixes: dcb0f4c16be5 ("media: stm32: csi: addition of the STM32 CSI driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/st/stm32/stm32-csi.c b/drivers/media/platform/st/stm32/stm32-csi.c
index fd2b6dfbd44c5..ecd0ed8e76b59 100644
--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -825,7 +825,7 @@ static int stm32_csi_async_bound(struct v4l2_async_notifier *notifier,
 	int remote_pad;
 
 	remote_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
-						 s_subdev->fwnode,
+						 asd->match.fwnode,
 						 MEDIA_PAD_FL_SOURCE);
 	if (remote_pad < 0) {
 		dev_err(csidev->dev, "Couldn't find output pad for subdev %s\n",
-- 
2.53.0



