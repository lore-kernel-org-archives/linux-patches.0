Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5D3F9273;
	Fri, 15 May 2026 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861211; cv=none; b=Pw2YHu1ebETTMWa8DmsrgB7vBLxRpLt2SiS+xvdHv1qTj2q3DJdSJrpbxpivL6rqKkantSK0q4OHFyUz0TfNqkwitU1GfCazAC/0mamllrt+fdEbWgrR4T2bb1qNVMNlKJ3b92lP1281+dYoLDn1b1Pjb6m084PRZl1ZMjonqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861211; c=relaxed/simple;
	bh=ZawA0ehsSpJoeh0lU2gWU/s489p0le5bi/NiksHExhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfPyk029CnHRa/SS6XdAKQGN2XDtfefCvkRYQLiAPCTvP9Ki26eatYDDSYcakbpxuHsdTYNhOMN5GdnBJTS4RRrHNN0SBEsVGgB4GfcYfbFTsT7IMhhLI5UbwZwwgn0RLYgLbYMKyEI3+qeN9XsoTxRj2v2hFuxW+F6TVuv2tZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzBrD+/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzBrD+/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9230C2BCB0;
	Fri, 15 May 2026 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861211;
	bh=ZawA0ehsSpJoeh0lU2gWU/s489p0le5bi/NiksHExhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzBrD+/3EDTBodb7EtHbyWS6cQ3napAuH/FEZhy9VlKZQ0yYM/VXOdq4TOWCNYuGx
	 Zr5UWyU2f610WOtw3RnSttdsRpTWFvk9UDQLy/IXOzOVLNCCCflZ2mr+NoHBbmVbUX
	 qYWYfBVzFKOMM1IaWE7e1DVD6DvjAxaPHzbC/TWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.6 239/474] thermal/drivers/sprd: Fix raw temperature clamping in sprd_thm_rawdata_to_temp
Date: Fri, 15 May 2026 17:45:48 +0200
Message-ID: <20260515154720.174174882@linuxfoundation.org>
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


