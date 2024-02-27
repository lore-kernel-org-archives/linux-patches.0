Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A2E13B7BE;
	Tue, 27 Feb 2024 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040527; cv=none; b=F/aCa14fQe20hwo8uhpgQXAwF19+oN4CLsjQsjrDoBL0PZSyuI4OqvXLK1CE1aZ0Phcf9PuvvJ5etbNbce9/PF4tza+O3JIjHtIIMB857/mNm6AGqXdbu0Nqg3n/kQcg3+DiidKVLm4pmvB+wEwvHWImcYWgEXJJWGEu2LJ/Anc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040527; c=relaxed/simple;
	bh=UYHKf+D4jQB6O3bCTeizUcIjU4MjHQv4ZBGd0RWNSsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vjiahc6M22Htr5juBEC+LgJOI/Dec6P40D2GSN1qb9eq3dHpJ2SCbcsKpO968As89Gjy0T8dNhV6t7/PoIl+C32brmLAxLws8E9ib8JY0Q36KivarwBM2hgk+RrJllIWjTceEKrE6qQf8ghAAlcW65+Y3yVoKqyIEkzqt8VX5f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgPmquaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgPmquaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51009C433F1;
	Tue, 27 Feb 2024 13:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040527;
	bh=UYHKf+D4jQB6O3bCTeizUcIjU4MjHQv4ZBGd0RWNSsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgPmquajrLpk6rvadbun5EjvnT6hyE4dciLUzsw4EmP3GPvdNBwd9VTmr6VG0MYKF
	 A/6YgzzqQVVdmH3lMqNFhcyqSu67y8IxVCt3xaQvfMQDpI4WoznNe3AgDm6i6gDq9L
	 sV2pbG4mUwBuJz27p9K+2XcvMUv8FLz5KTZrhVp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 017/334] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:17:55 +0100
Message-ID: <20240227131631.172372254@linuxfoundation.org>
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

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit e421946be7d9bf545147bea8419ef8239cb7ca52 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of pixclock,
it may cause divide-by-zero error.

In sisfb_check_var(), var->pixclock is used as a divisor to caculate
drate before it is checked against zero. Fix this by checking it
at the beginning.

This is similar to CVE-2022-3061 in i740fb which was fixed by
commit 15cf0b8.

Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/sis_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 6ad47b6b60046..431b1a138c111 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1475,6 +1475,8 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	vtotal = var->upper_margin + var->lower_margin + var->vsync_len;
 
+	if (!var->pixclock)
+		return -EINVAL;
 	pixclock = var->pixclock;
 
 	if((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
-- 
2.43.0



