Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181F13B791;
	Tue, 27 Feb 2024 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041723; cv=none; b=CSLB/8Zl9ncsBM0gC2CFon7L7VQ7YmMu2kqyrXi28ltkqsxNT5vPihk9NDuFT/TPnIfMNuxMx4A49Jcr4azDlXxcJ9h7aJ/3OKT/r37Vfr/Ig4EB37oLaMNvfNiqULrj2WL+uDu+kcRDVBozbSm4ArXiEXrJBNEMX6Weo0HEkYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041723; c=relaxed/simple;
	bh=A7dWaq57ci01UADpvf7yTDXLViF/ofyY/0a0GDLRE08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIn58OnW5KzsyEASNtWe/J5l8UNP8iSogpyEIG1YjBFkwnLIT95kenFDrCMY3kl3AaAk3Ls00PtTkgr2BzGQw29vTBXP3xCHvzEnV5Q+DqEPH6UyJ4yNbJNSq2BRMgizwQM5fVytG+sBlNSCd/dfZBb/a7MXRlQbQDdF/Y0i4R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbDdRrJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbDdRrJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8493CC433C7;
	Tue, 27 Feb 2024 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041722;
	bh=A7dWaq57ci01UADpvf7yTDXLViF/ofyY/0a0GDLRE08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbDdRrJ+exwuDaulbdAnBPYm3u0HHgH9fVjCsDsr1MAY4UUQt0wc6rHaLaS/gQa9J
	 GWnVtp5ab0Xf+42j8EEFiQvUrzyFe44hkz14VT5YEMP0EBhM+BOxh9iiKGfWlkfhOg
	 UX9WP/BfzEEukf7rsMMRYZ9aD52HxnAhkFggUxaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/299] regulator (max5970): Fix IRQ handler
Date: Tue, 27 Feb 2024 14:22:39 +0100
Message-ID: <20240227131627.524028860@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit a3fa9838e8140584a6f338e8516f2b05d3bea812 ]

The max5970 datasheet gives the impression that IRQ status bits must
be cleared by writing a one to set bits, as those are marked with 'R/C',
however tests showed that a zero must be written.

Fixes an IRQ storm as the interrupt handler actually clears the IRQ
status bits.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
Link: https://msgid.link/r/20240130150257.3643657-1-naresh.solanki@9elements.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max5970-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max5970-regulator.c b/drivers/regulator/max5970-regulator.c
index b56a174cde3df..5c2d49ae332fb 100644
--- a/drivers/regulator/max5970-regulator.c
+++ b/drivers/regulator/max5970-regulator.c
@@ -265,7 +265,7 @@ static int max597x_regmap_read_clear(struct regmap *map, unsigned int reg,
 		return ret;
 
 	if (*val)
-		return regmap_write(map, reg, *val);
+		return regmap_write(map, reg, 0);
 
 	return 0;
 }
-- 
2.43.0



