Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740830AD14;
	Mon, 13 Oct 2025 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369523; cv=none; b=QT6hEmdBft4R98/q0PU+i04BRVncIsgBvAWZ3Ri/P8Md4k4PgH+GeACxHKYeRbnmOYjMcKRlHU6kQYxT+SqKCAPXOdyZ9kOJAozT9TJ7PsTZpiDjkPz1iVpSlOe0zJlYnB+RTJYVpXs24IY3RTxzZoSSBsowmSJJzddvLvAU72w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369523; c=relaxed/simple;
	bh=BXpmzA7mIKgn659a/h1mDWIYjJ6Co+h5sULQlLZmsDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/K6xHSJoHlCWk0VP1rZyyXbG5fxidD+KHDGiKngHNA0uqSxgxJMYq5mXnathoVRWSKY3wboibqwoH5PpQgUeGNqh9kNUf3+hogJybAdr6Pttvo9Obiq4ZWkeQzBmlFx09PR2DNH0QKtXGmEfCaH4JfU1mYbjyVqSOFNRThsNnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rQfC+qA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rQfC+qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B19C4CEFE;
	Mon, 13 Oct 2025 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369523;
	bh=BXpmzA7mIKgn659a/h1mDWIYjJ6Co+h5sULQlLZmsDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rQfC+qAuRIPZu0X2z5962p0xz9T4GzIqNW8is6xJhqv0qD3gDfyylvNxlOAldm2b
	 Wxd+wULxKV6G7KQQUi94oE2TVpI1jtFih7EFI5JprauMwkrjqqpPOH7wBvopHDEdJ/
	 wwcsU6gmTQDGvaL0NYBapQe9ICTxebXGuZwg/mw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 277/563] ALSA: lx_core: use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:42:18 +0200
Message-ID: <20251013144421.307470597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4ef353d546cda466fc39b7daca558d7bcec21c09 ]

Change the 'ret' variable from u16 to int to store negative error codes or
zero returned by lx_message_send_atomic().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Fixes: 02bec4904508 ("ALSA: lx6464es - driver for the digigram lx6464es interface")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://patch.msgid.link/20250828081312.393148-1-rongqianfeng@vivo.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/lx6464es/lx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 9d95ecb299aed..a99acd1125e74 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -316,7 +316,7 @@ static int lx_message_send_atomic(struct lx6464es *chip, struct lx_rmh *rmh)
 /* low-level dsp access */
 int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 {
-	u16 ret;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
@@ -330,10 +330,10 @@ int lx_dsp_get_version(struct lx6464es *chip, u32 *rdsp_version)
 
 int lx_dsp_get_clock_frequency(struct lx6464es *chip, u32 *rfreq)
 {
-	u16 ret = 0;
 	u32 freq_raw = 0;
 	u32 freq = 0;
 	u32 frequency = 0;
+	int ret;
 
 	mutex_lock(&chip->msg_lock);
 
-- 
2.51.0



