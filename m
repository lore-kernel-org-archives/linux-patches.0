Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3153AC0FC;
	Sat, 30 May 2026 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163650; cv=none; b=ZVJMx1twakWyOXLIFNFf2gywafHd9Czw/WEDxuwDZKLgIeSILMWF8K4Q8mB7WsrBUERYOwQ5m924ckGRzR8ltrqFVgvtsmEn8R7f3187Io48PLOGVf//RGcOTnb3JiJjXnaUL9FMemUNcLmadfAxVydGg9xzG+B8MUNAFwHFnec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163650; c=relaxed/simple;
	bh=jnlx91KWtPPM1Pp5uYK4lCo7TvY5Zv3usfq/9kIXF80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auD5DOIzuKZcSWkaDJ7FsBCMysIljmR3A24JorNdnQF63XflmhmDGCVOqNTNfvMwuXIFQR3bbf865f2fowAvSJ+8WlNyB5LldgZggbq7x6tIZqFGyXHUbvbFhIPdhUYMN3f+Ol6mKGTmdyCjMBNWBcdHY8gIgXTwdv3XeJtkzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hD4E4HCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hD4E4HCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5B71F00893;
	Sat, 30 May 2026 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163649;
	bh=s54vcQJ3dcEq4dX8rg3S9fXBg80JSOQPYUpEgjA/L6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hD4E4HCzfAIh3hsLD38sPsiotvqTF3b7wfGDA7659E4ZxlYCswk96fZCO5C5liXGg
	 3wpo7o7NI6rBFn/SYOsWlEKrl/9XRNoSqeZmf8eu79OE+78zUyKsvCNMNxRF0nVkg9
	 D67X55hHCR+zpSiVyvjwrsUOJ34vpjb7PdHgkeLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 5.15 321/776] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Sat, 30 May 2026 18:00:35 +0200
Message-ID: <20260530160248.865323942@linuxfoundation.org>
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


