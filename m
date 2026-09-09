Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6F357D226;
	Wed,  9 Sep 2026 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964049; cv=none; b=fIqDO52Em/TSjqUxCLut+ywR4ODOapfuWDR7Gkk/5ALg4Vy6/6pc2/ytua1NjgZ6n7P7agSWxDhfivRiDaMPFgDFKJBWz7YZy1lGycsPYZYISD3m9L3R0IclATZLDCplO+EFH6/+BpGB5X7WGzfMHsNdMAOYYQRnWOBufQgW9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964049; c=relaxed/simple;
	bh=h3H8VFj8MZiZkWPdNvAynvoKa9hvTTmLmwEvoJ8XdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P989ckVlhH1RCVGDz1HQ/sz1wbwlPfmG6q04LhTr9R7ogbcrzhlzF7mZGjNYLQUZuSXb84smGPJRZ6Pq7WdB+RhKchD/oc8Hk1g4yF6BQfGyVFVwnMXZSdobVHncGBxA/JgpoIyz3AA/JYygFxxWYWCMGGoyarVnIjfc5N2XaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjvhj5zd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjvhj5zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28C11F00A3D;
	Wed,  9 Sep 2026 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964048;
	bh=ebXE7R3MJLcX7WbrFi9Cj8LnWA4avmKal4f+GqCbQqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjvhj5zd83vdTYWUizAw9NQjbhjt62lLjG8yLrqWspa+TXSGpaU1iykKZaetuPagn
	 n6p1/8fk4NidR7vapaMLNtWDSHvFL3V5Ymvd6qGDrrMB+Sk1V88ZUtHECvvY7w2IFR
	 XP8eNzZVyO3SX/qgSDTR9Yes4tC40AvNsn5luqVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 289/583] media: i2c: imx415: Release runtime PM reference on VBLANK error
Date: Wed,  9 Sep 2026 15:39:34 +0200
Message-ID: <20260909134248.052852931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

commit bea3001e0f32527a291444e527e84a7ea9b546d4 upstream.

The VBLANK path returned immediately when programming VMAX failed after
pm_runtime_get_if_in_use() had taken a runtime PM reference. Break out of
the switch instead so the common pm_runtime_put() path is used.

Fixes: 3bcae55ab96a ("media: i2c: imx415: Add read/write control of VBLANK")
Cc: stable@vger.kernel.org
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx415.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx415.c
+++ b/drivers/media/i2c/imx415.c
@@ -720,7 +720,7 @@ static int imx415_s_ctrl(struct v4l2_ctr
 		ret = cci_write(sensor->regmap, IMX415_VMAX,
 				format->height + ctrl->val, NULL);
 		if (ret)
-			return ret;
+			break;
 		/*
 		 * Exposure is set based on VMAX which has just changed, so
 		 * program exposure register as well


