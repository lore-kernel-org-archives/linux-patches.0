Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275B11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3837AC433C7;
	Thu, 24 Aug 2023 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888934;
	bh=ZqXMqSGFTK4y2HZnHJYay9/4BD3AFpaWThPFUV+6aUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eezabayfg+vDshjM3NrYGbrsQ9BgCICgj2Mvn0f0eGZSl69IqwXhuZ7ebbTPQtTtd
	 7xvXeLHx/S2VssqIavVqWA6TqiyGhO5s7tIWuODlLErbxlU3hV0r8cSlLyE0H4JqC/
	 Qg92wqrQq8FHFICaH5qfgzsWkBnhIqsH3vtlV/Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tam Nguyen <tamnguyenchi@os.amperecomputing.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 077/139] i2c: designware: Correct length byte validation logic
Date: Thu, 24 Aug 2023 16:50:00 +0200
Message-ID: <20230824145027.001473015@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
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
@@ -525,9 +525,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
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


