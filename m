Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820521F8F04;
	Wed,  6 Nov 2024 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897191; cv=none; b=eQVHSE5yYdw1CYBLYrBx+0p6lvKRrIDXA9rsp6QRWVwEF8PHSB7Pp6zYNL134w/g77lhFGfAEYkciWQjNBTUK5gb4cqg/EqGft5cVMR4hdgc4Znw6/DRHSDrjvpO1Mp2qRphRRQiTIsT+/e0empbK3gRdK4P3uzrLO9EPevNHF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897191; c=relaxed/simple;
	bh=gt6wZVvw1Z7NHL6cd3TCeQdrY+9f9ekYoP5sEtkUS8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+wR2J2MA2pUam4CBhE004uQrodGLtM6qIUtlTQyibPClgoBWez96t4WjAuZmBpgg838O5yh6clw5+eORgGPxVwtCSPNE7vigUTZ1gGMW0BeYAipPwAOH4UXalTt/E/e2z228a2MCRhERFeIYY3Z1FaGFvyEriDOnjCSMXlzBNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al2O4TPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al2O4TPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1894C4CED3;
	Wed,  6 Nov 2024 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897191;
	bh=gt6wZVvw1Z7NHL6cd3TCeQdrY+9f9ekYoP5sEtkUS8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al2O4TPRed+9t50HvqgDcX2wHC0oMe+KMpYyv/ZbU0OZxyhlqKcGQVFC8ZdPj1yA8
	 XikaKYhkrWrAKx+P7eOvyHuLCvtHMu00tZRKDpo5yfFToggGs5Kfg8aBByN2hmHfRm
	 VnJ5/B71NISDmAL5jEyOke1LOYYt18m9245k7ZZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dung Cao <dung@os.amperecomputing.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/126] mctp i2c: handle NULL header address
Date: Wed,  6 Nov 2024 13:04:58 +0100
Message-ID: <20241106120308.687582144@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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
index 1d67a3ca1fd11..7635a8b3c35cd 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -547,6 +547,9 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	if (len > MCTP_I2C_MAXMTU)
 		return -EMSGSIZE;
 
+	if (!daddr || !saddr)
+		return -EINVAL;
+
 	lldst = *((u8 *)daddr);
 	llsrc = *((u8 *)saddr);
 
-- 
2.43.0



