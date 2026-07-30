Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A8044C4FF;
	Thu, 30 Jul 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425388; cv=none; b=ewiGHTr8dPCaqmj/FtewiY8zZ/q/7tIalaAYU2hho0UaRmuf1QNggDmjrI6ZYvXeumMplVvFrrrIFxlLDdhxSN3F7GpJNv6senDFR3ggUqT/VQaQ3UZYKSKqVkUK6L+IWwl1ZlbaTytPk/f4U0i7FgV8efm9Jj2q7ztDMeayRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425388; c=relaxed/simple;
	bh=/s9Yyj9oecX4uwQOFg5L1GljhIjf5U6rAHs1SJ+YxiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr0J36zMuFT7RL11+zl7/EEpD11CeNr1himuJvVJYNZxah3Gz7IehIgm0XdMnnH3fpK6QYc3GaXpdodQVimKLsCl7vGzOK8X/BGRgm9hatFiTddfpPivHnsMHneBbtEO7MAbxLccTthR8WmehG/Fc94vcyWT/Etu5xnICHsM4SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGaFNurQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGaFNurQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418821F000E9;
	Thu, 30 Jul 2026 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425383;
	bh=c0B3VUVzQY6ZzZzQlqOSAqQNcohLscreCaVes5JTqes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGaFNurQA7MsC8TjTk+z4Z/LmGxrign/xWfWwy79rgRzoDmuXS0A7K6NRNyKTP50Y
	 pX3V4W8Js1+hjoC5uxL9Qc8JfzJmZiOL0Xk/1PbCNcQZTtPEYVC+SS5g9XXuyak9Pp
	 606l8dIPEsYN5yd/P/vslrzLqrNLuzAVDTzZ0OoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/602] selftests/alsa: Fix memory leak in find_controls error path
Date: Thu, 30 Jul 2026 16:07:23 +0200
Message-ID: <20260730141437.076684820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a4b2662035efc..2964f02ffd9d3c 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -84,6 +84,7 @@ static void find_controls(void)
 		if (err < 0) {
 			ksft_print_msg("Failed to get hctl for card %d: %s\n",
 				       card, snd_strerror(err));
+			free(card_data);
 			goto next_card;
 		}
 
-- 
2.53.0



