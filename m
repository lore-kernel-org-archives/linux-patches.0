Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE934BA42;
	Sat, 30 May 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160620; cv=none; b=t6LoJ0DmhsI++4CXpGRclxsm+I2YXG6y+BACAVSIMayxLSb2yem3s9nvHGU98opIKz6KWhzwg65yaFbrQFkNrnxWHhpkOtTPJks+XVkCF5pR30X9km/KzSARPzEGx52jinFs1KxtHEML+o5+FVGe5gUOBCj1TcyN3vXTj1xmDJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160620; c=relaxed/simple;
	bh=j+NJ6s3tSg53oykHm1sZn1DO+sb9M/tx8VxkiEupR7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3dByLez7Hn4zIvGWPcIbykjsoyzJb45E5JuHW8PlA4cbJq6urVY0Chq8NVWKYOK8AdMx+KbCazRsPN8H6uj2itnRy9QvwpJ5WXBgtBtEw4IdohY9TwVeFW1X2PmO96p5bSYBS74OjZzKBSI9DW8Hfoj22QklFV6XFDOA25hzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ht9XF/bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ht9XF/bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835601F00893;
	Sat, 30 May 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160619;
	bh=1ZIzXkGx7RvYTFanJatjfw0WcFOWy8GKQunXnkl6KkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ht9XF/bJOhn74ypXs2z+uABuaUtNY6IlthnEUA+tE2yzLhMc/HaksJS938lzd65AC
	 pCpJT3Vnr+fapnsKBWq/1QZZ2hXhUgeYQuCZOkwe7nCvTXetnWhXWpDjcq3FgBQbGd
	 aUuvcuoiFN/M6OVNRypXAowbBWTaDQwN26EBCBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 387/969] regulator: max77650: fix OF node reference imbalance
Date: Sat, 30 May 2026 17:58:31 +0200
Message-ID: <20260530160310.995198664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


