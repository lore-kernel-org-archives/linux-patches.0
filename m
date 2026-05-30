Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A43112C1;
	Sat, 30 May 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164461; cv=none; b=gsbWq/zFBpQp33zJyZFDzJcVz6Vky8JGx66Raxut0XcMDH+n7PZbUgCPTg9he9dyf5JfOTpLgATPArReRPLar1HbAIjQbqFalQu6mzEsIW59gIKEdeN8+7ToegQFSih1QRVEI3iYcxjEreMhtngcspfb6qg9KlADTWE5HPujrhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164461; c=relaxed/simple;
	bh=rJg7C1RiADfb+hoSoyEFKcQawYTj9IPwbpGMqcj9l3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDjup1SBrzD95yik0HCseXM0kIKNuLK9N+zaBdXLiL7bNGfsGgAjRJVfmsW4qFDvMS+odt3iXdIAe8yY1obOfOQS3Y7OFPvliZ7eiLCh7tdqpHlLr19MAMwmAq+7aN2VTJ2fVg+8EIl/7x51qeLHdDy8GnNRLOtnsmYXQZPUvIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAzGzDSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAzGzDSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A480C1F00893;
	Sat, 30 May 2026 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164460;
	bh=YKJnZcDa+BTfFSU88iT2w4qGMkkOmcg2R4b6zf3Zckg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAzGzDSi8ZGq0r3omEgQTv4MdvuSy9CNdKmGqMqDR5F+KG6u4S+VBPkI5Cy69Podo
	 50diyktMJF+c2GZNRiQwGIQp6/6ZceUUNeUvYz2T8M50+gG3N6Fz+j9fuu/pAM7N91
	 YrpB8v9QXZUnUWmOpGAcdWW5wjNDpOt1//wScWU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 523/776] backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()
Date: Sat, 30 May 2026 18:03:57 +0200
Message-ID: <20260530160253.745835081@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 797cc011ae02bda26f93d25a4442d7a1a77d84df ]

The devm_gpiod_get_optional() function may return an ERR_PTR in case of
genuine GPIO acquisition errors, not just NULL which indicates the
legitimate absence of an optional GPIO.

Add an IS_ERR() check after the call in sky81452_bl_parse_dt(). On
error, return the error code to ensure proper failure handling rather
than proceeding with invalid pointers.

Fixes: e1915eec54a6 ("backlight: sky81452: Convert to GPIO descriptors")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260203021625.578678-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/sky81452-backlight.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
index c95e0de7f4e70..0cf1f588a3873 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -204,6 +204,9 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 	pdata->dpwm_mode = of_property_read_bool(np, "skyworks,dpwm-mode");
 	pdata->phase_shift = of_property_read_bool(np, "skyworks,phase-shift");
 	pdata->gpiod_enable = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->gpiod_enable))
+		return dev_err_cast_probe(dev, pdata->gpiod_enable,
+					  "failed to get gpio\n");
 
 	ret = of_property_count_u32_elems(np, "led-sources");
 	if (ret < 0) {
-- 
2.53.0



