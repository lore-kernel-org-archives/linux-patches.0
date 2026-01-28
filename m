Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A75288C22;
	Wed, 28 Jan 2026 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615458; cv=none; b=c7AyU5FS40th78RuRAdwBAQV51mvfERVo97JFGl0iVLy/USNLbYkg5Dj27C1hCTM2ne8OH97Ax1Va+YGsP9slK824lJqhvPV/NWherKahJd61EOazX9DEzRjLz1NVPm5Pb6w+Xmmw3FAnvqLD/GnZqFK2hp7kcf18Vg3AaCbIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615458; c=relaxed/simple;
	bh=x8PDpgvEnJ6UyVoJR8cohV9QAhRm4v6oMqp7WkRpWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5rxHmXsCM+WIjQKr14KB4wcwiz4jDJUvkM2igVnKDvyYOfcebvdcwShorc7VpUDCX9rvsdIJjcyHmorHUBU66G6uF5+7FMzb1sWryR8t7tK2x8JBv6fmAsYqxE3HJsmxFi3UTPinfUXe4N8aKb8w4eqzZrsirvfV73gaJwD5TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOT55faZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOT55faZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB710C4CEF1;
	Wed, 28 Jan 2026 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615458;
	bh=x8PDpgvEnJ6UyVoJR8cohV9QAhRm4v6oMqp7WkRpWo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOT55faZJT/fNyNJ1KwbDVeWWUy2QYV+3KlqoWdJN1TZ+XE7s1qcoYB78aEzctA7Z
	 LulNO1KMj0jvdEvQvepk0Iwfpb0J5xr/bouwDge+qIhRafdQYf5/Ol9TuWQMbrC8Le
	 gy+eNAanxmkMARahBGwrpGQ8jd/VfoSg27iYAZMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/227] ata: libata: Print features also for ATAPI devices
Date: Wed, 28 Jan 2026 16:21:01 +0100
Message-ID: <20260128145344.927746288@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c8c6fb886f57d5bf71fb6de6334a143608d35707 ]

Commit d633b8a702ab ("libata: print feature list on device scan")
added a print of the features supported by the device for ATA_DEV_ATA and
ATA_DEV_ZAC devices, but not for ATA_DEV_ATAPI devices.

Fix this by printing the features also for ATAPI devices.

Before changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133

After changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133
ata1.00: Features: Dev-Attention HIPM DIPM

Fixes: d633b8a702ab ("libata: print feature list on device scan")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c41714bea77e8..699919e4579e1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3119,6 +3119,9 @@ int ata_dev_configure(struct ata_device *dev)
 				     dma_dir_string);
 
 		ata_dev_config_lpm(dev);
+
+		if (print_info)
+			ata_dev_print_features(dev);
 	}
 
 	/* determine max_sectors */
-- 
2.51.0



