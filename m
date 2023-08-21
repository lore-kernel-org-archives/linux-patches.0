Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5161171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A754C433C7;
	Mon, 21 Aug 2023 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648261;
	bh=pttqQ/0WbCn8Qml+TJldwvScqw4GaD2XATDkNva+nsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlakKPK0Adc2C/skViF/zUwOqBToA9Rq5XZYbtaRGsThziEHRnseve1YfgJZ1qZXU
	 7QeORlLu3U7oKHFcwbn3NnhydbViJpzM07n2C/OmFqwJsAadgzUqmj14YVd6joSZAa
	 gPtI9syrj6AF9VNgXyrY2S3js6iqP1oyXFT5vpWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tam Nguyen <tamnguyenchi@os.amperecomputing.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.4 112/234] i2c: designware: Correct length byte validation logic
Date: Mon, 21 Aug 2023 21:41:15 +0200
Message-ID: <20230821194133.763339335@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quan Nguyen <quan@os.amperecomputing.com>

commit 49d4db3953cb9004ff94efc0c176e026c820af5a upstream.

Commit 0daede80f870 ("i2c: designware: Convert driver to using regmap API")
changes the logic to validate the whole 32-bit return value of
DW_IC_DATA_CMD register instead of 8-bit LSB without reason.

Later, commit f53f15ba5a85 ("i2c: designware: Get right data length"),
introduced partial fix but not enough because the "tmp > 0" still test
tmp as 32-bit value and is wrong in case the IC_DATA_CMD[11] is set.

Revert the logic to just before commit 0daede80f870
("i2c: designware: Convert driver to using regmap API").

Fixes: f53f15ba5a85 ("i2c: designware: Get right data length")
Fixes: 0daede80f870 ("i2c: designware: Convert driver to using regmap API")
Cc: stable@vger.kernel.org
Signed-off-by: Tam Nguyen <tamnguyenchi@os.amperecomputing.com>
Signed-off-by: Quan Nguyen <quan@os.amperecomputing.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230726080001.337353-2-tamnguyenchi@os.amperecomputing.com
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -526,9 +526,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 			u32 flags = msgs[dev->msg_read_idx].flags;
 
 			regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
+			tmp &= DW_IC_DATA_CMD_DAT;
 			/* Ensure length byte is a valid value */
 			if (flags & I2C_M_RECV_LEN &&
-			    (tmp & DW_IC_DATA_CMD_DAT) <= I2C_SMBUS_BLOCK_MAX && tmp > 0) {
+			    tmp <= I2C_SMBUS_BLOCK_MAX && tmp > 0) {
 				len = i2c_dw_recv_len(dev, tmp);
 			}
 			*buf++ = tmp;


