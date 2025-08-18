Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA82F32254B;
	Mon, 18 Aug 2025 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524219; cv=none; b=o7xDXx2ZGUxYFXAlXIYnleQQn48yQDTm0pVOixIUKbypfB9zNGNcjBznlAgTTdbdPhrE9sjHLr5Rcpo1kMjI0tEZ3Bjp6w6xOPnyPVU/GTifzwR9gUzBUlMbJF1dyqW4Js5Wx6IQYtY79sAESAe/GuW0R1etazzp235rVltRhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524219; c=relaxed/simple;
	bh=/lhBOVtBRyGSXGlU1BF7FO3s+hfqRaZGiCQjo3zpOOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTu3r3b0xAnKGmGTFlbuW8ODKHgaSZvMdFn+Bae2+2661FfMgkDRlsvM9HPPAYOmnykIi8RLKydo+v7lj1mul6n9ZwDaeftkPSAsp0Q/YUZhA4le6bR3t1yDoCjfX6ET5vj1WRX5MX9ZxGJUmVz5yIlmvP0g7+hXc1AugtvysBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMpt389E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMpt389E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61148C4CEEB;
	Mon, 18 Aug 2025 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524219;
	bh=/lhBOVtBRyGSXGlU1BF7FO3s+hfqRaZGiCQjo3zpOOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMpt389EW24rZdTiFR9GoAotg219Wcao+pWPvYAt5biaZlIY0OgseIG2VW/WIs6mm
	 Sso7eXeqHh/kd4L3LvrgNQAniomE2xC+G9NXrd7GFThXXw4BjbeI+bzPQdzkm2bgTF
	 zwQ8pccbWT6AUQgAx2QXm6ewBGlWk0130Yo/QBSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 405/515] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Mon, 18 Aug 2025 14:46:31 +0200
Message-ID: <20250818124514.003253849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

[ Upstream commit 5ac726653a1029a2eccba93bbe59e01fc9725828 ]

strcpy() performs no bounds checking and can lead to buffer overflows if
the input string exceeds the destination buffer size. This patch replaces
it with strncpy(), and null terminates the input string.

Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Reviewed-by: Nicolas Schier <nicolas.schier@linux.dev>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/lxdialog/inputbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 3c6e24b20f5b..5e4a131724f2 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -39,8 +39,10 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 
 	if (!init)
 		instr[0] = '\0';
-	else
-		strcpy(instr, init);
+	else {
+		strncpy(instr, init, sizeof(dialog_input_result) - 1);
+		instr[sizeof(dialog_input_result) - 1] = '\0';
+	}
 
 do_resize:
 	if (getmaxy(stdscr) <= (height - INPUTBOX_HEIGHT_MIN))
-- 
2.39.5



