Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ACF2C3268;
	Thu, 15 Jan 2026 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498354; cv=none; b=TftTAIseig/HknUOjh4yOZ45Y8XrDjSONszPlEEfhrqaMYRHKbWcklA05yfP/7tgLzeQE7b2BpOQ1vofwCf4eAotH8tPzvG3hsIya2KSVN3x7AvLTc65t+s1HyeOCt1cL0ozjZOhHuiuJWAXLXNn+PyE0FLSjDDeP/UOUE6g5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498354; c=relaxed/simple;
	bh=tYSOfI+DyG3jRVLV1DKmuloYlEvlRnvkTJeHqgx4udA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5PBUo2Swb7tnEiufX7uoS0x4/i1lOBzenuCoBOtO3bzWTshLkxRpgBdSYuQzZ06yomUWh9UXjecEbBqDOIUDFyWCJgvIwvE/laPqoU5z6lua5RRWj2N3L9S3TI29csJyXLcpv0bcqBdTRJSesCW7mHiQHYLGlcCRfT7D4BUG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibDsVkEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibDsVkEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A56C116D0;
	Thu, 15 Jan 2026 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498354;
	bh=tYSOfI+DyG3jRVLV1DKmuloYlEvlRnvkTJeHqgx4udA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibDsVkExL76VAT0+QXmMcwSrOxrpMYkV1Cpg2OLUU02mIsg2GSgcil72xAAlauL3R
	 mn2lB3VNKLBAUosLK4hcZSkGg2ZcgES+ABvLMIKcz2KJX6BspnN2VZsqhmKbo1XtAR
	 h7aeLIfxIlMrWpirtkBFt4lRsKQHTSvCsPRmjygk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 385/554] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Thu, 15 Jan 2026 17:47:31 +0100
Message-ID: <20260115164300.173907157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

commit ccb7cd3218e48665f3c7e19eede0da5f069c323d upstream.

Make sure to drop the reference taken to the sysmgr platform device when
retrieving its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: f36e789a1f8d ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
Cc: stable@vger.kernel.org	# 5.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/altera-sysmgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -118,6 +118,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


