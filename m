Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DDC222D58;
	Thu, 12 Dec 2024 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024039; cv=none; b=PhF9iscaQ9ckOO2Hzwle1D4zy7ttJ3/Il6wiTJHU4C5c2wEHXG1YBLh4flbS3qNb8eiRRqrdDRE/rrBkLqseutl+CTZZD9teM97qScQWeJHbDkvCBUUrCXI/iDcKxk4iOfK/l2bsE5Pj8c/Z+qodYXOkK2Aw8sSkO6mO/uZCZ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024039; c=relaxed/simple;
	bh=lbGdBacjiMPdXXjPyyX2PtC6gJbZc3CnTzYcFCgF0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg1AaywYlCnMNYRlmwiPJEF4zRpCV2/5uFl3psDgeMKS80JJQ+5vp6BM4OIR/E0B+wBhK4iw6w8z8AlK9Ki99kHhwgAtrmpNpaUOJPpR4DqMTwxRcxPB9INR4EyXaaTe3Egxl6c0qEewcfZjgD/Xc7QH+OAAuk64rfVBBqfZtpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGagNBoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGagNBoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C00C4CEDE;
	Thu, 12 Dec 2024 17:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024038;
	bh=lbGdBacjiMPdXXjPyyX2PtC6gJbZc3CnTzYcFCgF0AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGagNBoBT9W6a1wyY8SA9+IRgqO9oeo7tfCV5nqKNjK0BS2bKK+h+Gh5RmrE1isgj
	 dfrAQaOR7nsJsQLvWW8OSLTdmo9jjS3a0Zmaj2bEpYHUnQAlzEJ4Fh+KFlcroF2vXC
	 PW6JxJp0F1Kz/4c8RhREB1oKZI9PT6yA2KirWyXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/459] mfd: da9052-spi: Change read-mask to write-mask
Date: Thu, 12 Dec 2024 15:58:24 +0100
Message-ID: <20241212144300.072359911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 5faf3766a5e20..06c500bf4d57e 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



