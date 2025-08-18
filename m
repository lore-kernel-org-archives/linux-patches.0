Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCF53218CA;
	Mon, 18 Aug 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522523; cv=none; b=iaivkBf4gF4ZN6x/GC+55Ym0OeKuDFJqoH/eCNUFFM2ZKO8iZTFo0Ip03pWDLL9QFee8HIsFs38MCY8S2XPFPCmi3fLhcYw/A416mXK0wrLEjjazONSF1z2VC6YuwiGM7b60UOhgMrbL2d3S8eI9aMfMUwaRJ03QLwGgjxmegTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522523; c=relaxed/simple;
	bh=Nhc1kOhUeNf7yONQTRzyT/h3KwDtPuin59uNgUHnoB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZbpNmSex5bsBQgMF1/mo8H2wgAIEW3+vjR7WMVn907WP8118euDBQAIW1iuO4gMAaxoq1cAZAwP7MgApiAZuRW0TE6mWR12RgiXVDAnj4ZKTlqhWspnY7henr0fgtR5zdJgO5DJF7sdu4HNzcWf4CI/JUgDk8yqeOsHPeGSh7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb8niprb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb8niprb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E69C4CEEB;
	Mon, 18 Aug 2025 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522523;
	bh=Nhc1kOhUeNf7yONQTRzyT/h3KwDtPuin59uNgUHnoB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb8niprb+PklFboRhth9dTVvKVk4xHD+a3NALsraEY/L+wi4IIuGNnCQpEhv0NRFJ
	 nbas35Krph6qaacXPrwHqVzbD/G5cWpExsijlwmgT1BVHKYqSFOJRdB9u5+UKielMh
	 jJjbsiXDGCGhV+DnatSrbrzyEMVfOl+xOTFbPWY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/444] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Mon, 18 Aug 2025 14:46:08 +0200
Message-ID: <20250818124501.750211684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



