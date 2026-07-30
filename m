Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4643F0AF;
	Thu, 30 Jul 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427091; cv=none; b=C8NduGe61y0A9DEbTHqGXdfRr709IIQkEocIfMs8tf86ukcdGQBW50heImEjC85vOnu4mwgz6FaHmC1MzTTaPviFfPTuP3H6hWAoYUHMps4HTai5dV56deLqZNZbZIjyf1dtQEe4cS06y8MfgpBbR4WRxZOwqZOmD04+ZFsmj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427091; c=relaxed/simple;
	bh=FwW6H093ATQfUEWLA0V+2Ow1TmOvmuQf44bWWSCjaEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUe9hYfkzydLbJ8XhKxJfVwLc3pkVF5jAjN5ARngErGDq8TZW0ri5D9cppextpjXGVWPINL8FVrHunBs9S7sxtIz4z6uMYvfssCHhY2TbvNO+DKQjnZn0yWnDCGWPt5qELAS3FAn7lbHy42y7WRbkikhoGSPY5c1AbJhj9W36+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFvC7Byq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFvC7Byq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708281F000E9;
	Thu, 30 Jul 2026 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427090;
	bh=jl7Em/fFZ7LI3Q/XjmsAeh4qpRpPxAKT3qLucy7Ag1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFvC7ByqOUzkZUEVsspgAQ3R335gRodkN0Y8qfeaTtvcWwxzKwzYdmvXqXltK56qb
	 SYPyQ7mYeHkU85a3WusJyZ5ZoNGbsqq46dxs6POyujS1IzJwgLwOzpIwCIRcVuFBdZ
	 kVQyzWMbPCrkA3Gcd+a1Kb/x7ApJv5C2oNDYUt3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/484] selftests/alsa: Fix memory leak in find_controls error path
Date: Thu, 30 Jul 2026 16:09:06 +0200
Message-ID: <20260730141424.488946453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit cb89f0c1aed02eb233c4271f76f830b37e222ff6 ]

In find_controls(), card_data is allocated with malloc() but when
snd_ctl_open_lconf() fails, the code jumps to next_card without
freeing the allocated memory. This results in a memory leak for
each card where snd_ctl_open_lconf() fails.

Add free(card_data) before goto next_card to ensure proper cleanup
of the allocated memory in the error path.

Fixes: 5aaf9efffc57 ("kselftest: alsa: Add simplistic test for ALSA mixer controls kselftest")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Link: https://patch.msgid.link/20260704105736.94874-1-malayarout91@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index df942149c6f6c5..6fe4be43072fb1 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -82,6 +82,7 @@ static void find_controls(void)
 		if (err < 0) {
 			ksft_print_msg("Failed to get hctl for card %d: %s\n",
 				       card, snd_strerror(err));
+			free(card_data);
 			goto next_card;
 		}
 
-- 
2.53.0



