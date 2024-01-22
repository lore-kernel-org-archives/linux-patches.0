Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035036A320;
	Tue, 23 Jan 2024 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975343; cv=none; b=cZEeNXvz6wOPARewEL2fmSpDSX4zgT/8Ha1OysqsmDGzS0srSmuGIpmjiDKta5I1jjBreFVgIT5Ispo4Cqj/WCd+hanIsKQdAbZcXqg5uS02XMHSMcHpf4pIahyPTDIRi6yQ1gcMZLHZmvyMItnu8Wx7xbxhZJFtxLksBZckKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975343; c=relaxed/simple;
	bh=shEMUHsgyMOAuQx3vfHNpkm6z305yuoalm4Q8uMmKI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3PMaGwraxsqizs3AxKKOF0Iz+m/t+Wb/VR1p6Hucap5rKAhj5altGzxrhHGUWfVK4ppRH6qCvWTk63NUfdeOehL8MYT2CS87c0IGeXqr9tFsOO1YSl5BbUp4wga+wuz6owy2kjbtySh0bDWSbSBg/GtAfcsF1vk28vBrX4B6qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gg8cQbXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gg8cQbXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC869C433C7;
	Tue, 23 Jan 2024 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975342;
	bh=shEMUHsgyMOAuQx3vfHNpkm6z305yuoalm4Q8uMmKI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gg8cQbXKTwQtKbRkxaw+57rvX0qvlLdPVS6YSjGR73YsTm0vRGnTXdC8nYXHmIfzN
	 EOVpz4nbTBfrV7GCnFD0NcYQzkO1fZ2v8LNqm/TqCXCX5WoiJvDh/DxZWDwIyGTUCN
	 9SZTdIbw8SR2ZkP1Bs/yHA6HlbcYk1/rVwIQNlHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/583] media: dvb-frontends: m88ds3103: Fix a memory leak in an error handling path of m88ds3103_probe()
Date: Mon, 22 Jan 2024 15:55:31 -0800
Message-ID: <20240122235820.568064599@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5b2f885e2f6f482d05c23f04c8240f7b4fc5bdb5 ]

If an error occurs after a successful i2c_mux_add_adapter(), then
i2c_mux_del_adapters() should be called to free some resources, as
already done in the remove function.

Fixes: e6089feca460 ("media: m88ds3103: Add support for ds3103b demod")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/m88ds3103.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index cf037b61b226..affaa36d3147 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1894,7 +1894,7 @@ static int m88ds3103_probe(struct i2c_client *client)
 		/* get frontend address */
 		ret = regmap_read(dev->regmap, 0x29, &utmp);
 		if (ret)
-			goto err_kfree;
+			goto err_del_adapters;
 		dev->dt_addr = ((utmp & 0x80) == 0) ? 0x42 >> 1 : 0x40 >> 1;
 		dev_dbg(&client->dev, "dt addr is 0x%02x\n", dev->dt_addr);
 
@@ -1902,11 +1902,14 @@ static int m88ds3103_probe(struct i2c_client *client)
 						      dev->dt_addr);
 		if (IS_ERR(dev->dt_client)) {
 			ret = PTR_ERR(dev->dt_client);
-			goto err_kfree;
+			goto err_del_adapters;
 		}
 	}
 
 	return 0;
+
+err_del_adapters:
+	i2c_mux_del_adapters(dev->muxc);
 err_kfree:
 	kfree(dev);
 err:
-- 
2.43.0



