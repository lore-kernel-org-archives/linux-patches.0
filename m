Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7081DE3B8;
	Wed,  6 Nov 2024 12:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896376; cv=none; b=eMrC468PrmjIgsJZ78anngx/d2FmknXFembqhWan7dzPdzZysVrwQSgWv0Gbc4ZgncN7LL8zu0Fkd0TPqaPIlI0bpkDZhag20DlTReMtxgl+xwi9UOK1eJfUcb0kB+/vhxrNXL59EMrcYIrOZsrhO2rl8raXrYoLRpJIuDI7gWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896376; c=relaxed/simple;
	bh=W8VCOSJpp21VMG53nEPsjHDd1LQzVAjn7L6XfYHCR7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ2cXjKIh/EdCcq6nO56Yixe7/9WRrUrazUZiXgAkqbmjnr1IEjKlIsGVjUaE6qSKf2KSnsCuznLQUVdAh2BR/QykVOSXzRODqi0OeyF8OWZDY17sDFeNCaWz73bhtykVrCXETS1twLzJb9DLgMUtg2hn2D1jn4MXmCj/SPez4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTZFWben; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTZFWben"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848ADC4CED4;
	Wed,  6 Nov 2024 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896375;
	bh=W8VCOSJpp21VMG53nEPsjHDd1LQzVAjn7L6XfYHCR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTZFWbenX/1ZjhJEPqqQBG6kW6+fwRZSYHyNcqmSth2MDJpQn2kUP53xHoq5zKSsI
	 zcZW8bRQE2ToWcjmPjBx8cvtVoSRQJV1A6DDzQIM1+NcW05Ll1IwfXnarHAjR6LxoF
	 cvT4pc5IBrpmkmG+VOoSSq8O/4eZLzx2IjY9ZNAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dung Cao <dung@os.amperecomputing.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 181/245] mctp i2c: handle NULL header address
Date: Wed,  6 Nov 2024 13:03:54 +0100
Message-ID: <20241106120323.692854983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 01e215975fd80af81b5b79f009d49ddd35976c13 ]

daddr can be NULL if there is no neighbour table entry present,
in that case the tx packet should be dropped.

saddr will usually be set by MCTP core, but check for NULL in case a
packet is transmitted by a different protocol.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Cc: stable@vger.kernel.org
Reported-by: Dung Cao <dung@os.amperecomputing.com>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241022-mctp-i2c-null-dest-v3-1-e929709956c5@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 4dc057c121f5d..e70fb66879941 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -588,6 +588,9 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	if (len > MCTP_I2C_MAXMTU)
 		return -EMSGSIZE;
 
+	if (!daddr || !saddr)
+		return -EINVAL;
+
 	lldst = *((u8 *)daddr);
 	llsrc = *((u8 *)saddr);
 
-- 
2.43.0



