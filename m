Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13DD3D961;
	Mon,  1 Apr 2024 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988243; cv=none; b=F/hKlg8grG/yRkwvCfTiAWBaqC4E3kxeVtkK4mDHPmYRVwKOJC8CslVned0vA0qPji7RlMgy+bEZX5nR0AbbZiCUif0YpLFOZhcNDbq9Rj+9OF1dng8TweNduckn97XjsZnzFJLb/HCMqAm4oz1mduLNL289VLkoM+UiXy+Ls/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988243; c=relaxed/simple;
	bh=94yy2E5QZjk7lqy30FoR7EbSwuM99wZ09dctHN7IcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6rrcmXzTCZiurKeeiwxRwQIFfj7G0gYT9Ws2Er3ogUmlEvm5KmwOMiqmB7xswTCYJJMmphUGqoNbJHcy2wB4X1Fu30ZZsMQesRx3LnG3Qtl7maY5bjbHe78L2BTWaHnvtPNR8jAxb9dOUhrcD5DW4TU22JsLvAirvOn93asfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GdGt6BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GdGt6BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF75C433F1;
	Mon,  1 Apr 2024 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988243;
	bh=94yy2E5QZjk7lqy30FoR7EbSwuM99wZ09dctHN7IcQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GdGt6BHowXw2hpuSyUFFxzbXfmdTrYfK4olLSWcKnibGpPpREtpfFnI3LYd6qGbD
	 zzGkAaY4oCh0pqh16rEPXUpiwmB14G577V89EKvPIvYMbY/fC6dvkamsmIYRNU6pSO
	 3SkE2qc/OXEW87qaXN+6RUdwNY/GgOXu/9r9MEpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 126/432] speakup: Fix 8bit characters from direct synth
Date: Mon,  1 Apr 2024 17:41:53 +0200
Message-ID: <20240401152556.883379334@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit b6c8dafc9d86eb77e502bb018ec4105e8d2fbf78 ]

When userland echoes 8bit characters to /dev/synth with e.g.

echo -e '\xe9' > /dev/synth

synth_write would get characters beyond 0x7f, and thus negative when
char is signed.  When given to synth_buffer_add which takes a u16, this
would sign-extend and produce a U+ffxy character rather than U+xy.
Users thus get garbled text instead of accents in their output.

Let's fix this by making sure that we read unsigned characters.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: 89fc2ae80bb1 ("speakup: extend synth buffer to 16bit unicode characters")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240204155736.2oh4ot7tiaa2wpbh@begin
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/synth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/accessibility/speakup/synth.c b/drivers/accessibility/speakup/synth.c
index eea2a2fa4f015..45f9061031338 100644
--- a/drivers/accessibility/speakup/synth.c
+++ b/drivers/accessibility/speakup/synth.c
@@ -208,8 +208,10 @@ void spk_do_flush(void)
 	wake_up_process(speakup_task);
 }
 
-void synth_write(const char *buf, size_t count)
+void synth_write(const char *_buf, size_t count)
 {
+	const unsigned char *buf = (const unsigned char *) _buf;
+
 	while (count--)
 		synth_buffer_add(*buf++);
 	synth_start();
-- 
2.43.0



