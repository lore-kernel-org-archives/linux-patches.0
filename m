Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7786168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34FC433EF;
	Mon,  8 May 2023 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542723;
	bh=4S/srffhV1mIQsLapYZjHLDyz6IiA/CbjfmqvO9V1GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jziv1sWiFVbdeO3NZK0+6B7FX7+aRChfKfT52ROppyUoS/Y8ovpDaTlSJVRu0VieJ
	 SVBguR+SEZGxriG0hzerjzwAdjgKkGJh1x2hrmJmOLZjyHUSI/TiBHf7hu5Rh8nN8n
	 ePsbCuZVZKdF3gQYwvh+SLD0RN/9iJsSFOVkdXaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 486/663] i2c: xiic: xiic_xfer(): Fix runtime PM leak on error path
Date: Mon,  8 May 2023 11:45:12 +0200
Message-Id: <20230508094444.163606851@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit d663d93bb47e7ab45602b227701022d8aa16040a ]

The xiic_xfer() function gets a runtime PM reference when the function is
entered. This reference is released when the function is exited. There is
currently one error path where the function exits directly, which leads to
a leak of the runtime PM reference.

Make sure that this error path also releases the runtime PM reference.

Fixes: fdacc3c7405d ("i2c: xiic: Switch from waitqueue to completion")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index bee5a2ef1f229..2bf3713b1969d 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -704,7 +704,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	err = xiic_start_xfer(i2c, msgs, num);
 	if (err < 0) {
 		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
-		return err;
+		goto out;
 	}
 
 	err = wait_for_completion_timeout(&i2c->completion, XIIC_XFER_TIMEOUT);
@@ -722,6 +722,8 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		err = (i2c->state == STATE_DONE) ? num : -EIO;
 	}
 	mutex_unlock(&i2c->lock);
+
+out:
 	pm_runtime_mark_last_busy(i2c->dev);
 	pm_runtime_put_autosuspend(i2c->dev);
 	return err;
-- 
2.39.2



