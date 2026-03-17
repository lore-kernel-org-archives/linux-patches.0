Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADA3C6612;
	Tue, 17 Mar 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766589; cv=none; b=IG6BRJqGXRlpyqWMHBcmbuyyRpR9MHx4iMZmdvLiobbA2+1+2F5UyJTKm+qcO8L/koRWGDhcKVjRbh2abFwRCmXpcHnwznTOQzb4T+gIb0d5+MrcNBzTgPbZ+QWSq66niDKZ1Ro4BKC/G4PzluxVANDyqusdjVgkWiQN7On3WyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766589; c=relaxed/simple;
	bh=boTrJT/Vn07nYe8dbGm9ukx0rGEwtU5IYXDsuZvnJN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q45rka7Kl7cp//uT09C7EVoq/R6mSUSz2ktlkrfSKAG1Wpog0teYa8xezth5Pk0EkwoJgMMyDv0X8WQJCVYwWhFRQEMPK69SF5nDCoqDtBAbowdiGrHgHrq2ZozVBEj+KBO/AOxw8nt0cy4na3O4WsDduWxktMZ2+QojvsRR2/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj01XWJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj01XWJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3133DC2BC86;
	Tue, 17 Mar 2026 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766589;
	bh=boTrJT/Vn07nYe8dbGm9ukx0rGEwtU5IYXDsuZvnJN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj01XWJA9UDDEA813WYE2iRKzJpncLobgFwixwW66zkvJLJM/STFHbmVNx1eHpu9d
	 Q2JlRWj25NuKfqnyUXnoC8GtsdMJzOkb7rG+/JQCQ35PO7qbo56jGp29d9+P6d6TZ+
	 XAMp7NKgGN+WGbspAW0fXHZnYq95ujnp3dY9cwaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 279/378] regulator: pf9453: Respect IRQ trigger settings from firmware
Date: Tue, 17 Mar 2026 17:33:56 +0100
Message-ID: <20260317163017.269761823@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franz Schnyder <franz.schnyder@toradex.com>

commit 2d85ecd6fb0eb2fee0ffa040ec1ddea57b09bc38 upstream.

The datasheet specifies, that the IRQ_B pin is pulled low when any
unmasked interrupt bit status is changed, and it is released high once
the application processor reads the INT1 register. As it specifies a
level-low behavior, it should not force a falling-edge interrupt.

Remove the IRQF_TRIGGER_FALLING to not force the falling-edge interrupt
and instead rely on the flag from the device tree.

Fixes: 0959b6706325 ("regulator: pf9453: add PMIC PF9453 support")
Cc: stable@vger.kernel.org
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Link: https://patch.msgid.link/20260218102518.238943-2-fra.schnyder@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/pf9453-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/pf9453-regulator.c
+++ b/drivers/regulator/pf9453-regulator.c
@@ -809,7 +809,7 @@ static int pf9453_i2c_probe(struct i2c_c
 	}
 
 	ret = devm_request_threaded_irq(pf9453->dev, pf9453->irq, NULL, pf9453_irq_handler,
-					(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
+					IRQF_ONESHOT,
 					"pf9453-irq", pf9453);
 	if (ret)
 		return dev_err_probe(pf9453->dev, ret, "Failed to request IRQ: %d\n", pf9453->irq);


