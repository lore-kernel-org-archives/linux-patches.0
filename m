Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794B51E22E9;
	Wed,  7 May 2025 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644886; cv=none; b=V7v0q30zBhCAc0suK4Dv3tosQceJiOLxaEWGpHaiMNDHs3Sa+CUJoHQAkOTqsAYw5ondGkocHSRw428uknnUAnU0eqPYMxoKTAGHADnwQKrNx6e9TkbbDtlIfiAqQ7LaBKMHxsruiYTEoQ7Xr4ssD/oXin9P/kCI1JpeOcrTpek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644886; c=relaxed/simple;
	bh=Uxx214dk3GKIIn0AlcgdlodijhwRg3afQ+BfPndaRO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPZVuyFjP/jTbbbhl+7K8NiYilfwiGvf7jjTZqnKELVgm0xL7L3a57XNTaBXwWuDva8gbNhVk3GOPUBfLqPVJjb03Sh4s0D2xgUnfWqgKV6GgzREQimiLxNWVwX++zDEVE2N7Shz/XUTvk6V4C75zWzArGkgcW/MqGP83XmeNb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/Wn4tz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/Wn4tz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C92C4CEE2;
	Wed,  7 May 2025 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644886;
	bh=Uxx214dk3GKIIn0AlcgdlodijhwRg3afQ+BfPndaRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/Wn4tz7DCfZxnwuvk00MqdsCXFVwnmMXPYSxaOl/HLeobN3zAURWgA+ZHWR17ev6
	 H2M0C/J39XohZ1SpT9RQxDN2dXe44frsk+aLfykVk2rjyHspfHlAJ5Y4RRzsDc51ov
	 p6Kt3swPiHIvE6R82FhSdimXPOiqV//gXITSo58s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 009/129] i2c: imx-lpi2c: Fix clock count when probe defers
Date: Wed,  7 May 2025 20:39:05 +0200
Message-ID: <20250507183813.912663970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

commit b1852c5de2f2a37dd4462f7837c9e3e678f9e546 upstream.

Deferred probe with pm_runtime_put() may delay clock disable, causing
incorrect clock usage count. Use pm_runtime_put_sync() to ensure the
clock is disabled immediately.

Fixes: 13d6eb20fc79 ("i2c: imx-lpi2c: add runtime pm support")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v4.16+
Link: https://lore.kernel.org/r/20250421062341.2471922-1-carlos.song@nxp.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -616,9 +616,9 @@ static int lpi2c_imx_probe(struct platfo
 	return 0;
 
 rpm_disable:
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }


