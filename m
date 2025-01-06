Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B26F1547E3;
	Mon,  6 Jan 2025 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177277; cv=none; b=uSXt9yqz6MaFhBeZCfHqBOl5OZSxboJZLVf2tjveYKcZOFMW/IckVdL8BbHPOBmRTGBbCX9D79vJjfMVRPR9rszKzvPAlwyEDbGwfTyB/+6Cwj05VHPtnnfvWxNBGrz+nzJavcLd3hxcWQQ35pW9HV2P/DTymHVFGZZAvprxFlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177277; c=relaxed/simple;
	bh=xQ6L47s3wety9LCJNN4G/ykXdqWFqPVWgUPugcxJJCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0gEb9+G3T3rWXgylKFHgH5/8UMNSUvJxnF/t+WLEhg6jTQ1N/nlR0g4vDlIqafmdhx39W2cP+mPTrNV1Iz6Eb2dgai8Es6xJ/ObZJTcLaPDku/EHbZvxk4YIQ0dODva0Aq4M6eekDiHuSke9BZZPGTJEgy1ruHG2PIRq3JHQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYWN8a9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYWN8a9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB6DC4CED2;
	Mon,  6 Jan 2025 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177276;
	bh=xQ6L47s3wety9LCJNN4G/ykXdqWFqPVWgUPugcxJJCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYWN8a9oSnbRG02HLuCy3E+kHDPDKfaIo/O1O+I1hn/eKXB2uD++lpb+xahPGUB2H
	 2r7jjzziLVdLZivRJ95eWQVQK3Vd+pmXNblKf3YYZ1awbOkdtzsF+Kh8ZXzNkHB+c5
	 kQIGZhOnuDyt6JH6uUxSDS2f3F0HhxhNJHW0HkDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/222] ALSA: ump: Shut up truncated string warning
Date: Mon,  6 Jan 2025 16:15:14 +0100
Message-ID: <20250106151154.760716935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed990c07af70d286f5736021c6e25d8df6f2f7b0 ]

The recent change for the legacy substream name update brought a
compile warning for some compilers due to the nature of snprintf().
Use scnprintf() to shut up the warning since the truncation is
intentional.

Fixes: e29e504e7890 ("ALSA: ump: Indicate the inactive group in legacy substream names")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411300103.FrGuTAYp-lkp@intel.com/
Link: https://patch.msgid.link/20241130090009.19849-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 4aec90dac07e..32d27e58416a 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1251,9 +1251,9 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 		name = ump->groups[idx].name;
 		if (!*name)
 			name = ump->info.name;
-		snprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
-			 idx + 1, name,
-			 ump->groups[idx].active ? "" : " [Inactive]");
+		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
+			  idx + 1, name,
+			  ump->groups[idx].active ? "" : " [Inactive]");
 	}
 }
 
-- 
2.39.5



