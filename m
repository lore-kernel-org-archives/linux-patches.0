Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF6A2C11DE;
	Mon, 17 Aug 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978890; cv=none; b=PsVMO49y0zHh/IM+H84oGleR7Xz1FuFeURZeQLa2qcZiq0t9XEv7fE5OeOGFoH/41Lkv4d+MDvseDdNqsMZGIvnuRu6CEK/dp6J4PH1mzfRuNn2mH6qR1+Vy6ta9MyYA3Plv6aM5T/zLpSzlpF13x+sG5Mt22E9Z9EoupCmg4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978890; c=relaxed/simple;
	bh=Zlhu1A/1+bhx9xR+xDBGgBQixAmpPh6Z/4ufo0FMeAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG6jJIewU1ggl3oUPjaM+HTXhofZP2amFFFaPUhUuu3b6otpmKYvO52K0wI1wwQNEGJbXFmdTNdx3nmgbvbSmsbHKLol4BHNpLAkXsC3zYlE1q1aI8Tm3fUKMnEUSrIFTwLSQOzXq6AeKTDCYwfOM888XwE5sCHZWtAztVpCXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdLXvQUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdLXvQUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58A91F000E9;
	Mon, 17 Aug 2026 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978889;
	bh=BUkYy5szYhq16wllIkhPuWwPrEBenNJbOO9k/0YPT0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdLXvQUni72H/AXRUlC7up0DQC1K5jOReNyUXjxQif/e3BcNmQCfXEKIL6C5wb9kv
	 c90sbvAyrIO/1Zivcvi23rvECKrSnvHyHLDT31dxrotGTlcyQ6/rXILq6oEupq+0Ux
	 xNwi9Ps773V9nc8VTD7ulCCPqHGIlG+RXSolJkVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/609] selftests/alsa: Fix memory leak in find_controls error path
Date: Mon, 17 Aug 2026 15:25:32 +0200
Message-ID: <20260817132544.484550065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9ad39db32d1442..960b137789d25e 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -130,6 +130,7 @@ static void find_controls(void)
 		if (err < 0) {
 			ksft_print_msg("Failed to get hctl for card %d: %s\n",
 				       card, snd_strerror(err));
+			free(card_data);
 			goto next_card;
 		}
 
-- 
2.53.0



