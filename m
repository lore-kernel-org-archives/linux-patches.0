Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D2D1448EF;
	Thu, 11 Apr 2024 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829626; cv=none; b=tH7YeevhDIRK3etWj5SzVOgr/TlOS3tspWVAhpjAG+cdEYILZ4Hsz4GlA2OOX7qJGI/WjMywXpiXXBOTCgb0fKspGehtvNpCKXNzhtC/gI5DZsMfDiJkYpDefM1LKjVyxu5G/9zM6b1I73z1BhTcM9NllvAe5ajNyM4mM8x7OtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829626; c=relaxed/simple;
	bh=kFcCY0jBrGth3D5oRkAw49QN2vyFEm0ffEv903LiP8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah+bybXsqfl9OC9FkP4lDbJ01A2IkMJ22lJnlG5EE0tOTZnArgtlj1vMJ/b4km0akdeZPLQL5n/5HPT5u5H2f+su0PJh1R3Lplgg3S7FnlKUTKow/qLNGvfradXYK1R/2B3RAbGQwDpA8ewgxFdZSckDObQ3NOjBdhmSf/2PWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoNRDSqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoNRDSqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B0C433C7;
	Thu, 11 Apr 2024 10:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829625;
	bh=kFcCY0jBrGth3D5oRkAw49QN2vyFEm0ffEv903LiP8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoNRDSqOOlinMtag2NcPXDTRpnosIHM5ARC90T7TrAlW/WAdhjn92WbgIEK7o7pbM
	 TWYcMrabc7xbnOb/ZgABBd8vIAYXP/AmUmnzAlyqSSJz99ubu/SwlwlvxSexnyxFO8
	 9jQEFpTeKhto7nDeHbUHKIA3ZFXjwBVgajnyk/ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/175] speakup: Fix 8bit characters from direct synth
Date: Thu, 11 Apr 2024 11:54:34 +0200
Message-ID: <20240411095421.104409121@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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
 drivers/staging/speakup/synth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 3568bfb89912c..b5944e7bdbf67 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
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



