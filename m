Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055261;
	b=RJ4hL4wsDd/NSoKp7NdeM84DlnyJ4hn2lie8VEfP+TSJ1awM8oUwLoY11aOxqnmhoQzT
	 h8HdqP8Wkzip3MrJo671EmBud7zldG6XFwbSdeyzci7Lb4GSh5ibk/mIXlGcwdb7WhUAE
	 KJCgiS0qeiebMKhk81CSxRv5hxISYUtfQWUB4fqIdJ6C6A3kW7WpFQ4mqKJWsJMuUvunj
	 Vr+HAw0ZQPAZ0F3mlKEOuIr8RlSexdm6nzAjfhBvcrX7VkSAMZL7MzHB6pm/Atag0Khtk
	 2GHc2Bz+j8SecF0DhDsQjet0dUPfa8zeXvHBM5W943aE9mwIssnXWqWav4z6zd4Ce1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AkyEUx7XCp2btAfKEedrYkxjIVITraNXYp4jn+4KMWE=;
	b=01KDn23Phdr1rdQ3Sea6lsAPfGOI2xg+lG+hZGNiuwr5PprjzHKevPRaS/MheKPs4JmB
	 SHwop8i3fOJq/bA2uMJl28OzGtx8ZUwZwenbyard0iBp4ISX+e6XlaUAGcqEISManR/3z
	 52mbownaT1J/cg4lk1k1U7yV932YBBrcxKiLtDrSQz1BqRayfZkthvqOHgHLzHPD1TtbE
	 mYVckHukrmje7OAo9X0X0/3BMJn8YX5hhECaDCQkHa+r3yesdlTojpz2rbxOG6TLt7Noj
	 arwVruwXFVVdpNdbcWbBwCR0k5IZBsflxY0asjSWcsrzfwe9pjI/uctINgHp0TAYrhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmBe97b8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934160A260B;
	Thu, 19 Nov 2026 02:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmBe97b8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4000F1F000C4;
	Thu, 19 Nov 2026 02:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055260;
	bh=AkyEUx7XCp2btAfKEedrYkxjIVITraNXYp4jn+4KMWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmBe97b8I3fsYC7r/xcklaZFKg4fupzf9CZ62h91sf2TLgIGH2AYW8W/0cOtB2U5k
	 PZSV9nnywjWUlu0tNHJrCR6mX+Eoevq/Kk6tz/vUJ6JlF6a+Z/UuHjpTC5MQQdArxR
	 n74UG7Vo+g4nyocSQdAMblE24STusPqZyS1g3+qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1551/2214] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:53:47 +0100
Message-ID: <20261118150114.158011871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit d16ef5debccc4289c1f25309a2cccfbbe879601a ]

If the "mps,fb-voltage-divider" 2nd var is 0, there will be division
by zero bug.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-3-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index f42572d0f94e5..ae45a8dbdb27b 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -317,6 +317,9 @@ static int mp886x_i2c_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
+	if (di->r[1] == 0)
+		return -EINVAL;
+
 	di->en_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
 	if (IS_ERR(di->en_gpio))
 		return PTR_ERR(di->en_gpio);
-- 
2.53.0



