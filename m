Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DA153816;
	Wed, 21 Feb 2024 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521255; cv=none; b=IRm2WfCAmlTnoxrVRnDomM0plQy/uf792X5SkoGim4OPBzIEvlF0rLNbVqDKR38hr7+ec0G6MtAQptiJGj6LsUdzPUhz2afQ8DQaGe29g0FwRdlzfhM3JsufWmWmDhDIizSXSphjOKHRw5LApe2AGcOmrTAaRP1HJeFrO4aSKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521255; c=relaxed/simple;
	bh=8C7t+WNKrkhGU1/I57HVYE1noqlD578F0tg4xjgHdLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjD6cyTpbw+xQrZj4JZwM8dKJzcM9XY1JmMvb4RoDm72GxGklNmqUrWyVv3syaLbJlbfxJePkAoYdqsKGYp5yZGAsFanM8p48OYaYfVJZfiOOmUZWV/OmIV4mf1SLUO9QQacY7tBQK260ZKUM8kIpynYUbEEZNTTZair7Lc2Rrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pG65JAGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pG65JAGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0BFC433F1;
	Wed, 21 Feb 2024 13:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521255;
	bh=8C7t+WNKrkhGU1/I57HVYE1noqlD578F0tg4xjgHdLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pG65JAGGm5m6/5BidprTR2Rv0x2yE0+icVIrHDVSBTR78KM8SSOV2qTeIkcEIV1sa
	 0SZfV7/4Yj7Su9XoonZrH5lTjtEjKk0gs4i2hkThiGPPJLZRpHtSWDU7P1jCHy4pS6
	 wLnXf0wnN59d67zVOS8iqtaHJNiXIJg+xfj/Po54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weichen Chen <weichen.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/202] pstore/ram: Fix crash when setting number of cpus to an odd number
Date: Wed, 21 Feb 2024 14:06:04 +0100
Message-ID: <20240221125933.875031822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weichen Chen <weichen.chen@mediatek.com>

[ Upstream commit d49270a04623ce3c0afddbf3e984cb245aa48e9c ]

When the number of cpu cores is adjusted to 7 or other odd numbers,
the zone size will become an odd number.
The address of the zone will become:
    addr of zone0 = BASE
    addr of zone1 = BASE + zone_size
    addr of zone2 = BASE + zone_size*2
    ...
The address of zone1/3/5/7 will be mapped to non-alignment va.
Eventually crashes will occur when accessing these va.

So, use ALIGN_DOWN() to make sure the zone size is even
to avoid this bug.

Signed-off-by: Weichen Chen <weichen.chen@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20230224023632.6840-1-weichen.chen@mediatek.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 33294dee7d7f..0050aa56b0fa 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -590,6 +590,7 @@ static int ramoops_init_przs(const char *name,
 	}
 
 	zone_sz = mem_sz / *cnt;
+	zone_sz = ALIGN_DOWN(zone_sz, 2);
 	if (!zone_sz) {
 		dev_err(dev, "%s zone size == 0\n", name);
 		goto fail;
-- 
2.43.0



