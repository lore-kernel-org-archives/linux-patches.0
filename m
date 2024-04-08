Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5366A352;
	Mon,  8 Apr 2024 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581744; cv=none; b=uP1WCPtgmeqnRHgkf2P1JOlDYTl5T62naNjpZJTgnw761EiS80foT656uEKLVPNY1TCuR0oVDjvzlh5J+g65wQrAaFTPWh6F/MAv2bb+ztXDsPeYw9hEaot1k80N/eIMCw+yRLGDHb0yyVAZBV8fUznLxKOg/x6r7S1CBwTVsec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581744; c=relaxed/simple;
	bh=B5jjnMfOxAw6k3WfnLcLiSHbno77qpKx8Yr3ZGJPllE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgPycyedbQ8aFsb6bRPgs96+/muTX2FzBAK+bU3dsG3YOI4w2s8nxCKfr5aQtdfqdocX0ayH/zU+wTst7EfVNG69qTp92LKizsSlfXzHt7sFeKCuuMIIpYycSUBCCN7ghg4+ylpgo3EVQ2bgKe6HL5k7ZMYtw3AgzaaG6znPMzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9BBFj8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9BBFj8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC882C433F1;
	Mon,  8 Apr 2024 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581744;
	bh=B5jjnMfOxAw6k3WfnLcLiSHbno77qpKx8Yr3ZGJPllE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9BBFj8QpjL6fyOct49Fu+uVE99toglURqaHPR40jdrc5PasJfmJDytXRKLlQC4CP
	 QQdy6ATOf7eMKkH1e7kmPglEuF6cy/2D0wLvkS0648Gc/bf0i2Mr7TtDOAKjCVebnD
	 A8M4FDODU4+sbAc3w4DakKDLCNpkyxl/UMOjEcA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/690] speakup: Fix 8bit characters from direct synth
Date: Mon,  8 Apr 2024 14:49:05 +0200
Message-ID: <20240408125402.365606063@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b8699673bace..1e10f3c9567b8 100644
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



