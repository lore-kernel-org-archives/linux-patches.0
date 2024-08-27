Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4EA1C6F5B;
	Tue, 27 Aug 2024 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772364; cv=none; b=AQVDOStjELyuj5CEEa0VtQr7btnHowLmB2HJ0EN1gpwHS+BxzOmuWEWiDOkCT4W8FRIiJD+I9QR0E25TjXUDxu7Pp6Cdiz+5HrOKKH2Gw2AFlTEfoG2a/CRl5Q7TYJRk6SzDuW1JMSTEU7MUcM67F4XoG+eu18WFeBcb0Caug6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772364; c=relaxed/simple;
	bh=WpOxcvVg0XTLq9mKjBH4zYCl/iMI6Iofd1fTM/MCM8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPWMow1tdJEid0aHvYX4guRlhw+e0LaB1LVj/NBxs1TBPjQTModTwVAss2szB6Nr9wqxnfHqmPqEDGvC+4QwTp2+/C3EDhjtKkQW1nCSk+lRHvMVIjZ0byPxZLt7BWd/rPEwT+aDEtORyg3/WIWFChFw0XMDt9tJAp7NA03o6lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk5dW6cE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk5dW6cE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED8FC61071;
	Tue, 27 Aug 2024 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772363;
	bh=WpOxcvVg0XTLq9mKjBH4zYCl/iMI6Iofd1fTM/MCM8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk5dW6cEcltkESqIJ5+0vBDupOWu4LDdKps+LfmzwHjW2dpdWoEgpnJ8fR9Mr8X9q
	 GQQ+FYjLlKHHK11gQoGk/HFKpyDeBE7twiXmqug3nyQ+Xij4M+A46DQ8LMiT+1XxLk
	 BsW9sLVU+zlSkW4tHGcXp5FGzn7j+nhfHNCZ1Ils=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/321] rtc: nct3018y: fix possible NULL dereference
Date: Tue, 27 Aug 2024 16:38:20 +0200
Message-ID: <20240827143845.540280232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit babfeb9cbe7ebc657bd5b3e4f9fde79f560b6acc ]

alarm_enable and alarm_flag are allowed to be NULL but will be dereferenced
later by the dev_dbg call.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202305180042.DEzW1pSd-lkp@intel.com/
Link: https://lore.kernel.org/r/20240229222127.1878176-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-nct3018y.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-nct3018y.c b/drivers/rtc/rtc-nct3018y.c
index d43acd3920ed3..108eced8f0030 100644
--- a/drivers/rtc/rtc-nct3018y.c
+++ b/drivers/rtc/rtc-nct3018y.c
@@ -99,6 +99,8 @@ static int nct3018y_get_alarm_mode(struct i2c_client *client, unsigned char *ala
 		if (flags < 0)
 			return flags;
 		*alarm_enable = flags & NCT3018Y_BIT_AIE;
+		dev_dbg(&client->dev, "%s:alarm_enable:%x\n", __func__, *alarm_enable);
+
 	}
 
 	if (alarm_flag) {
@@ -107,11 +109,9 @@ static int nct3018y_get_alarm_mode(struct i2c_client *client, unsigned char *ala
 		if (flags < 0)
 			return flags;
 		*alarm_flag = flags & NCT3018Y_BIT_AF;
+		dev_dbg(&client->dev, "%s:alarm_flag:%x\n", __func__, *alarm_flag);
 	}
 
-	dev_dbg(&client->dev, "%s:alarm_enable:%x alarm_flag:%x\n",
-		__func__, *alarm_enable, *alarm_flag);
-
 	return 0;
 }
 
-- 
2.43.0



