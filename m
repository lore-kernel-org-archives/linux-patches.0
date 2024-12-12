Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E732F20E034;
	Thu, 12 Dec 2024 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015986; cv=none; b=AVWVhUew0kXbYni35FHaK0C+8mmWT1CZ91pRKKToJh7WCFlbwY3KhARQzNMawGut9GgMfBUvI0kIM/RSfw0Hfs2gxGY5DeASDhkL6TcGQx8aH9aoaAy6uJCB7KmYrld+vo59vn0uJCl2fth57aURSa0awtwn+fpeHqD9jAQ8vcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015986; c=relaxed/simple;
	bh=ROBPTureRdXr9MelmfEQOD+IDjTPgOToocXmar7EFvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgrJOvtFcPF8xtHeKUvGOqj+5YkBZONldGpk3MCWg6VInzhMFQJj+wmIrFz9oH8tlX7iA1kQ9/ivhXVkXyJ46xpvzX+xZ4K5WBTFcD0SG68iiw9sBmkPKrT3L7yGWZ01JbXzEgnHyt8myNsjXfwJwqodBGL3tV0vu1Eflm3nq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZU85yPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZU85yPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8EAC4CECE;
	Thu, 12 Dec 2024 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015985;
	bh=ROBPTureRdXr9MelmfEQOD+IDjTPgOToocXmar7EFvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZU85yPH0a0Aqjs4r9Zu/oQWyjGyelyk+4e0daMYzBWhQI7OOHpnuTAvRtYQ2yNjq
	 2Zsmoh7P3fsn036jVaZDYKGtBKKl6lfE675ePIxc1RT+d16qxLLN4b43WliBfQXV5S
	 g7fmTAE3nCJkUvBrswOAR5Ou6JLaZr3RcdUfAmvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/466] spi: mpc52xx: Add cancel_work_sync before module remove
Date: Thu, 12 Dec 2024 15:54:21 +0100
Message-ID: <20241212144310.451476807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d5ac60c135c20..159f359d7501a 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -520,6 +520,7 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
+	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
-- 
2.43.0



