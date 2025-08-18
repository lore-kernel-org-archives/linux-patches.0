Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF4321F43;
	Mon, 18 Aug 2025 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526035; cv=none; b=YS24SZ9bM5etGrX1ZdVVRNa1YLbhyqUAEsJj+bzEbOq5DcFy8VsVAKsjEs8O2bDRsnv1Eel6p5elhTCF2NFy82+V458Hs7JHWsxAMTqe7aU1dO3iZRlcI6oXv3okMMfO6VSnlB8Q+OCzaRUbyaLTQiBoKgckHo/ahKpBbxTUjGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526035; c=relaxed/simple;
	bh=zUDGUIG6HV9cQyhud3zhgcgruEnWXu7htXfjegv6HbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um0SoJwVFEOi9QXvDMMbRAtTzP0R1D1/Kgc6KS3XwNpVu5UiBPrtUGJ4DHuwocYJfkbI5ZgicX4ndqT9b0eLfDT+pjM5wDQogStulcgSuTX7Xn+wffBM5sYG8Q+o+p+1HZfSaDnfw0g4QWRRTAFbQJYdEFA2F2B+jT2O85BQGh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAvB37mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAvB37mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D974FC4CEEB;
	Mon, 18 Aug 2025 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526035;
	bh=zUDGUIG6HV9cQyhud3zhgcgruEnWXu7htXfjegv6HbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAvB37mQmy4kZ+WIfm29WRDAGC3VE++jD6Q94ydjDMPKGPrNCAS/pd21LH8FBCZpt
	 hhrUEYhWnz82Fk67haFvjug8i1ycRmsZhShvfJiNTnc1sEPgHHsbZq5M2wzZz/F3ev
	 nCQpqUHiouQUJ2EmJfZkvVuF9KT7JgASqBu+Gy9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 439/570] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Mon, 18 Aug 2025 14:47:06 +0200
Message-ID: <20250818124522.735815408@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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



