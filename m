Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF24C1D5141;
	Wed, 25 Feb 2026 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983719; cv=none; b=C4HDoR1qg4MEgJ4pFvWPCar/bw9nJYUsk7E7oBX+ALdgQSF/c6atk8dUlwfmNDrtmV8eC35g4D4GYVZyH37IzpqLb5qYcKgD4sR/E6SmNjjd+Dx64lHRMAqJBOR+qYhu95yEdyXiyj4T21SMBpraK/Cx45PoBg1ZwvL2ZpeIUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983719; c=relaxed/simple;
	bh=s93z/6HRgRm468uK9ItdPyPJm5F3vFyJarCN5LfvMwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjcpkgE6ywgeSEzVsMpHQavBrexwTa+DfWE1x3tdF4xeC3UpPgF9/jdmNDOBpFdafMWXNKsINsFwqHbRFNQtuIdPe66I4TCuhHSzqHQh2dI+JXdcFjdxzOAkNmDOKZvaNbrqkypaxeia9A68j0nuhFmJjng1IGmfBIwnvZwIftg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqixpMrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqixpMrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E87C116D0;
	Wed, 25 Feb 2026 01:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983719;
	bh=s93z/6HRgRm468uK9ItdPyPJm5F3vFyJarCN5LfvMwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqixpMrp6Xj0UOHE24Dp6Tes+wKI5b6SkRbUrL9zjJ9P6YaGUlKxDsY1vHYajbwuQ
	 aEmXh2cqx1rmOJ2epofadl0nZXJn/HC/QJkNO/AN1rtaXO42rH/RsHW7PuQiHyQdnL
	 daB+KkWvfA5aVqq9Sl9LKURG73ZfFD+m/HuNv2sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/641] i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()
Date: Tue, 24 Feb 2026 17:15:43 -0800
Message-ID: <20260225012349.383086584@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 2537089413514caaa9a5fdeeac3a34d45100f747 ]

The dw_i3c_master_i2c_xfers() function allocates memory for the xfer
structure using dw_i3c_master_alloc_xfer(). If pm_runtime_resume_and_get()
fails, the function returns without freeing the allocated xfer, resulting
in a memory leak.

Add a dw_i3c_master_free_xfer() call to the error path to ensure the
allocated memory is properly freed.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 62fe9d06f570 ("i3c: dw: Add power management support")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260126081121.644099-1-zilin@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 75f813d72f851..c06595cb74010 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1094,6 +1094,7 @@ static int dw_i3c_master_i2c_xfers(struct i2c_dev_desc *dev,
 		dev_err(master->dev,
 			"<%s> cannot resume i3c bus master, err: %d\n",
 			__func__, ret);
+		dw_i3c_master_free_xfer(xfer);
 		return ret;
 	}
 
-- 
2.51.0



