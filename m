Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8B62185A0;
	Thu, 12 Dec 2024 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017832; cv=none; b=s0wXFOUtkrDxwOhZtikrbGJqOKBVA5nLR/CBLT1/Z6rNPsKW6ICGqD9ClUmHe3dtvLB8qRyPrh8M481KozOGvszI8xgoJibWiKJQnNRDi1xhygAnGS7rTyWfEpuIs1cj7B0NubNKNE5qMQ9nl9TK24Iw1FivABO6ymlfJAsVURI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017832; c=relaxed/simple;
	bh=dhk/JcFF7ISGjWf0jqshyt4/YB4Gz3vgn54aYcPn/+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdlUtW8/JW/LETnIOO1VHpamVtO8tam/LuihsXtEFC4/8ZzXacazPDF+LB2KSxGr40lHlsZDgAPQJ0mEQ8QmiVaaSUcQqf0x8UkeTarTilcyzT4qgGUxdJBI5Ae/8zmezJ0pG5bgt+swrMBdyL4sK8VNKUi6Fk2XVW5GrYM4T1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/kXFClx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/kXFClx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A8DC4CECE;
	Thu, 12 Dec 2024 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017832;
	bh=dhk/JcFF7ISGjWf0jqshyt4/YB4Gz3vgn54aYcPn/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/kXFClxInGYb6XIrogAZN5WP+ekdEBDPbWVE/ZzV1ccSVU8KqEZ+yyBU/oQFvTBS
	 72U/Fu9ZNcpjgU0e3QtJ/NODbjpTY6evJRAqDOErT8/7VPJM41g3RYjfaQ8rzWq3cK
	 0JT8Zqh562S5ObleY8UxONc35xtx0pfd2sE94B8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/356] spi: mpc52xx: Add cancel_work_sync before module remove
Date: Thu, 12 Dec 2024 15:57:21 +0100
Message-ID: <20241212144249.472191972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 984836621aad98802d92c4a3047114cf518074c8 ]

If we remove the module which will call mpc52xx_spi_remove
it will free 'ms' through spi_unregister_controller.
while the work ms->work will be used. The sequence of operations
that may lead to a UAF bug.

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in mpc52xx_spi_remove.

Fixes: ca632f556697 ("spi: reorganize drivers")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/1f16f8ae0e50ca9adb1dc849bf2ac65a40c9ceb9.1732783000.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index ab7df5f64342a..b8e2d9263fc88 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -519,6 +519,7 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
+	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
-- 
2.43.0



