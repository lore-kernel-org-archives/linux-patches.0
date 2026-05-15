Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D643F928A;
	Fri, 15 May 2026 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861908; cv=none; b=RTHzduLQCvX1/PM0/coVkc3AxY+Olt0IAOvJl/fKKLYrtFvYYmTQgoT1Iyw6JR88S3dh3RLwHAAtx46a0lm5GnjVtkfb1zuTnt+40Z8aQaoiSOiiNEsSEvZIwYE6Tajfsx5BIa2GmF7zWnYOnURGFzIAAqwJBdfgCzl1QdSgmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861908; c=relaxed/simple;
	bh=uDEX9gpVioIhwndkFLUISbOSIPdGFmQ6YaJvU9RhIbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiCxoFxXMPiQNYOSf8++NIDzxisc3jPszxMn8beoAnWJYJlH9g/5fzVpP88nzxcx9A0gV/X0rl1GtZjLnsx5z2uGdwyBXIH/Ko1std5LvCepo/B5SLTdQGEstumjYUCOd7+k7OKT8lE1vB+fFXAzmBn5tCkDrJ+9M9Pm27qZRZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhU7ju/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhU7ju/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FFAC2BCB0;
	Fri, 15 May 2026 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861908;
	bh=uDEX9gpVioIhwndkFLUISbOSIPdGFmQ6YaJvU9RhIbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhU7ju/GwIIOiQX4Ihbx8nZlqzmIBELTpHs6gynVy6RH8x6hfc95n1apjMvZIytGP
	 hn9mKuPPUA0db1TcrZKjVR+AXgNxpR72IZgoiRgFVPjfHxWE/xJP3B9EyaBiawztfZ
	 uV08fe3J8SqwvwX3fu7CcH1eWs6fb7tgtAw/dTRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 035/188] regulator: s2dos05: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:32 +0200
Message-ID: <20260515154658.070146884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


