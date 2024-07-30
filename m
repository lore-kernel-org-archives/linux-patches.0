Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4761A6161;
	Tue, 30 Jul 2024 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356558; cv=none; b=ZawZpbcTVQjBYCBgXiv379fSWqnEG5CXUga3jZy8qlaP3xS3swMxwPo4DdD4vsnEcpfbVCq0xC2kiuw0nXA19kcig30dkN1C+nZ6ofkrbCmeviaP8SfdJX3JYSI4aaPk/AzyX5srPVXkO5gwBJWdARAizS8RTgvsOccYoFVRJjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356558; c=relaxed/simple;
	bh=qf8AOlsqAb6zK++T16IOr+90Ae1uEZgVroWjFmKyHP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE7GQBRJOV/Y0plaxkWdgj5K61oS08UdwToB+sfEcO/DDYV/GNd16LNUU7EdvvqLkJPRy3+BH3AnSTwtIMYGse4xx1xyLIwaFdRRp0sOBCuDfza5aoJXzvGTZoxSdlgDa6PRTfd6EhFQbm6sBV1oJ4QMHZkKCWFi4YtfM2fmBWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSzb7PdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSzb7PdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67350C32782;
	Tue, 30 Jul 2024 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356557;
	bh=qf8AOlsqAb6zK++T16IOr+90Ae1uEZgVroWjFmKyHP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSzb7PdHooJPFXh33B+an7M5Gq7fVdJYwx8eopYQOWKw0yS8GGTE0pE9StXHucTg1
	 2nidgePy2en0uWG+xh8Qv/Eq8p8+uU4XzMtUHszC9jPfJNBkJXJsoxDAjm8+DtDL+X
	 6zaRZTKPTtBdinn7Jja3RXfm0Ih5G8NaC06XaZ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/440] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Tue, 30 Jul 2024 17:47:20 +0200
Message-ID: <20240730151623.953787930@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5f82c1e04721e7cd98e604eb4e58f0724d8e5a65 ]

Make sure interrupts are not left disabled when we fail to suspend the
touch controller.

Fixes: 6696777c6506 ("Input: add driver for Elan I2C/SMbus touchpad")
Link: https://lore.kernel.org/r/ZmKiiL-1wzKrhqBj@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elan_i2c_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index d4eb59b55bf1f..5fa0d6ef627bc 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1372,6 +1372,8 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



