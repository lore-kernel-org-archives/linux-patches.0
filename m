Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC2E30506B;
	Tue,  2 Sep 2025 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819400; cv=none; b=atz4VQkJCId7lnUDqGqse+RpaOco8I6d2vSXtvfK8c+wU/yFny/WKN2jfucorf/w2ebJkoIkVqb7QpnEw3ciTxQ4HghwEdP20PmKqHBHyoVvMiwYNkWx8JriMi/L6SYgAWcyOjbQmBMDT3Gr9fpRKdUyPz3ms6N6bY52V0B1hBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819400; c=relaxed/simple;
	bh=jlkZM12ZWpIxu8Y29NyvABNpa7V3Lkamc7b/HcEOzuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJlDbMrtI+bAIU88EcxITEnScmBExvPn6HJxnV3dq3KQcRdobkzDZdhQ67gHtod6Lj8xOcM+6ytESZTcqaqxhtJoPP1z703GStk/NnHlosKdsgPqd4pLAnYm09JKh6modd5/2AzmymmmK3wEfXQmHq/5NjUeR0SF3ZqxkwT1E4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYsmpYar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYsmpYar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26D7C4CEF4;
	Tue,  2 Sep 2025 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819399;
	bh=jlkZM12ZWpIxu8Y29NyvABNpa7V3Lkamc7b/HcEOzuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYsmpYarx96SYAlZmiQqx29K/rbCqqdiQCjxoZ2OEc6x8cSi8y75CZXZD3+FZO1le
	 1x/f02CyqehzZBN+GEzdX/I/bYilvCzPsBrro9sefXKZfrK5LDctpin8huum/u+X+w
	 ZqJclv+JcBoQ/dex+YasuosAMcloFeVOyHTp3yTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 022/142] ASoC: rt1320: fix random cycle mute issue
Date: Tue,  2 Sep 2025 15:18:44 +0200
Message-ID: <20250902131948.995721347@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit f48d7a1b0bf11d16d8c9f77a5b9c80a82272f625 ]

This patch fixed the random cycle mute issue that occurs during long-time playback.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250807092432.997989-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index 015cc710e6dc0..d6d54168cccd0 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -109,6 +109,7 @@ static const struct reg_sequence rt1320_blind_write[] = {
 	{ 0x0000d540, 0x01 },
 	{ 0xd172, 0x2a },
 	{ 0xc5d6, 0x01 },
+	{ 0xd478, 0xff },
 };
 
 static const struct reg_sequence rt1320_vc_blind_write[] = {
@@ -159,7 +160,7 @@ static const struct reg_sequence rt1320_vc_blind_write[] = {
 	{ 0xd471, 0x3a },
 	{ 0xd474, 0x11 },
 	{ 0xd475, 0x32 },
-	{ 0xd478, 0x64 },
+	{ 0xd478, 0xff },
 	{ 0xd479, 0x20 },
 	{ 0xd47a, 0x10 },
 	{ 0xd47c, 0xff },
-- 
2.50.1



