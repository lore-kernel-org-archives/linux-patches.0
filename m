Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C3A23DB;
	Tue, 23 Jan 2024 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969846; cv=none; b=PNtg8V8wPpCcvrXHSZf8IogxXlBKMMarQjFLAjVkYDNfev7uX+vPkrRGHsLrB74YKA0fBqrocg9wZVxtVF8ft/R2DqYJSSIpC4qFLTkS1VSdimHDJWBaUEoA3AzTMjQS005jpPDyAFfucKMacSUVgK4kn8CWh+nBz+2JfFsQNG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969846; c=relaxed/simple;
	bh=qNMBhwK1KUAVAaJYSt4ODxNnjUzBOTIosDPQVgYDMXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH4b/wqBBw0Fq4n66r9jnFUKmg1/qZKJ6mWAyYq7LNMSnyoKGhkTcz3lraKm2N5IRZq0GQKGgAMDZhhlG1qW7bziIRR6VlYBr7DuwmNi2tfI0EmDcxJ1islovgdaKwWvYRl3iF4Sc/jbRSXTMyCCwdSAuI9lXMd07xsOiPKXPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6iOi5Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6iOi5Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CB2C433C7;
	Tue, 23 Jan 2024 00:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969846;
	bh=qNMBhwK1KUAVAaJYSt4ODxNnjUzBOTIosDPQVgYDMXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6iOi5ZazDSiXgFzOhZRxKGGAbdmc3qFRKskLnPbFWe+2Vz1lQW7SkVE7mWcPcI1U
	 GX1LEtuj1pmNhrt5f3LBxLQu/UEyo75Z6PmNsXiNr2oGewm+Bs67WUzwGQU0WeiiTp
	 mEYRQ4ES6JB7KkWbPAVdWkPlhDUYFUKCdvH2+oeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 484/641] mfd: syscon: Fix null pointer dereference in of_syscon_register()
Date: Mon, 22 Jan 2024 15:56:28 -0800
Message-ID: <20240122235833.227332357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 41673c66b3d0c09915698fec5c13b24336f18dd1 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: e15d7f2b81d2 ("mfd: syscon: Use a unique name with regmap_config")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231204092443.2462115-1-chentao@kylinos.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 57b29c325131..c9550368d9ea 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -105,6 +105,10 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	}
 
 	syscon_config.name = kasprintf(GFP_KERNEL, "%pOFn@%pa", np, &res.start);
+	if (!syscon_config.name) {
+		ret = -ENOMEM;
+		goto err_regmap;
+	}
 	syscon_config.reg_stride = reg_io_width;
 	syscon_config.val_bits = reg_io_width * 8;
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
-- 
2.43.0



