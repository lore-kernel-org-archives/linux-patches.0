Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09852E06E4;
	Sat, 12 Sep 2026 12:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216781; cv=none; b=QCNypuHXJ8SQD5k6r9QNUjpjge1ORz30XxJKKJAesa+CcThCAiJbdVijvgfz6+aKz4T1DdL/CEjQ5fUmwW4mztckXx/rG5z08bqXneBwhZi2oUJra5deyrlQa8Oct4tUtYwENz8CfMOeNH0nQ6QXJkczYqLIO5Ztrw8TZt4ijiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216781; c=relaxed/simple;
	bh=8xb/Q+lkLNItCtsIgpq9yO1Zr55RqChUWyEhov+phhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li+QfdOPQEbFqs5ar9U/FPgpXbtMHB23NkxK3/QGZbkFEsdmUhnyiKt9CapHuwROYHvzpu8zKJkSlxMr291K/uIFe9N6c1N2m7x7JDlcj1ZTxW2dVbXAGyVwYmzgOXYeSlTxDE+9pLiIew8ELyY2Xe6rggSdAGN4l32FKQoEqfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eldwyt1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eldwyt1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8ED1F000FF;
	Sat, 12 Sep 2026 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216779;
	bh=GMvnKTKb2PFpbTiMocWZYQVHJPgSmp9ODmHMOZF+v+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eldwyt1iUD3dzk1sS25k4IUSER2byVIS3IYb6ThRAEKcJkZdaH4dEaKt0h4PWSppO
	 /qjd5Yc3HjNGVN7M/KdKzjxALvwDhza/xXbPiJJaDcR3nnnRH4BqJ7hlQoHB7Ul1ty
	 MuYpUEkO4xNvUuToo+J32WQCnAy/OzoSo8l4Xy7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0789/1376] i3c: master: Fix device_register() error path
Date: Sat, 12 Sep 2026 08:53:35 +0200
Message-ID: <20260912065625.121769543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 74be657d98a8d684c0475f3cbd450ef2a30ffc73 ]

When device_register() fails in i3c_master_register_new_i3c_devs(),
put_device() is called to drop the reference taken by
device_register().  That drops the last reference, so the device's
release callback i3c_device_release() runs and frees the i3c_device.

Two problems follow from that:

i3c_device_release() does WARN_ON(i3cdev->desc), so it warns because
desc->dev->desc still points back at the descriptor.  Clear it before
calling put_device().

After put_device() frees the i3c_device, desc->dev is left pointing at
freed memory, so clear desc->dev as well.  That prevents, for example,
i3c_master_unregister_i3c_devs() seeing desc->dev as non-NULL and
dereferencing it.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260701203053.8F3971F000E9@smtp.kernel.org/
Fixes: cab63f6488761 ("i3c: Fix potential refcount leak in i3c_master_register_new_i3c_devs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260702183644.60827-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 6eec1e6fb139f..48a91eac5ae51 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1689,7 +1689,9 @@ i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 		if (ret) {
 			dev_err(&master->dev,
 				"Failed to add I3C device (err = %d)\n", ret);
+			desc->dev->desc = NULL;
 			put_device(&desc->dev->dev);
+			desc->dev = NULL;
 		}
 	}
 }
-- 
2.53.0



