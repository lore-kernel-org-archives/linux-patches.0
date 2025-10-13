Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7FA31280A;
	Mon, 13 Oct 2025 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368260; cv=none; b=ekr+lqJnFGPzdBXI6BPXV30/eIgNgsf/E8DgSKLpTuiynnq52rtupkc6REPkzYhMcB5l0Lz0cZkvnuVcpQuEBeS1tPVjUWdtC+lUcpM2+RmdaHAAU3YvpoPD/EUbGD3lXS+k+JJVzzKOSTYgyp9tcnoblINkikvZ0RkE+Xta8nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368260; c=relaxed/simple;
	bh=ojwbqnOxXX7T/kqGh1o0+iRLjfumX5kZmM5e3C07a28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0AwOX+5XyNveDCYrvmZUW7q9KXsnP8XBpYdAjMZgS3PQKjYTIpB9+SytILCnDMgU0iK1kmbNSrDNRvPyr4KUvgkPp0kNDZ9tuTComMZLkhy3t0/xnfERmU94RTe8yuTcA3Lh5koYqZyZHxpsH2NuBNPM+D+wKLxKEMnWUTMXxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wmd44jqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wmd44jqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BCFC4CEE7;
	Mon, 13 Oct 2025 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368260;
	bh=ojwbqnOxXX7T/kqGh1o0+iRLjfumX5kZmM5e3C07a28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wmd44jqiSp2JG48MeKBI2uBoPZEo4Y35Ke3uTklBuNxIJhSAX9/iLQZuw+0G0M5uL
	 tIMuhAv9nKFmfqL41bAvM4HVhxAawrTg6ZFUKcsDHtLhwYaLd1bOXRoUfZlsWCA5HC
	 /hz46D813EOyyR6LplwI0v9DYHwU4U7pWkqN4BUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/262] serial: max310x: Add error checking in probe()
Date: Mon, 13 Oct 2025 16:44:00 +0200
Message-ID: <20251013144329.657732354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 672a37ba8af1f2ebcedeb94aea2cdd047f805f30 ]

Check if devm_i2c_new_dummy_device() fails.

Fixes: 2e1f2d9a9bdb ("serial: max310x: implement I2C support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMPZiKqeXSE-KM@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 35369a2f77b29..2f8e3ea4fe128 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1641,6 +1641,8 @@ static int max310x_i2c_probe(struct i2c_client *client)
 		port_client = devm_i2c_new_dummy_device(&client->dev,
 							client->adapter,
 							port_addr);
+		if (IS_ERR(port_client))
+			return PTR_ERR(port_client);
 
 		regcfg_i2c.name = max310x_regmap_name(i);
 		regmaps[i] = devm_regmap_init_i2c(port_client, &regcfg_i2c);
-- 
2.51.0



