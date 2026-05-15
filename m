Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1358481A90;
	Fri, 15 May 2026 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861991; cv=none; b=KWHX23D5Cu1uCuqUWqSScoziwWxKHHX6EwRXjSJJADzNq18uNMIPs/AffRKzdXq/iBtvcKMbKDNsiORjLDJpsG7+49YtiqMayCbmXmK4ihq3Ius+JC+0mgo4D/37IswK9fA/fSa3QeTZuEl62KJHq/v+FV0cDds5CznNQ3KzW5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861991; c=relaxed/simple;
	bh=hR5+B5wuE60kJDTCPh9J51JACDJmFZzULKDlVDNB1Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5l77dvLmzRAdO+W4JJG5LHehy5ulXEA45tS1qWhcDdclzP2jVg30EwfVcFpugZh0CEMgPueYtNLKAY039L4bp54y6bn/Q8VkPQUXrX45VDE7y90alNwCb7yS1RbI3eFKef4uMtiUnrCuoezxCZLPTsYEi6Vru+h571Yf/z/+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwAUT5Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwAUT5Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A272C2BCB0;
	Fri, 15 May 2026 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861991;
	bh=hR5+B5wuE60kJDTCPh9J51JACDJmFZzULKDlVDNB1Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwAUT5IkyfcJSQf9t7Oc+h/SJRiT8GBykdlJwHAph1fkcA2B5nmjDFrdG2ZZQ+YU8
	 sYSOFV43Qk8BU3/ciAJBDVxRuSDx3CmUxkWVTy+uD07ty6FbjI2KalampnUoWm/nch
	 S8eSzQqRWvrFh98pNyBsCbt9KUZMoZDUqKPMNPjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 023/188] regulator: mt6357: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:20 +0200
Message-ID: <20260515154657.810730474@linuxfoundation.org>
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

commit 2f38e96c273e15f5e9f5d1fc2c0cbba703751602 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: dafc7cde23dc ("regulator: add mt6357 regulator")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/mt6357-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/mt6357-regulator.c
+++ b/drivers/regulator/mt6357-regulator.c
@@ -410,7 +410,7 @@ static int mt6357_regulator_probe(struct
 	struct regulator_dev *rdev;
 	int i;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	for (i = 0; i < MT6357_MAX_REGULATOR; i++) {
 		config.dev = &pdev->dev;


