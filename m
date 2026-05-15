Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD743F8716;
	Fri, 15 May 2026 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862546; cv=none; b=IcghfPQJl5gvs6/3njEihcwtJDuAsz1ANgPgoMel/ah73Dmw82WgMYrIxu6JxyBMdmpPvhQ5LFPoOgob7ZRrN8dg6qKKThug/umkRqGMLa9xp7HkP57rU8SZHwSwf0uGotAPZwT4M7VALcgMx9tZIoXoqWoT0j8af+jnOXoCXDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862546; c=relaxed/simple;
	bh=bXMuFgFJNwAHY4CZbjK4S0MxJurFoquBGmz4RSq2Yao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9H7pLdG5zXJRi/qYPYUNp1yWZx6Gw22jVdh/wrUzIWMYXoKAcrJetLOaAgguZHnxhwGEEXRNpZL5w0H/4L7Hyw7G8HA2/DWardCSdOfRc2pBxIr/f2aMF1cLgjdP6xVy3FDjR6yz7LoZsUJ9y1ssif2Bv40G2/4uFpsNwkBnc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKh+PFLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKh+PFLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7214BC2BCB0;
	Fri, 15 May 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862546;
	bh=bXMuFgFJNwAHY4CZbjK4S0MxJurFoquBGmz4RSq2Yao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKh+PFLSiWXJYkqTAutq221uXnzW3Gnbz5PDGkhv8RG8icTfwuCfipa/nWnGUjkNf
	 vhApvvc3Cin7CVdY+doMu5SBkNHmH4rFaUN/mgChgM5P8CWFMRnVd4ahFs24NonlIt
	 6N5PIC6mdzEpSpu80VKjw0S471r3ve1pyq2zdmE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 048/201] regulator: s2dos05: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:46 +0200
Message-ID: <20260515154659.575552307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ebe694d67f159899b063eee61bacda4cb825ed7b upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bb2441402392 ("regulator: add s2dos05 regulator support")
Cc: stable@vger.kernel.org	# 6.18
Cc: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/s2dos05-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/s2dos05-regulator.c
+++ b/drivers/regulator/s2dos05-regulator.c
@@ -126,7 +126,7 @@ static int s2dos05_pmic_probe(struct pla
 	s2dos05->regmap = iodev->regmap_pmic;
 	s2dos05->dev = dev;
 	if (!dev->of_node)
-		dev->of_node = dev->parent->of_node;
+		device_set_of_node_from_dev(dev, dev->parent);
 
 	config.dev = dev;
 	config.driver_data = s2dos05;


