Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C19313B2AC;
	Tue, 27 Feb 2024 13:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040626; cv=none; b=t0jiSDIo5bwyntPzpJayFQ+Som9M+ixU3UPBzg1AYdl/+69ec6pQo5J9NjNwJXjlo4VCiKK3gnhWP+GkE0d5pQv+hDAUTTiGJ73IIAIrrddkNb5ODukmwQ7N0LGhz+ikjTQ0ogIuJWheLH3J7f5P0ICzEpj+57x86gpuOZcqBRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040626; c=relaxed/simple;
	bh=JtyDt1sOK/jAWpgbgNvNp45sxNrXKLMyFQiw8aC84Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ayt/0ctWr8N1MGyaXcsRKlJvYB15fD89PRmXNFXZhnaKEPFZjObM0Vxfro7YqvcXLiQkSFiw4Vkp1T1w/zUR8MJvWiqaqCTkKkH9n1Zmna1JaUnA2YEoDJQZVUVKIHS7OH9jnPYDpqtrTVWaJwagMPP5DJovdEywmo5ojnwa0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIEgdaS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIEgdaS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC3BC433C7;
	Tue, 27 Feb 2024 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040625;
	bh=JtyDt1sOK/jAWpgbgNvNp45sxNrXKLMyFQiw8aC84Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIEgdaS98EMSgvV3lqTSExTAY/d0zQyXvQ12m8551qhgaIX+p/QfL93nfJR3RtJ1U
	 hla/REF4RuKEtp0Zva/++J8UKM1PI/UpKKJrh8xLffYqvR3tdW0UlE2cUJBhwD4omT
	 Ctkve47ZsbeDA6Xdi5rpaN1/z2oLEA2UPB0a9fjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 051/334] regulator (max5970): Fix IRQ handler
Date: Tue, 27 Feb 2024 14:18:29 +0100
Message-ID: <20240227131632.227822086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
index bc88a40a88d4c..830a1c4cd7057 100644
--- a/drivers/regulator/max5970-regulator.c
+++ b/drivers/regulator/max5970-regulator.c
@@ -392,7 +392,7 @@ static int max597x_regmap_read_clear(struct regmap *map, unsigned int reg,
 		return ret;
 
 	if (*val)
-		return regmap_write(map, reg, *val);
+		return regmap_write(map, reg, 0);
 
 	return 0;
 }
-- 
2.43.0



