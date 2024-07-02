Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E748178381;
	Tue,  2 Jul 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940137; cv=none; b=SLdYH4Pf3U32w/9+ldgjgjvN8rB6Wv/W/oYgg79FuTJwosGIL6eJX4K/zD2zrN4+4wShUFs3tfLU1s6zcNaEUWVOy9lRw/ShppYXD96Aqj9Qv4GMeYXhq+QI+P7TPrgKc7Uq2e+VhWbaOpyqfQSf538SYYTg1y1X3SxXuzmDlhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940137; c=relaxed/simple;
	bh=4tvy+/UyY0cAU1NVocyVulMESpoJqWfI5r78DyE1wrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsWbNcOx7LGrGsW5pG9gMFJna0oAajGFQPNit5gakoltBAT0p290DusFx4N9dXrmdileRALbjtVgtrdenblDGVq0THc+Wqtpms7qQy1bibfBkIe4Ugn+03cS5vqP+2zYI+6yGLnhry0iCdtSf92VoGgUg4Tpgtg8Bcc2xvDvNiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHvmcjXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHvmcjXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0F7C116B1;
	Tue,  2 Jul 2024 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940137;
	bh=4tvy+/UyY0cAU1NVocyVulMESpoJqWfI5r78DyE1wrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHvmcjXLeFI2VTfkJqU+6Pht3s1SMmTAMhITBg6robZqboKpkDLk0taBGzQVXk9yz
	 o3BEGSfd9FUllQclHuVFCp7FPjif7apw3zWPws7t9DiuNj8QWWutHpKwDok9oH2Exk
	 bU4EddOxZ0bmopJQ13Z5YPgBVZJH9ea/1JDrWiPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 064/222] net: mana: Fix possible double free in error handling path
Date: Tue,  2 Jul 2024 19:01:42 +0200
Message-ID: <20240702170246.428568108@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 1864b8224195d0e43ddb92a8151f54f6562090cc ]

When auxiliary_device_add() returns error and then calls
auxiliary_device_uninit(), callback function adev_release
calls kfree(madev). We shouldn't call kfree(madev) again
in the error handling path. Set 'madev' to NULL.

Fixes: a69839d4327d ("net: mana: Add support for auxiliary device")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240625130314.2661257-1-make24@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d8af5e7e15b4d..191d50ba646d8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2800,6 +2800,8 @@ static int add_adev(struct gdma_dev *gd)
 	if (ret)
 		goto init_fail;
 
+	/* madev is owned by the auxiliary device */
+	madev = NULL;
 	ret = auxiliary_device_add(adev);
 	if (ret)
 		goto add_fail;
-- 
2.43.0



