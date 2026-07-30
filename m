Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76A2299929;
	Thu, 30 Jul 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425682; cv=none; b=lepYSIANTl5BYDewmO4xh0yZLidBxlZj2tfgrAiMO6Ilh+l29BEAnKtpehzlGMZZ787qgf3JWjTZEuo7GnkQFIOJ3IsKVFrUib37pCNH0K41n4KMRgW7cmck34+7YppkqgIEXAFmshaQiWx6wJ7oSnVhjKg5EJEECAI37IktpVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425682; c=relaxed/simple;
	bh=xHooiC+OaFqlYv0hST1qU9spc2a/4xFma2WzzHeX850=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bl43gCK+0rbwmgfLsCoA5VFKZK75IK86ufy9f8w8YDYe9wLg5eLKRS+qkk8hx/rpT8gUTQbsaHSM9AGFSf64w/EsmozGh6WXO4jGywOPk0xU1XW011+APoh3lbzgs0BfgMKqZSN572hDel0uNJDNKdrCpNL7S5NNT3fesn1DX5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o66tGrfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o66tGrfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4DE1F000E9;
	Thu, 30 Jul 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425680;
	bh=6t58Wbv8qTL3NHOsO0IH8VjGm4Adj0/9u5cZcH6EFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o66tGrfMimDA5+hkZnCSuzIDECzVQZFgU5dLkWMaXq9wrnm9JY1oUUeusOkEVrY9C
	 srlMrVTXZUbqxLcBvMlYvHKZQXjQQRzkxPyQwWiaF/6U/X3rekOsws9VBFlvnP/rBw
	 /tYti6aGRvw+uNkgPUl+1YgoXvazUDx485xcqPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/602] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_get_acpi_mute_state()
Date: Thu, 30 Jul 2026 16:09:07 +0200
Message-ID: <20260730141439.231523593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 8527bbb33936340525a3504a00932b2f8fd75754 ]

Return value of a function acpi_evaluate_dsm() is dereferenced  without
checking for NULL, but it is usually checked for this function.

acpi_evaluate_dsm() may return NULL, when acpi_evaluate_object() returns
acpi_status other than ACPI_SUCCESS, so add a check to prevent the crach.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 447106e92a0c ("ALSA: hda: cs35l41: Support mute notifications for CS35L41 HDA")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 3b597d24dc04 ("ALSA: hda: cs35l41: validate and free ACPI mute object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index 099b8e9582b841..bc84415416aae5 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1403,6 +1403,8 @@ static int cs35l41_get_acpi_mute_state(struct cs35l41_hda *cs35l41, acpi_handle
 
 	if (cs35l41_dsm_supported(handle, CS35L41_DSM_GET_MUTE)) {
 		ret = acpi_evaluate_dsm(handle, &guid, 0, CS35L41_DSM_GET_MUTE, NULL);
+		if (!ret)
+			return -EINVAL;
 		mute = *ret->buffer.pointer;
 		dev_dbg(cs35l41->dev, "CS35L41_DSM_GET_MUTE: %d\n", mute);
 	}
-- 
2.53.0



