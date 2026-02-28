Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A017C3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301222; cv=none; b=mGS86FF+nKhh6uOBOO+qHgMKveq/QdjZNdH7e7zAA4OsQmDmcNF4VyE7GlDuVa+7y5CB7s0IbYSgGC85cAHtUN1FT9M6qovHpHFkneI9R6wD1hV4DUH15FXnvRYLw4Ed+s6INuHSzplP3Mzy830zL7qWrWz3bjL9HA7zd+oQHLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301222; c=relaxed/simple;
	bh=f+9w+xIfsNKQxYYkTRobj6+SBwpLWJTstDUHok5rPqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwIVin4gTRztjGtuz1t8FX9T+lrinhAHRPTJyyqLIkQI9ALJq879f7s8N2NIPKgvBoHBqjGApS11SyRKaHU0dW2xk0hzrKMLhGn4qRQ6Bec102uSaIjw83Th3jynphkAlGokIGcWp20G1i4SgZyU+p55f/KbL/CJRvq4IDipnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVi0qheU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVi0qheU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC0CC19424;
	Sat, 28 Feb 2026 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301222;
	bh=f+9w+xIfsNKQxYYkTRobj6+SBwpLWJTstDUHok5rPqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVi0qheUhD7998G4RX8w29JnV5toQ1ozeUcq2SoxsqHr6ZdZCdHLIspcvCISpYJ04
	 JiBQWSGkNYv8sjkP4n556uaUP/ZSMPgllk2xALf27WohFSBLEb2mSH7avCY4hG1xX0
	 SsaYQ/V/P7x8w2sIpCjVMBFmODD3gHsByKhENQHJhg3hEWRUjbg0cPabJTSjSxKnNZ
	 oiDakOWj7bWFP6dSY+hZAwvYvNcLs/SWHYDJAmE/lGGA3Yaz6kLaNCA4ZzueJY/tEB
	 5dSexJPrU9H8z67noRZtBzpfewPLaeHcr/53iyC/OTdI0k1kSrlPfW1eNJkx/ijFJl
	 cbCzBYyI5AoRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Johnston <matt@codeconstruct.com.au>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/752] ipmi: ipmb: initialise event handler read bytes
Date: Sat, 28 Feb 2026 12:41:50 -0500
Message-ID: <20260228174750.1542406-399-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 9f235ccecd03c436cb1683eac16b12f119e54aa9 ]

IPMB doesn't use i2c reads, but the handler needs to set a value.
Otherwise an i2c read will return an uninitialised value from the bus
driver.

Fixes: 63c4eb347164 ("ipmi:ipmb: Add initial support for IPMI over IPMB")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Message-ID: <20260113-ipmb-read-init-v1-1-a9cbce7b94e3@codeconstruct.com.au>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ipmb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ipmb.c b/drivers/char/ipmi/ipmi_ipmb.c
index 3a51e58b24875..28818952a7a4b 100644
--- a/drivers/char/ipmi/ipmi_ipmb.c
+++ b/drivers/char/ipmi/ipmi_ipmb.c
@@ -202,11 +202,16 @@ static int ipmi_ipmb_slave_cb(struct i2c_client *client,
 		break;
 
 	case I2C_SLAVE_READ_REQUESTED:
+		*val = 0xff;
+		ipmi_ipmb_check_msg_done(iidev);
+		break;
+
 	case I2C_SLAVE_STOP:
 		ipmi_ipmb_check_msg_done(iidev);
 		break;
 
 	case I2C_SLAVE_READ_PROCESSED:
+		*val = 0xff;
 		break;
 	}
 
-- 
2.51.0

