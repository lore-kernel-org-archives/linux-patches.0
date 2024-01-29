Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE7156967;
	Mon, 29 Jan 2024 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548048; cv=none; b=RyVfjOjdfhEBa219m4h8P/nwx7ey6ViICe1c/huq89J13rLK74vvyjjQ3pHS3tmXdAYoaKiCm12gJVqvjahQ8UezPfgeoMBowT2Lw5V0Ss2E6UZLRg3ZKm/gq0Q9ILNGxGpgf3wsoIBpq7sQd3eZ2j0LZcqHjhMVxI7R3x8E+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548048; c=relaxed/simple;
	bh=m+q7P40CDWIBgEfR+UnPrxQIo30ywfViwaLSYWyz3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKTw54Mu4eH/VfGsPtskn7b88lAIV/1wyug+Z+pXoSVhYcYlIDKaLEY6068amZjqddDMufCFdqjpfVaXJ28hNl6ls6mi2iUw8p1W3/7fiA/qCpUzkZE+FsG8t4kkXGeeXFjf1bXBKCPKkAuIbGwxb0/RjEt1Y5b2paUPZnzal7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAHisq2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAHisq2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A40CC433F1;
	Mon, 29 Jan 2024 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548048;
	bh=m+q7P40CDWIBgEfR+UnPrxQIo30ywfViwaLSYWyz3Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAHisq2CQVAm4WbW4k8LxNbuC6o34AouP8ssTveMI75cD2+xxSYAx7ANL9EH3tipG
	 EyxMzAnmU+sSlWuV9Oo5mt4O0jRdnPE7mxhej/pYfq7hbuUuyldEYwgfmsytlaVyNn
	 +Y9RjfhWFe+RHZa5fcOWhXQmrl9yXWX0uHL3eLQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.7 049/346] parisc/power: Fix power soft-off button emulation on qemu
Date: Mon, 29 Jan 2024 09:01:20 -0800
Message-ID: <20240129170017.826011937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 6472036581f947109b20664121db1d143e916f0b upstream.

Make sure to start the kthread to check the power button on qemu as
well if the power button address was provided.
This fixes the qemu built-in system_powerdown runtime command.

Fixes: d0c219472980 ("parisc/power: Add power soft-off when running on qemu")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -213,7 +213,7 @@ static int __init power_init(void)
 	if (running_on_qemu && soft_power_reg)
 		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_DEFAULT,
 					qemu_power_off, (void *)soft_power_reg);
-	else
+	if (!running_on_qemu || soft_power_reg)
 		power_task = kthread_run(kpowerswd, (void*)soft_power_reg,
 					KTHREAD_NAME);
 	if (IS_ERR(power_task)) {


