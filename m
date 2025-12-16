Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06662357718;
	Tue, 16 Dec 2025 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886577; cv=none; b=bSFbBucG9JPBRdPExcm3YBekQ5cINPH/mDn7kYSYmOVMFLSYYqJEBXV5Q5l1ALooRNbeocRaOF2SpDE0JeHENKEH1RMUFv4a9nvn2FPva/uNoeD9DKGOhuddIS61lQNBBUNyvukWN1T7ouXAl9lBGCWTU2aorPQOafV/SdBugbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886577; c=relaxed/simple;
	bh=F2cIlpW7P/Co9QPc/wFFFuHU9GpoEug+50UVUf3WckU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JzWfHpPC3eIyybfkfbPlIl7AgHEqYK1rvB6oqS2FJ5o5KBXSCb9n7eHsDkf6sYSvqQsn0/Ox/qjd8YcZ/iVk0jhbmJIEsuuiqLzOlW+WVIdjkKTw/UC7Y/TkUsDd8fxjtGnRQZuys+5ibg9EoGUh0EfokfOfF8CE4hffkc3gD6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTuAN8gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTuAN8gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1889BC4CEF1;
	Tue, 16 Dec 2025 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886576;
	bh=F2cIlpW7P/Co9QPc/wFFFuHU9GpoEug+50UVUf3WckU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTuAN8gv8hHpDQ/wdTfkETHNg8d2w8Ieeg6w7Ugsy4oyG005WTPjifXQ1Sam0L02I
	 1qvWRQuq4dMpx0BV/HXWdQMVJ9nbhUAbF2FW22xFb3ovVhJxm/xrw/Botub+gP8vjB
	 AnljvXlOYH8Mmlo7R69fqSllcy56p71GNpVbhElI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 477/507] rtc: max31335: Fix ignored return value in set_alarm
Date: Tue, 16 Dec 2025 12:15:18 +0100
Message-ID: <20251216111402.723737254@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit f07640f9fb8df2158199da1da1f8282948385a84 ]

Return the result from regmap_update_bits() instead of ignoring it
and always returning 0.

Fixes: dedaf03b99d6 ("rtc: max31335: add driver support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20251128-max31335-handler-error-v1-1-6b6f7f78dbda@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-max31335.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-max31335.c b/drivers/rtc/rtc-max31335.c
index dfb5bad3a3691..23b7bf16b4cd5 100644
--- a/drivers/rtc/rtc-max31335.c
+++ b/drivers/rtc/rtc-max31335.c
@@ -391,10 +391,8 @@ static int max31335_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret)
 		return ret;
 
-	ret = regmap_update_bits(max31335->regmap, max31335->chip->int_status_reg,
-				 MAX31335_STATUS1_A1F, 0);
-
-	return 0;
+	return regmap_update_bits(max31335->regmap, max31335->chip->int_status_reg,
+				  MAX31335_STATUS1_A1F, 0);
 }
 
 static int max31335_alarm_irq_enable(struct device *dev, unsigned int enabled)
-- 
2.51.0



