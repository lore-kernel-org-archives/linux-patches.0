Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1FD4369A;
	Wed, 25 Feb 2026 01:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982882; cv=none; b=gmGTzUNy7PRgn9/Z+GcDsjIgIPP1Lst+rAR9MkYRO8N58zKJa22ERh4BRKo4CYbHf95vqczK+ypQ7EtMrvCGEFWnznD9lDuc93YE6fDHPOeEnM8ITqVATlI8qr6G0Xz9fz3jVmj+f1hNHjesSlRCvqReXyvQ6SG2+UaG2rVwDbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982882; c=relaxed/simple;
	bh=Qk9FnEwkm4B0PJoamdeasU572PQ7yRpdYvr5PAbNI/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL682MqRx6mdRi9Em0wgFH3IUrvU9BUQlvvECtSQrwRJ5aWYfNVA+lb+nBin0B2uBr252YN6R4UcPlEqRGIGGVGlwTBk2sEmkM9IwOZoPAaSU5NUgdn5qqL9mhCjsdNRypK6j4c/eQbxBfkFcwW1EiGMheaoqj6mQBlS2jHKz3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZfxlwI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZfxlwI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2257C116D0;
	Wed, 25 Feb 2026 01:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982881;
	bh=Qk9FnEwkm4B0PJoamdeasU572PQ7yRpdYvr5PAbNI/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZfxlwI4kr9v87dk1/SSFdrGMXc/stOIgQRujWHXVBBTw+pP2LMS9vWdhLgoNGanv
	 OM858GprzBO21x+8e9dd6zpIUGdoExbfXpNeb018BM+C67+4aJcl95Hrx2/hOGJ+oz
	 jfFoh7gJ69HnPwHvqFkDoGRkdz/3G0ONnKB9pc/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 023/781] i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()
Date: Tue, 24 Feb 2026 17:12:12 -0800
Message-ID: <20260225012400.270277613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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
index d5b0704040562..4033bc16677ff 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1099,6 +1099,7 @@ static int dw_i3c_master_i2c_xfers(struct i2c_dev_desc *dev,
 		dev_err(master->dev,
 			"<%s> cannot resume i3c bus master, err: %d\n",
 			__func__, ret);
+		dw_i3c_master_free_xfer(xfer);
 		return ret;
 	}
 
-- 
2.51.0



