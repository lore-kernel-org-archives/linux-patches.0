Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3CA3B9D80;
	Sat, 30 May 2026 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163776; cv=none; b=eyTLQASItbFvqVO4CXQEpQGRMlN0zxuYrtdMyfJjLi0iRSkr5H032UE7sc+KQiMc1HwHb/z23iwCWE2T1aDKFpyQczKoJu4SYd+uB2Pb7r1kJ4hPhEuyzSgaPvXhVgAe04VR1pP5R99i8wxsWy5mXDjLj/f/RlDIDN27uteHUjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163776; c=relaxed/simple;
	bh=DzwwgwcZmftP2UI3r/kP+EXdCApaaOarJkgp07SoIlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyqTGMZwlcDIl6uZ9jkkEClpzRKIiqCDCInLt/GXqQg4+5aa6pJsCVzM+gIvFuOnwUEz/iVIPq+WngGlltAd+NnyRpcnFHOXPS4VzJV42PalGJBKcjR9933sMFVxbLbPuurb7+uTkisVEEWzZytBBsaz/LIJcCFGzra/GOvZo0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q93+SyMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q93+SyMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595E71F00893;
	Sat, 30 May 2026 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163775;
	bh=FT21sPruUvlCgc+hF/trBixde/2vKJU9giopyinD5RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q93+SyMIQ8Z92AOvxKBmWbZOpDTzXm8SQMpR0QalwtiLf6p/ATCJIzTPunVv4ftzG
	 3JqSr+jt1jvICucaATdCtY5t/9AT8uHrfDeEatfwwS7a5CuTsxYA6KgEqkuDKzdwbd
	 eU9J82/8SP1xYs2wvXVgHRcf+HCsyw7wczMqPhvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 357/776] regulator: act8945a: fix OF node reference imbalance
Date: Sat, 30 May 2026 18:01:11 +0200
Message-ID: <20260530160249.807316174@linuxfoundation.org>
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

commit 0d15ce31375ccef4162f960b34547a821b7619d2 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 38c09961048b ("regulator: act8945a: add regulator driver for ACT8945A")
Cc: stable@vger.kernel.org	# 4.6
Cc: Wenyou Yang <wenyou.yang@atmel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/act8945a-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/regulator/act8945a-regulator.c
+++ b/drivers/regulator/act8945a-regulator.c
@@ -302,8 +302,9 @@ static int act8945a_pmic_probe(struct pl
 		num_regulators = ARRAY_SIZE(act8945a_regulators);
 	}
 
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.driver_data = act8945a;
 	for (i = 0; i < num_regulators; i++) {
 		rdev = devm_regulator_register(&pdev->dev, &regulators[i],


