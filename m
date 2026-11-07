Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062803;
	b=p1vF3yH/g1tGj9GFKE44f8Wj1tMma26GVNrpUG8jGIDPWryV+aV18TRy/KYSCXgp1/up
	 QCjyyZiyCF6RFyS6V/dkeyaLO5Hm/LKESnCzOMTND/1d4Ha7Tj5eYYceHiKAY2Joi7oWK
	 tPVgpxxxfhPLdV/q7Flxg8sTc4xTjvX/3KBCPGybWriRo+blqNt+5lOsIOvj+dnZ6aDT+
	 Kadsxdrl0guowjPce8Uiq/66+ca6OvmfJ8eDbc7xC84efSvBgRx/zOl3LPJVMEqJJPMR0
	 ZfedCSs3V33ZBKCKffrxr3ZrV+vMU6iX3t3SCdXSYTnAO7aMf5+XYMhxfpdSUPtAESQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ig/jQVYZw7Q9d2ppvxF+3bbo4DLeefSXuUoPdI97R0c=;
	b=S3uGhszsvgZ3teY0b7h2sefddbNZSg3kKXRg+/+fwXkafUAfbPQIKTGoyCOHsGVDpn7Q
	 R4eQRb7MGAXwN94okpD4H4CuU1ypOHLO0XXeJRsX8zSuEDbOue7aTFKusqqqX6a7pbjH6
	 Th9sJuz8WT7Uj43yosynqpskFEuIxKRM+mJRIIkGSPY8K3rFWfYl3N9ulTDwe0ne0WRHV
	 u35aDCql1oVbXBhH+W9BSCWBwDE2xVUMq0dZt7S/PhfvT7AND5QKbHK25wMM2jpXKKYse
	 puUyYQpj9re/HtRxxYTbQV6wGYexNl3ZPK8rTyJ9LCRcIBEATc/RTtQK2XSDmrpMJUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkUeniS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6B606D813;
	Sat,  7 Nov 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkUeniS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F2C1F0089F;
	Sat,  7 Nov 2026 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062803;
	bh=Ig/jQVYZw7Q9d2ppvxF+3bbo4DLeefSXuUoPdI97R0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkUeniS+AjKJpb6wWeRWjRZuG1n6JV++K5oyVAhOsOpiXqmjOnsyTYbZglLCP5VxV
	 B8GabUwn7+GCjYGOjfdjNsMp+UKHC1psLzgiCfrT0FdQzDNR/8MFK6S7aHIcys+kkW
	 h3GnY2Ks9MkMAO6whv8qiIc5dzLefAdBfOr5/esI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/869] media: stv090x: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:46:27 -0500
Message-ID: <20261107134856.181470188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit bad6ce6e0856f344910ba95b006e6c0ebee2d9c8 ]

The FIFO_BYTENBR_FIELD register field is 4 bits wide, giving a length
of 0..15, but reply->msg is __u8[4] in struct dvb_diseqc_slave_reply.
A faulty or malicious DiSEqC slave (or i2c bus glitch) reporting more
than 4 bytes will the array and clobber the stack.

The stb0899, tda10071, and s5h1420 drivers all properly bound the FIFO
count against sizeof(reply->msg) before the read loop, so do the same
thing in this driver.

Fixes: e415c689a884 ("V4L/DVB (11579): Initial go at TT S2-1600")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/stv090x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index f273efa330cfe..b95b6b4a69c73 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3902,6 +3902,8 @@ static int stv090x_recv_slave_reply(struct dvb_frontend *fe, struct dvb_diseqc_s
 
 	if (rx_end) {
 		reply->msg_len = STV090x_GETFIELD_Px(reg, FIFO_BYTENBR_FIELD);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = STV090x_READ_DEMOD(state, DISRXDATA);
 	}
-- 
2.53.0



