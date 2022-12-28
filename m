Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728A91C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E863AC433D2;
	Wed, 28 Dec 2022 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244830;
	bh=yEZa6B1TZCsRS5KFKARCago1rBoKBQG73bW/2H4Z+v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrWMlrJUZz1Hgkl3AkUumuLBWv2JOnmOr9KLZ+JLAuhh8OicFVfVyptrw5vouOQjV
	 +UWDAa3mqW7+loWBrD1FJDa6IjU0R8pB49AFtObIYlVqNOCAewrsEih/UKLdrf+I+r
	 2LE12ygV+ok8zRU7jb6ow9Dt9NHrTMYZZVymWWIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheyu Ma <zheyuma97@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0743/1146] i2c: ismt: Fix an out-of-bounds bug in ismt_access()
Date: Wed, 28 Dec 2022 15:38:02 +0100
Message-Id: <20221228144350.329736920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 39244cc754829bf707dccd12e2ce37510f5b1f8d ]

When the driver does not check the data from the user, the variable
'data->block[0]' may be very large to cause an out-of-bounds bug.

The following log can reveal it:

[   33.995542] i2c i2c-1: ioctl, cmd=0x720, arg=0x7ffcb3dc3a20
[   33.995978] ismt_smbus 0000:00:05.0: I2C_SMBUS_BLOCK_DATA:  WRITE
[   33.996475] ==================================================================
[   33.996995] BUG: KASAN: out-of-bounds in ismt_access.cold+0x374/0x214b
[   33.997473] Read of size 18446744073709551615 at addr ffff88810efcfdb1 by task ismt_poc/485
[   33.999450] Call Trace:
[   34.001849]  memcpy+0x20/0x60
[   34.002077]  ismt_access.cold+0x374/0x214b
[   34.003382]  __i2c_smbus_xfer+0x44f/0xfb0
[   34.004007]  i2c_smbus_xfer+0x10a/0x390
[   34.004291]  i2cdev_ioctl_smbus+0x2c8/0x710
[   34.005196]  i2cdev_ioctl+0x5ec/0x74c

Fix this bug by checking the size of 'data->block[0]' first.

Fixes: 13f35ac14cd0 ("i2c: Adding support for Intel iSMT SMBus 2.0 host controller")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ismt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index fe2349590f75..c74985d77b0e 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -509,6 +509,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 		if (read_write == I2C_SMBUS_WRITE) {
 			/* Block Write */
 			dev_dbg(dev, "I2C_SMBUS_BLOCK_DATA:  WRITE\n");
+			if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
+				return -EINVAL;
+
 			dma_size = data->block[0] + 1;
 			dma_direction = DMA_TO_DEVICE;
 			desc->wr_len_cmd = dma_size;
-- 
2.35.1



