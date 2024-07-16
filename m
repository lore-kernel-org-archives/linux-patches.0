Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA1F19B3E3;
	Tue, 16 Jul 2024 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146142; cv=none; b=PWdm+HiR+2snqbVbKi/OcHLgnWJ+f2MZZ71K5RASKmlT5vLA5JQSKAM6QKOBus8yRYaxa2h2BzDNGZ9lVekjGmviX0C6QFUn1SFAwxOwiIVtAka8wnMmYCv1T3R4XC/gfbyvp4RbeEQHlbrhljnBM58GvpvI5bT9iBm15pVHIvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146142; c=relaxed/simple;
	bh=VrYtAdh3ZLxaq4bkw6S275Edze+YUScuM66WVbdDKNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpzqpf1cYe6VD2Ob7Mx4PS1/6hjSGtZcFIFPF4U7i9sS3mExgisUt+Ul70CAY5HVjwZ6jfRhlHA/3XZcenUzrvpCuj0Rv47s2MynV+EPAAZQpU/l5NuQz7WabQnarOAzPgJsdMzQyZ+DTzK6gl4yg3soO1sijhiPp7q8vkRC5rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HODdqMU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HODdqMU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3319C116B1;
	Tue, 16 Jul 2024 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146142;
	bh=VrYtAdh3ZLxaq4bkw6S275Edze+YUScuM66WVbdDKNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HODdqMU5Wz0ULyCNfFn+SDNacAMgyVH80R6JmLNbHAZSguBh59nKi3CqGT06HMGJr
	 EU30vDypKBoD0iNR8Zeg0byfxID1C2L49/PIgF4FgqgRL5i1O6g7Y5yqkRJEy1wSbu
	 +MyPi7O4ptn4fPdmzZ9+MZmgEbm4d4NCS4Xo4cfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Wylder <jwylder@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/144] regmap-i2c: Subtract reg size from max_write
Date: Tue, 16 Jul 2024 17:32:20 +0200
Message-ID: <20240716152755.276381342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Wylder <jwylder@google.com>

[ Upstream commit 611b7eb19d0a305d4de00280e4a71a1b15c507fc ]

Currently, when an adapter defines a max_write_len quirk,
the data will be chunked into data sizes equal to the
max_write_len quirk value.  But the payload will be increased by
the size of the register address before transmission.  The
resulting value always ends up larger than the limit set
by the quirk.

Avoid this error by setting regmap's max_write to the quirk's
max_write_len minus the number of bytes for the register and
padding.  This allows the chunking to work correctly for this
limited case without impacting other use-cases.

Signed-off-by: Jim Wylder <jwylder@google.com>
Link: https://msgid.link/r/20240523211437.2839942-1-jwylder@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 3ec611dc0c09f..a905e955bbfc7 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -350,7 +350,8 @@ static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
 
 		if (quirks->max_write_len &&
 		    (bus->max_raw_write == 0 || bus->max_raw_write > quirks->max_write_len))
-			max_write = quirks->max_write_len;
+			max_write = quirks->max_write_len -
+				(config->reg_bits + config->pad_bits) / BITS_PER_BYTE;
 
 		if (max_read || max_write) {
 			ret_bus = kmemdup(bus, sizeof(*bus), GFP_KERNEL);
-- 
2.43.0



