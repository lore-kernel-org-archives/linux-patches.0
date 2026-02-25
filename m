Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C35413D51E;
	Wed, 25 Feb 2026 01:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984000; cv=none; b=I7Xk2SnPtGoImrDV59dlPqlNWux6o2qOEQ7lXynpQEV9TRsLQOR9uvxVQWMmHZiPUDt854+tXyNU7fKL/UbnWFtCxrlLwubu+oc+aVLdmxS+CUeTYfSLnHKYw9Js7Tsx+ruYhkTQLXd1txBPIugxr0Y/sxpc6SBBaQojYCeAE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984000; c=relaxed/simple;
	bh=AMwnZMHvAvIiSELEV28wZrnx8vQ5jrGp0kmKQ6Z+Pgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJglxIDVt4N9l/G8H/SfRhTsP9QgBQxt1pieYriKHIehHLNzsxQOrN+GJnjCTX62wtqivNi+iNOi2CKv51poknKGLmDepScm79V5xrAmWt/f58Pabvw7LcR4Yp1sxyfCe0CqCN/vW3PSiMYeOmQBSo4duvfgR+69Ttr9ZhmZmJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyBdIMzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyBdIMzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC68C116D0;
	Wed, 25 Feb 2026 01:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984000;
	bh=AMwnZMHvAvIiSELEV28wZrnx8vQ5jrGp0kmKQ6Z+Pgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyBdIMzSJXzGE6L5f6biMUldnt5FUeHi1ZgBikyEJ5Ro5Elelhm4r7wyvOESREt4J
	 9FLW/egnjC7lgg9y8bv9szJJOTgoVxRxUfjtfR4SKBLuDEl78zVzfbgBKig4yeIYs8
	 uHKtXnmEdwXE/FhVpkCI05LdKIkkQLEWUGFZzpBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/641] mctp i2c: initialise event handler read bytes
Date: Tue, 24 Feb 2026 17:19:39 -0800
Message-ID: <20260225012354.974463875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 2a14e91b6d76639dac70ea170f4384c1ee3cb48d ]

Set a 0xff value for i2c reads of an mctp-i2c device. Otherwise reads
will return "val" from the i2c bus driver. For i2c-aspeed and
i2c-npcm7xx that is a stack uninitialised u8.

Tested with "i2ctransfer -y 1 r10@0x34" where 0x34 is a mctp-i2c
instance, now it returns all 0xff.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20260113-mctp-read-fix-v1-1-70c4b59c741c@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index ecda1cc36391c..8043b57bdf250 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -243,7 +243,10 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_READ_REQUESTED:
+	case I2C_SLAVE_READ_PROCESSED:
+		/* MCTP I2C transport only uses writes */
 		midev->rx_pos = 0;
+		*val = 0xff;
 		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
-- 
2.51.0



