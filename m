Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA46E320CAD;
	Sat, 30 May 2026 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163765; cv=none; b=Z19Tl+f+T7gxTTPEeWzrXDqnvakkGQlcLXZbPNb/NuvxfbFJ3owBi25uSQ85DrpUwM9iVtKotIORvrBhVEhYdCP4HBOV+XqO62l4/2UMak8mx5qBaEqhYmBWLcjGE7ZhfYG1I1UjLUByZOM6na4KRPEvYrlc8HC6s/fKFb9jVJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163765; c=relaxed/simple;
	bh=QIh08nLp8MQD3iPzKhGxa+OeNffFaY3CMhnuVZfeYrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4v4+HYyKSPhL7jEpfl0P6Sf52+AuNPXHlY59FD4rlBxWqQ0SXHxYKF4/CZ3XXG9uPpEmAW0Ytm1TFhNYCndSZ7wXX9NF6c3nEjV5KoCvHPY35cCuKTRnLlrMkgfNd2jvj7eK8b1hhbrrH1/+w/DLJcIrjpl3Ry9YnnMwofd4pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGN87XaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGN87XaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0E41F00893;
	Sat, 30 May 2026 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163764;
	bh=gla8xJIS7vCvCxrqbhwp3BIIq/QOhC/AjUPM9WH2HlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGN87XaYENoLG8LYgDHVtLekPrnNYp0ftPJim2M14zOufc1Iiy7dZN0+xyiN7RAq8
	 jzmfomVtAb6nzbBJS7fb46Mj9g7+d1QnYAcrM0bOgVY3xwli9Nx151+cMhQncWbRJE
	 cmtSR1idA3Eik/1cBSF9nJ57f0xRobUKz9U1HkDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 354/776] regulator: max77650: fix OF node reference imbalance
Date: Sat, 30 May 2026 18:01:08 +0200
Message-ID: <20260530160249.731125827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2edaf5f7ada0ab5c9ec1f0836bd19779a8d85262 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bcc61f1c44fd ("regulator: max77650: add regulator support")
Cc: stable@vger.kernel.org	# 5.1
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77650-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77650-regulator.c
+++ b/drivers/regulator/max77650-regulator.c
@@ -339,7 +339,7 @@ static int max77650_regulator_probe(stru
 	parent = dev->parent;
 
 	if (!dev->of_node)
-		dev->of_node = parent->of_node;
+		device_set_of_node_from_dev(dev, parent);
 
 	rdescs = devm_kcalloc(dev, MAX77650_REGULATOR_NUM_REGULATORS,
 			      sizeof(*rdescs), GFP_KERNEL);


