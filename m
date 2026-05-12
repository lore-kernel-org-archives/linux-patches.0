Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FD21FF21;
	Tue, 12 May 2026 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607965; cv=none; b=bhpuz/nm38w7Dj3QZcXhRNIqO2OqhWju1LNr9WD4xgyIITaOBNAIB/yFAS+ZyANrW/Sms3+unBdg0yaDi8+9vcGv2tOC/qHDAN2KbV8eEvxSpqvwKwew3SF+qqylaI6xL0looHYeFQ51oP8PwfwI4ciwFQeczT9poin9EU7AGw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607965; c=relaxed/simple;
	bh=QUUJhPu8rUVQz7TVRHVnFW2VlrrwUbCpOLLmM1ZNQjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWmqb5G37Gx6V/Z1fKg9YjJ5MPGUBmmV3eKX1l5EKC0U6sDvho94Vv2PKIY4r4vUWieXgoaI9v2FWdOqCf1kc/iRnpiUEDYhPrlTpe+V1AakUH0IAasZq5OQt2hStjdRA66OzrrcNEDcxT3nVHexgaEflILcLph8ujlVYaCJhvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ouee5pnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ouee5pnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96755C2BCB0;
	Tue, 12 May 2026 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607964;
	bh=QUUJhPu8rUVQz7TVRHVnFW2VlrrwUbCpOLLmM1ZNQjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ouee5pnbtG9iOveye9LInKJtvFU8bihhnHigjN/M6hlfaBp2SaIyxQnQ1cSLcMJak
	 9CnnPcfPgfhBNNWiKqfMwe5oeMcv+yOX0a2cgalw2vH4KFdUmUXzWm5m48ZuZD/ff4
	 HXKKgTSJAV+DffXayRzsl9nCh/NwyzneY/ffGmRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.12 102/206] thermal/drivers/sprd: Fix raw temperature clamping in sprd_thm_rawdata_to_temp
Date: Tue, 12 May 2026 19:39:14 +0200
Message-ID: <20260512173935.017417376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit b3414148bbc1f9cd56217e58a558c6ac4fd1b4a6 upstream.

The raw temperature data was never clamped to SPRD_THM_RAW_DATA_LOW or
SPRD_THM_RAW_DATA_HIGH because the return value of clamp() was not used.
Fix this by assigning the clamped value to 'rawdata'.

Casting SPRD_THM_RAW_DATA_LOW and SPRD_THM_RAW_DATA_HIGH to u32 is also
redundant and can be removed.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260307102422.306055-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/sprd_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -178,7 +178,7 @@ static int sprd_thm_sensor_calibration(s
 static int sprd_thm_rawdata_to_temp(struct sprd_thermal_sensor *sen,
 				    u32 rawdata)
 {
-	clamp(rawdata, (u32)SPRD_THM_RAW_DATA_LOW, (u32)SPRD_THM_RAW_DATA_HIGH);
+	rawdata = clamp(rawdata, SPRD_THM_RAW_DATA_LOW, SPRD_THM_RAW_DATA_HIGH);
 
 	/*
 	 * According to the thermal datasheet, the formula of converting


