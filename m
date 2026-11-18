Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019976;
	b=xo6T8/ZJHdOlo5sdgfqBTYz0hY/Zjz8LDZmcybRKDqXSkZEg5nXgUUbrfE0mHp717y+B
	 /hM5EQaFhVb3Y/hK86fY/9x7vPye/NAg5wPFF8W0RXKYbv97XKwe8+toAUWtJg/jvTAOh
	 klQLtvb8HRNO6SdLHsPUzunHi12/MIS5ZmLh5Tg28gJJVzXxMim5saR9QH7rubJYxjMoN
	 7tiMn9Ct440yBHY30x2kUnQ0LTlq5a4dLQaHOgTWDLo5/kSns6OXtjCGOQnGn6Fjkpu8o
	 1PwG3Py2+8X3lE4QkRwpbA9/FNPPhB6+zm/POqSL/dmo52Ll+KHndTJMK8Vk/kke50Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MoxHBMzjMIKEBre6/M4MAMGmvbeh5z/xBDioJsH/OxQ=;
	b=X6675ee8rcCaYqY3FvWoamnHGfVsR2bIK1fDqQV6IBqrrIabKKkoYU/xNJSUt/QsyhxY
	 cJYSJBDTRoJMPCaDxT9FvBVup0EEL2WVy9TF9bb+BDWHAdq/cc15GD7cbFyn+uQ5Vxvox
	 TRw2xOWczeBu3ea+zk6xjynajpb1UAoTjtAwC+oq7W+4pwPyhgrCshjdEliiuSFzw608I
	 dtkQIpaedOcW7tbfphPmzJg+h9yuDu6cubVfPbSXmYcnwDheovScw6Y3OIFRenUDYwB8t
	 aNLQxB/HzMmrWePrzoUnlHsJM5tTn6FUbLqOxrVzlQf8B1sYPuSg78OGWCUEqoptdDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIoib03j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76536606A31C;
	Wed, 18 Nov 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIoib03j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24C61F000C4;
	Wed, 18 Nov 2026 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019976;
	bh=MoxHBMzjMIKEBre6/M4MAMGmvbeh5z/xBDioJsH/OxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIoib03jeENjmDjSr1RSQuxAF/lJDBq50iqHKjOkBZK2eX8c6fjo0R5y1yYOFE9US
	 FRe2+o446svRiATlVl5yp/qzpEqUHNk1ef3OzngeNN/7zJ7r22WmUlyNk/AIMYZT5+
	 m++W5LhQ0Z5vHO2G32o6srIUpoaQ5rRovWfY9vso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1785/2651] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:25 +0100
Message-ID: <20261118150351.610870117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 85e56c3bbb7e8ea4626f8653afaef0d79d9cb7ba ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from imx_rpmsg_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 3c00eceb2a53 ("ASoC: imx-pcm-rpmsg: Add platform driver for audio base on rpmsg")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-19-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-pcm-rpmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-pcm-rpmsg.c b/sound/soc/fsl/imx-pcm-rpmsg.c
index 7086fb7fc1eba..30e75fee51757 100644
--- a/sound/soc/fsl/imx-pcm-rpmsg.c
+++ b/sound/soc/fsl/imx-pcm-rpmsg.c
@@ -269,7 +269,7 @@ static int imx_rpmsg_pcm_open(struct snd_soc_component *component,
 	info->stream_timer[substream->stream].substream = substream;
 	timer_setup(&info->stream_timer[substream->stream].timer,
 		    imx_rpmsg_timer_callback, 0);
-	return ret;
+	return 0;
 }
 
 static int imx_rpmsg_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



