Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512E91DF738;
	Wed,  6 Nov 2024 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897664; cv=none; b=fh/9Sh+jhW9oZPJhXevxMbuVlc+1uOUOq/9xn3TyERP1yDU/TEbxMjJuhYvauDmuzxG1ysBBUEjyIyA28HHuI2fsnFaJeHSwFqK8k2omqwD0HtETLBoRmwSW4S7jvyTuW6zxkDM4P9WfCD34uq5p9yD6vY524x0wl1UsshMAFVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897664; c=relaxed/simple;
	bh=HCpSsB2seNVdNDMZCuiSioulxMlEQ3E+R9OJv35KNpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlS+GDar0begM+8fYRhL/if+PBwfyRnPJ8kf7AEVkNBSYGDiWJz6gIpJPg7kcEeaCVmwVliXe8GGno+b64sIGqvEgR7u608SwhY8pR92qty71azgXeJmTmYFqpOeWn6kZbo54/vKzZ/GyAMMBGiIcDHABAY4B9FkME0TZ5PMgKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0Yce1zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0Yce1zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA466C4CECD;
	Wed,  6 Nov 2024 12:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897664;
	bh=HCpSsB2seNVdNDMZCuiSioulxMlEQ3E+R9OJv35KNpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0Yce1zHfGBn/jAJuiBiBxQ/MgCz93dyfbFnAlCgLJ+4I6WUYx5Hka5BxVTG9t+ef
	 z1+OP1IMT5Zz4ZkUUTITNU4+LqMTwRInoRU2V7MfuJQasExb1JH/TZFPc/dOMz6DgD
	 NkP6YFPWIuaGtbiwVSNv1Uy5nU/MpDcrKbSNYzXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dung Cao <dung@os.amperecomputing.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/151] mctp i2c: handle NULL header address
Date: Wed,  6 Nov 2024 13:05:18 +0100
Message-ID: <20241106120312.440467592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b37a9e4bade4a..20b8d7d528baf 100644
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



