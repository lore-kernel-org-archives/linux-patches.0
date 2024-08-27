Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A71C6F58;
	Tue, 27 Aug 2024 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772194; cv=none; b=lpaKzD/Hw1qQGZsOKbmbgvy3qpdLoPU8ILMHkJ6FfLgZ4l8FQRR0BPst+GQKeJeZ1W5dxHUNbzuJy2dAGG4kkAYTX6lAXT/1B+lo6KfAMyCZCbsWcWcPslltjOiNdM6kIhR3o/Cyei+lC/uimkXDgJ9nMHfYlxSt0RRqrQDh6Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772194; c=relaxed/simple;
	bh=7LxHepOAcdHVQtPMy5gyUGGlc3oRdUlqoEZm0EcYotU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqLn2cArQMv+Nggfx4c1228ljIi+il8vdlBXk/A+fjQsd3V80L/ZhmoFuvh9bvGZcSu8npDs9eod717/4YhL8qUJBLbpfjT80qctyvf8KtkHPtzXr4gRCn8m6+9OSAUzyqLjxCfJo5yQh9McWgmRnWCLbVJnsyzO3Z1WEZAaRQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J08dKk22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J08dKk22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52121C6105D;
	Tue, 27 Aug 2024 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772193;
	bh=7LxHepOAcdHVQtPMy5gyUGGlc3oRdUlqoEZm0EcYotU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J08dKk22BUDoijfPhK5mdgfd6gxexaegHQhQDx5PZTH+BJTzR7gexpilDaSCVkXrB
	 E10FcpLuzKyDqXVaBwiQ5/cAwn2/8jVIv9WFGmalnF1iMLuXarRn7W4tq2oHk8N2N9
	 OiRhXX/JLzpVAguXSe0slWnyjWLpGZNKELaStul4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/321] hwmon: (ltc2992) Avoid division by zero
Date: Tue, 27 Aug 2024 16:37:30 +0200
Message-ID: <20240827143843.644314011@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 10b02902048737f376104bc69e5212466e65a542 ]

Do not allow setting shunt resistor to 0. This results in a division by
zero when performing current value computations based on input voltages
and connected resistor values.

Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20231011135754.13508-1-antoniu.miclaus@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2992.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index d88e883c7492c..984748f36594d 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -875,8 +875,12 @@ static int ltc2992_parse_dt(struct ltc2992_state *st)
 		}
 
 		ret = fwnode_property_read_u32(child, "shunt-resistor-micro-ohms", &val);
-		if (!ret)
+		if (!ret) {
+			if (!val)
+				return dev_err_probe(&st->client->dev, -EINVAL,
+						     "shunt resistor value cannot be zero\n");
 			st->r_sense_uohm[addr] = val;
+		}
 	}
 
 	return 0;
-- 
2.43.0



