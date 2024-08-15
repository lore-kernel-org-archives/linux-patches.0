Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD17DA78;
	Thu, 15 Aug 2024 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728691; cv=none; b=pivKJza018C04ITf1f9Y0q2apf+bVuot2yUQudPvaRgHnF6F6e9tZ51JHeWlqhXQRT7JS0zht7evSs+YI5qBfYh/sH8hpl0Smbokz2nYrcwIGDwoiMnKDOoztTdFKbPdeRIHD1mmSLfdwsCVRrrZzh73kACPWQbWltKdzywHsQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728691; c=relaxed/simple;
	bh=r04URPTyfo7T2iN25D2b7MJP6MQ6wcoNH1kWwMzDXDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A242BdA+vFD/DrUl8gYzVenlzMmiGN3Y6Ui2u09uJHvb8vi3Q6iGOnm9APHLeU7Qo9p0vbjaGIkjLFADDkglM8unWux80W/ff0ZczSSDLl+4Uj+oonE6bX9Fe1JZ5KYXszbp7ot7hpz+EMjrv6Z5mCDwEMDcHMI5VOchDkREhPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8MrsQqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8MrsQqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94451C4AF0A;
	Thu, 15 Aug 2024 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728691;
	bh=r04URPTyfo7T2iN25D2b7MJP6MQ6wcoNH1kWwMzDXDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8MrsQqnRmCOeKp19HHEH50VvxGJ9lQLouH9GfJ2mEVYvzDtlz5JDAegjJi80Joxv
	 /ve9R6adNXhub9TvTerajUM9flnkSeFvfBhc5qk0bFcTJB+FdUcnJMjinFtkwYpWS/
	 mLXuolSt+4pMJBJ5eVkzLm7QQ23JA37Gr1j//d0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/196] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Thu, 15 Aug 2024 15:22:45 +0200
Message-ID: <20240815131853.921883743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5f82c1e04721e7cd98e604eb4e58f0724d8e5a65 ]

Make sure interrupts are not left disabled when we fail to suspend the
touch controller.

Fixes: 6696777c6506 ("Input: add driver for Elan I2C/SMbus touchpad")
Link: https://lore.kernel.org/r/ZmKiiL-1wzKrhqBj@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elan_i2c_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index cb0314acdfbd0..c02be5bf4baff 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1270,6 +1270,8 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



