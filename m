Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD0714AD2B;
	Tue, 27 May 2025 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366839; cv=none; b=ot6T9gRkQY8MW0I8OFwOMgwNNfKx1atuewlazx8tFb0n0aK9fpewPjMNE2I5JL3SL2aT9tHuvZhbz/FKr4x2WbFE36uPWj8haweWk1nv5FT4np/6JfYqegMoFjy3RyPgdvTJt3rR9ui5/EgVsWBFZhIqnigt8HjFju2uhioJFPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366839; c=relaxed/simple;
	bh=j804xBCP1NeUmj5wkJEZteR5cBNEdyq8s1qkCuXnzl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNtz+5UWV1AUV7DqjNMmmV2y2GUgU8Jr1Qu1ISXFxTa2X34k++ykHItXDwkUhnoGSUEPPsSoTuIg5f3itbmwxE5Up7cXTfeldfQa7TrL3Pw/Zzu+Um9aDwKkfj1a1+NszhO8y3rKT1y3t9bf1B9fn+tWWY0fNQIt/tpCW5rdwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of1AiQzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of1AiQzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64465C4CEE9;
	Tue, 27 May 2025 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366836;
	bh=j804xBCP1NeUmj5wkJEZteR5cBNEdyq8s1qkCuXnzl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of1AiQzCfGaUSx3ttTWtMW/7E+lSYtuv1oEUgki7FQr5ArF2HppBKFhIyqojrubHr
	 p3uhV+/8yzPRPhVeQb9OiAa9D02J2nSUOUSRo6zmiTgHkDfTzukeK6VFUYWFv5ygRR
	 ljOhR1PDLG30mTy5NbeWMjpO5iAW3rRKpOFK4aBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 193/783] leds: leds-st1202: Initialize hardware before DT node child operations
Date: Tue, 27 May 2025 18:19:50 +0200
Message-ID: <20250527162521.013411822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit a17d9e736ddd78323e77d3066c1e86371a99023c ]

Arguably, there are more chances of errors occurring during the
initialization of the hardware, so this should complete successfully
before the devicetree node's children are initialized.

st1202_dt_init() fills the led_classdev struct.

st1202_setup() initializes the hardware. Specifically, resets the chip,
enables its phase-shift delay feature, enables the device and disables all
the LEDs channels. All that writing to registers, with no input from
st1202_dt_init().

Real-world testing corroborates that calling st1202_setup() before
st1202_dt_init() doesn't cause any issue during initialization.

Switch the order of st1202_dt_init() and st1202_setup() to ensure the
hardware is correctly initialized before the led_classdev struct is
filled.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Link: https://lore.kernel.org/r/CWLP123MB54731877A8DC54EDD33F0229C5C22@CWLP123MB5473.GBRP123.PROD.OUTLOOK.COM
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 4cebc0203c227..ccea216c11f9b 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -350,11 +350,11 @@ static int st1202_probe(struct i2c_client *client)
 		return ret;
 	chip->client = client;
 
-	ret = st1202_dt_init(chip);
+	ret = st1202_setup(chip);
 	if (ret < 0)
 		return ret;
 
-	ret = st1202_setup(chip);
+	ret = st1202_dt_init(chip);
 	if (ret < 0)
 		return ret;
 
-- 
2.39.5



