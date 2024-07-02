Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246D71BE24E;
	Tue,  2 Jul 2024 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940834; cv=none; b=T8m68N5MwJhEr8ioJyGNnIpN0tRPTwVbVIPNRO7eZZ7Xv2hzHpWHwMOVQVXed6g3Ct2vtH4OtSv/ieatx/1z19s20gtMqVj5RqVQSfM88gjJdHHpjMboKQocy4I51lUmxZmmmXwFAx7a/nQmEnJxk2z3dydxjZNaDB6rKGylwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940834; c=relaxed/simple;
	bh=qiDpRR+WZfjYtdpNQuDyuQvcVLtHNYv988MSm9f48Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBcnELmBHUOzwT+ud0TocfZkAoiMS5g/9uplYEG7Bs/pkoPXo9N3vc7hasaFzhve46rG5ESTbgPRxnS2Pe8vRHyDjkkTJMDeRKuBeMWM5IFDp7PReCdGFwdRLNLHdgEZIb8Of4oN0QGfb0+tKFEeOKebaQ6CMsG2qdOmbGfzcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYh9bel+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYh9bel+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBDDC4AF0A;
	Tue,  2 Jul 2024 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940833;
	bh=qiDpRR+WZfjYtdpNQuDyuQvcVLtHNYv988MSm9f48Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYh9bel+8kQi+IX0bHiv7/Y/AuuhchUD2bNPJ0fsD7PasfxYvNY42uJEi8zLxhoDU
	 kaf1ze81PUlQS5V/nGoJOcAyoj/2IAqFU7xoVx0kOYNv+aLaFqNnxcwNSyLkRmhooK
	 to4h3I2uk1o+nW5qqlAybfc7VDT++HnY0p/sEmuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/163] net: mana: Fix possible double free in error handling path
Date: Tue,  2 Jul 2024 19:02:44 +0200
Message-ID: <20240702170234.956842021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index e443d69e39511..a09001d22b49c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2752,6 +2752,8 @@ static int add_adev(struct gdma_dev *gd)
 	if (ret)
 		goto init_fail;
 
+	/* madev is owned by the auxiliary device */
+	madev = NULL;
 	ret = auxiliary_device_add(adev);
 	if (ret)
 		goto add_fail;
-- 
2.43.0



