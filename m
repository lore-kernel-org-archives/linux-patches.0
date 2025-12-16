Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0F537C111;
	Tue, 16 Dec 2025 12:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888594; cv=none; b=PTvbLFmQ981r9Fys0BRkfoDSrWbZar11RrLIFgoxPxbSdzfHRQg3XrJAulDzsPRQHCLV39ukN9eV4WB5mRfs+KBtjZqPByxrhL4TNrq1lH+rqn4vh391NQTqbajEIgylDwV3tZYcnnQhHd0t6CfEpSOpgostjW9vv+Xl0pw2YKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888594; c=relaxed/simple;
	bh=Kd1XcAArrzD/2yqQAcYPvMcdQ+iZeJ7LcAjzivmXDlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5BY0wS/RZalGAfbbWY32SruddyPKeKXzWzVW/cccOqCMYYa1Dr7KF5isroYfxcO324s8fgdHpBTyHrCSkaXlisOYMiJVz25FuczNCDj34OyVvJsh0IsSAoLiZz1qkfpuW4iz+wMXw0tttlcSEnF/VXIL6Xl5utnNBt7qlO2RdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/Tu0LPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/Tu0LPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D72C4CEF1;
	Tue, 16 Dec 2025 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888593;
	bh=Kd1XcAArrzD/2yqQAcYPvMcdQ+iZeJ7LcAjzivmXDlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/Tu0LPvWp6SVW7AYX8azrdNw1CZlV59/ifGZVI80I3ediHhATf9vmpEjZYXHR+/4
	 G6plpB/ZM1sST1PIe6tSsSXCnJQ2eXgXjoNi+EOIiO6ibHR8bRccLSQYvujm9dSCvj
	 7S0K4GlXABNATpclXZbJEFr0ttDl5pHy6+RJHP1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Link Mauve <kernel@linkmauve.fr>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/614] rtc: gamecube: Check the return value of ioremap()
Date: Tue, 16 Dec 2025 12:15:47 +0100
Message-ID: <20251216111422.401292624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d1220e47e4bd2be8b84bc158f4dea44f2f88b226 ]

The function ioremap() in gamecube_rtc_read_offset_from_sram() can fail
and return NULL, which is dereferenced without checking, leading to a
NULL pointer dereference.

Add a check for the return value of ioremap() and return -ENOMEM on
failure.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Link Mauve <kernel@linkmauve.fr>
Link: https://patch.msgid.link/20251126080625.1752-1-vulab@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-gamecube.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/rtc/rtc-gamecube.c b/drivers/rtc/rtc-gamecube.c
index c828bc8e05b9c..045d5d45ab4b0 100644
--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -242,6 +242,10 @@ static int gamecube_rtc_read_offset_from_sram(struct priv *d)
 	}
 
 	hw_srnprot = ioremap(res.start, resource_size(&res));
+	if (!hw_srnprot) {
+		pr_err("failed to ioremap hw_srnprot\n");
+		return -ENOMEM;
+	}
 	old = ioread32be(hw_srnprot);
 
 	/* TODO: figure out why we use this magic constant.  I obtained it by
-- 
2.51.0



