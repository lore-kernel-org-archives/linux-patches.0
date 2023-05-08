Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E291168CD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB21BC433D2;
	Mon,  8 May 2023 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544841;
	bh=CFo7vj0dvZgKlw0T3SsVPw2pjTfqrzgH1yzJ2BDG+T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXVClF7pEVP7TZirNjhwauYD3spcbM9i9aBhj+PvlGi32ywl4xxkwBD8YpLQFHNME
	 z+3coqK48Plt87WQvg6RuqO2HgQoFRK1u7SDs8mdjqxGNL0A6RHwYXdd0dizjSyXny
	 LJd5ZeoonKimRVilJQIu92See0R6JdxUX3D2rs68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 539/694] i2c: cadence: cdns_i2c_master_xfer(): Fix runtime PM leak on error path
Date: Mon,  8 May 2023 11:46:14 +0200
Message-Id: <20230508094451.935345736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit ae1664f04f504a998737f5bb563f16b44357bcca ]

The cdns_i2c_master_xfer() function gets a runtime PM reference when the
function is entered. This reference is released when the function is
exited. There is currently one error path where the function exits
directly, which leads to a leak of the runtime PM reference.

Make sure that this error path also releases the runtime PM reference.

Fixes: 1a351b10b967 ("i2c: cadence: Added slave support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index b5d22e7282c22..982c207d473b7 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -827,8 +827,10 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
 	/* Check i2c operating mode and switch if possible */
 	if (id->dev_mode == CDNS_I2C_MODE_SLAVE) {
-		if (id->slave_state != CDNS_I2C_SLAVE_STATE_IDLE)
-			return -EAGAIN;
+		if (id->slave_state != CDNS_I2C_SLAVE_STATE_IDLE) {
+			ret = -EAGAIN;
+			goto out;
+		}
 
 		/* Set mode to master */
 		cdns_i2c_set_mode(CDNS_I2C_MODE_MASTER, id);
-- 
2.39.2



