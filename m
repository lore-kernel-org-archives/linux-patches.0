Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0913145A10;
	Thu, 13 Jun 2024 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279826; cv=none; b=MlcXHzoWOOrsqbOr6uOAyAXdODk64yLr9DnLmZWv2ubvAMaOHUnxRMfi5xBgQht0+xHJ0XT5KjlR5OU5XYWG8+2hxaphAyPJqaEksXxdDXAGr5DSpMYgL6Nbr/vy5TvfEP9IGAFY/Sqz6u31UzcQ7BHLc51ORZf59Ihm0kkol4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279826; c=relaxed/simple;
	bh=Zhy1eqe++HE2jo9pZrtWSWtbfaovtoEenTmuozM+tsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL7Q/ie1rjc1wD+uA9nj2NagBhT9fJjdZkR9FBCmj2XDSLbNBkPQT6zMmNnmTEFsUYCnc9oYgka9MfXsrLus0moVlLK4nv0ZnLWNz3dZKye7zI/XHP+KnNbSXJBTrQw1bgSkIyvRzr3bv73n9oO/kLRB+FABRHvMD2XhC6VVlfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFDxXhqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFDxXhqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DFDC2BBFC;
	Thu, 13 Jun 2024 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279826;
	bh=Zhy1eqe++HE2jo9pZrtWSWtbfaovtoEenTmuozM+tsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFDxXhqyJT5HJ5tgHfe7MNzm87+HruWLP5f05yK2Fk+8N7CeVBML9FE56jbLitywt
	 ++u3FcKi+hPiYbHu+VvVOmtYjWQDjMJ3lAHGOFeXn1ZHFEBw2j6i2ZEXgzlOclvFBE
	 7FrFIKuxeoJMOSEFunlKxyMYoD1cePE5MTzQ1vkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/202] macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"
Date: Thu, 13 Jun 2024 13:32:26 +0200
Message-ID: <20240613113229.627523925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d301a71c76ee4c384b4e03cdc320a55f5cf1df05 ]

The via-macii ADB driver calls request_irq() after disabling hard
interrupts. But disabling interrupts isn't necessary here because the
VIA shift register interrupt was masked during VIA1 initialization.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/419fcc09d0e563b425c419053d02236b044d86b0.1710298421.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/via-macii.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index 6aa903529570d..9344452deaa3c 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -135,24 +135,19 @@ static int macii_probe(void)
 /* Initialize the driver */
 int macii_init(void)
 {
-	unsigned long flags;
 	int err;
 
-	local_irq_save(flags);
-
 	err = macii_init_via();
 	if (err)
-		goto out;
+		return err;
 
 	err = request_irq(IRQ_MAC_ADB, macii_interrupt, 0, "ADB",
 			  macii_interrupt);
 	if (err)
-		goto out;
+		return err;
 
 	macii_state = idle;
-out:
-	local_irq_restore(flags);
-	return err;
+	return 0;
 }
 
 /* initialize the hardware */
-- 
2.43.0



