Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CFF7DA78;
	Thu, 15 Aug 2024 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728743; cv=none; b=hs0cJnkmwAJOSaUzfKT4a9D8RASoBOGnrnUpSI4u1kGgXPiQRUS6vMg246o7WpCdyNez5RIs3cT6Eef5pGQoUmjSlXoGNAjxUZPZ3+KST9xHV6fWvHkaZi5yiWtEjmmgHFXP7Bg+ddsGF20Xb2A2mFFYE+XPCsuaqdTLOx4iJxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728743; c=relaxed/simple;
	bh=w+ulAHe4Zcr9YZszLM71nnTOS0/1gez5NFwnRvRwiic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azXaD5AudpdbHGThNmeXyTdfTWEhA1LtLebHLjkzrx+lAhx3FShcDBqKoMIm8d+2SUOdnza+MGI06ovDo840GkEqNaKsKvZQiMLJ7K0dq1BUvb4LygRe8cyCnCePmPpYcy2ixgV+VDPbJk9tS2RjkseUG9KXmf4B0Ijv3dN5dQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7xx7qsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7xx7qsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97596C4AF0F;
	Thu, 15 Aug 2024 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728743;
	bh=w+ulAHe4Zcr9YZszLM71nnTOS0/1gez5NFwnRvRwiic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7xx7qsaCWdH/XbR7zjOyOJPjNzXAU2etHakvTKGkc6Hr/co1wyiDu+auQy7UqUez
	 VLSd6nKig4njsB7j5bfD/M6jFhvj2XKOQ/9Q1KSdOxX0kXw5IqFZu/9jLcslKaNHPM
	 S5GZfm77JRO7dCP/jA0hAI3Tlh3k0TKUf4BRp4ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenlin Kang <wenlin.kang@windriver.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/196] kdb: Fix bound check compiler warning
Date: Thu, 15 Aug 2024 15:23:32 +0200
Message-ID: <20240815131855.717225484@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

From: Wenlin Kang <wenlin.kang@windriver.com>

[ Upstream commit ca976bfb3154c7bc67c4651ecd144fdf67ccaee7 ]

The strncpy() function may leave the destination string buffer
unterminated, better use strscpy() instead.

This fixes the following warning with gcc 8.2:

kernel/debug/kdb/kdb_io.c: In function 'kdb_getstr':
kernel/debug/kdb/kdb_io.c:449:3: warning: 'strncpy' specified bound 256 equals destination size [-Wstringop-truncation]
   strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Wenlin Kang <wenlin.kang@windriver.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Stable-dep-of: 70867efacf43 ("kdb: address -Wformat-security warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index acc8e13b823b2..5358e8a8b6f11 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -459,7 +459,7 @@ static char *kdb_read(char *buffer, size_t bufsize)
 char *kdb_getstr(char *buffer, size_t bufsize, const char *prompt)
 {
 	if (prompt && kdb_prompt_str != prompt)
-		strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
+		strscpy(kdb_prompt_str, prompt, CMD_BUFLEN);
 	kdb_printf(kdb_prompt_str);
 	kdb_nextline = 1;	/* Prompt and input resets line number */
 	return kdb_read(buffer, bufsize);
-- 
2.43.0



