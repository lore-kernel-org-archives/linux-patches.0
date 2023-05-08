Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D551549A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE83CC433EF;
	Mon,  8 May 2023 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544844;
	bh=g5jZBf2afxJLcb/RMC4bDnCYRo289mhVEgcH2tt+JJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hstH+xNO6S//nxrl+OVJ8gTbJssf6NjROBc0uOjVFN1ERCERMHal56POZRx1RCWOJ
	 ko5KBUY+aJNzacDyi5MeVvMDqSsdnjwL6uBiOip8aWpr4a0k8R0/qnXPRALJSsgkNq
	 +m80gYFEhFlcAdcPdU5iARqHEwA8Z4GJNtVPfjm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 540/694] i2c: xiic: xiic_xfer(): Fix runtime PM leak on error path
Date: Mon,  8 May 2023 11:46:15 +0200
Message-Id: <20230508094451.976989429@linuxfoundation.org>
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
index dbb792fc197ec..3b94b07cb37a6 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -1164,7 +1164,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	err = xiic_start_xfer(i2c, msgs, num);
 	if (err < 0) {
 		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
-		return err;
+		goto out;
 	}
 
 	err = wait_for_completion_timeout(&i2c->completion, XIIC_XFER_TIMEOUT);
@@ -1178,6 +1178,8 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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



