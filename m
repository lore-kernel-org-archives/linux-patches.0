Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDEA1C6886;
	Tue, 27 Aug 2024 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770336; cv=none; b=RLDfTtR9j9Dt7WFhmEhUUrCDKCanhWPi/vh+h77oqUEkCUdmBWS958tEYs1YKYGsm+wHs1V/dwScNLBeIuYLbVEXBqspQKS8l2tJg6TlLBg1le203riT+7eS+R0758tmziTK/HfuriTNiJtdZ322dUekbrRG12UB7/ihOKvpgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770336; c=relaxed/simple;
	bh=yYdQyt9odB9qy0JuDVtkLJW9Q/S2bIPCxwZWnQvlilk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGFc+mfa5b1NLBS9tj6AhgqrbEw9/Ek2LdS4aNXFJGeWDunvepJcJ04tfRpSv67ksz4JjI9+A4U8eCYoo38dT2QOr/vsagTML0DizQtMT6dQHlqsDK9Le+12sZfmj58n5BUX4BKXy9phPaN7/mwzT0VPiiLciqQk9o+KTtwSI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx3TpmYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx3TpmYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC5C4DE14;
	Tue, 27 Aug 2024 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770335;
	bh=yYdQyt9odB9qy0JuDVtkLJW9Q/S2bIPCxwZWnQvlilk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx3TpmYg/tAu9Q8+E6MomlnQS+PzFSQGIdBKfXhuh+jMXS76RYPTeWXgYp57mGB0G
	 5kn3l3dfO61Yu6F8RuvgWUuOQcOyJOAgHKeRtecLgNGKkmYsiajBqxbt/FPeHLChNy
	 g2IvZJiK4NIyapDX+pHqEpKm+aYosippXBFIQ9uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/341] rtc: nct3018y: fix possible NULL dereference
Date: Tue, 27 Aug 2024 16:37:10 +0200
Message-ID: <20240827143850.986408370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed4e606be8e58..c4533c0f53896 100644
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



