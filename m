Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524C4218EB1;
	Mon, 27 Oct 2025 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590463; cv=none; b=DhOFTfdLm1hn2ktUVZ8cRrEEtss4QzUqZJt3uUSlhBi09bGqC1qwVXDivRVwuaTsF/cf/mMZCMzBDzZstHL7p7ujx/rviayQSMIvjIgOkjvbgseD/6ZY5b87c2Z3ZPU5txc4HXpj/zpPyRkouTjdq/jVU7ZH9QywrJiHCENtQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590463; c=relaxed/simple;
	bh=QdJo763C+KJmoOVfclMaL4uFwLJ6qmlEBjaKIzaBff4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thc+nWXbrEM59PkG54P93uj/QdHHtHaSpwsYrl2rq6wNoo5Rd6WOpsFuTZkcZsOldr59pLjH2XmLyTTVYx7iSrXVKcPx2GzAl+d7RWvKmzkUd7GY5rqEP8U4nv1WxvKUUXI7ascJyYu8cbR3KFkpPBHkaZXI3cCj6f0Hmmisi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQufZhUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQufZhUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB175C113D0;
	Mon, 27 Oct 2025 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590463;
	bh=QdJo763C+KJmoOVfclMaL4uFwLJ6qmlEBjaKIzaBff4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQufZhUAvrZfpqv00+2jMY0VsS3eIxTbzoTVJnDi8RVn3u7DnBCpyjhBg4CrC0JFe
	 6eFd72edvTtX1tNH/zAUZDS5mHA4TJqn9n6hGz0c09Ge9hxPwKINFbl0NzxIUdxREp
	 f7WcnE8Ovk05xmDatuqpjikG/1pjC2ERqzZFBbMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/224] ALSA: lx_core: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:33:03 +0100
Message-ID: <20251027183509.998290753@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 00975e86473c5..6cf7572779d41 100644
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



