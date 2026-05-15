Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3199C3F8713;
	Fri, 15 May 2026 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861206; cv=none; b=tcDRR5KCVb6l+d+Vkb6uEuHlh+ulRtjY82tG6HI5jvC23VhKqPn/cYVehgLC3DWlIDQRmXLWpJ+vYlR5mJ/ZbFCedI+u9OcrnyafmQQBEr3ZqZ28R22+xThRqmxMvbZUA+v0a3rvKyr5fmxli9wCLIIrOldCG5pFldS6frSVK28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861206; c=relaxed/simple;
	bh=2AFAPLE5wppAEAwUVVP6uX1stnv5RfY+XnYai2MjH+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoxwDX7nYxzSSC0GltqMXnHBi9KsgCUPbAvtMOczi1TsvbE5iHf0ORrljMsb2Q6rMq95FO0VABz1GVaZoLf0Mao9+KTTk4020nKUtWcxZ2jqMwrgWlZb2hpryjLY9yl66XVbzu2RC9Oui/ZJgG/oGhci7NFQz2qX81mHbih8nvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyZSvv7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyZSvv7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D878C2BCB0;
	Fri, 15 May 2026 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861205;
	bh=2AFAPLE5wppAEAwUVVP6uX1stnv5RfY+XnYai2MjH+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyZSvv7b7O4RTCHYHJK0ZljUGXiX4vKLzRU2R8Vr1/aAVLxVhJGzhEbq2GgbWjiP7
	 p9PYIJDWhhArcWwyUn9VwLHPwAPf4a2cHR4tVX3SyfrIxQR1ScaDuHPkS8yG9QTOh8
	 6YVZcTZ62/KjGeCCGGY3OrnEkrC4S04UUTev/aK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.6 238/474] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Fri, 15 May 2026 17:45:47 +0200
Message-ID: <20260515154720.152931667@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 83c0f9a5d679a6f8d84fc49b2f62ea434ccab4b6 upstream.

The temperature was never clamped to SPRD_THM_TEMP_LOW or
SPRD_THM_TEMP_HIGH because the return value of clamp() was not used. Fix
this by assigning the clamped value to 'temp'.

Casting SPRD_THM_TEMP_LOW and SPRD_THM_TEMP_HIGH to int is also
redundant and can be removed.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260307102422.306055-1-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/sprd_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -192,7 +192,7 @@ static int sprd_thm_temp_to_rawdata(int
 {
 	u32 val;
 
-	clamp(temp, (int)SPRD_THM_TEMP_LOW, (int)SPRD_THM_TEMP_HIGH);
+	temp = clamp(temp, SPRD_THM_TEMP_LOW, SPRD_THM_TEMP_HIGH);
 
 	/*
 	 * According to the thermal datasheet, the formula of converting


