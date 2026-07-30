Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6429BD87;
	Thu, 30 Jul 2026 14:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423485; cv=none; b=mySQjkX8o1I16H1zglBltoQfWbGw+au4BQ3q7kInzoeU/n5K68HlxMBMjWNRDuo/kLCxWOfJs4Lsc2gm+CyiEytfUZYj4C7CMRou+jduZDVahGUl/h6kMRxSVjNjoSHHwP33ZiKzKEelfcSGM+Bt4iFNrCReCBZTy7FCUchjZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423485; c=relaxed/simple;
	bh=uUQw399DOOt5GaDN/7I3q0ydzlM5Fu58ywljN+62gUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2p7JyZFNqCFK18FdfX8Cz/XVHWY9z61EYJfzDsnBDymGwYCro+oK3pe9k8QR/AB3bga3H2Fa9F4MWNpby4PoLrlaSprNqcKvVLFMDTrKo7e8NcNmZhVkIoVuAzUO5IkpDnHbDFr+De4FIPdn66+qBvI5D2divmcm2Nw9Z7u2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF5lYRn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF5lYRn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4091F000E9;
	Thu, 30 Jul 2026 14:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423483;
	bh=TLRIBvyJTpYQw3xk6H1pjlaQMFOzkDHr0z9Lq/3VVRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qF5lYRn9xpTo2zOkNnBeAzcp0U+tcWY61W8TG+2r9lBUl9zZbL9RbgDIVEn7sf/nP
	 J1G5YR+d3ouNfvNydNSLB6Lv/8e1Lgk5Lmkjgbyfva3T/updwWpeumyo6wy3SCg4JY
	 +wAeLCvFJ5x8UlUI13TIPHOAP28lwcleveIYVkMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/675] selftests/alsa: Fix memory leak in find_controls error path
Date: Thu, 30 Jul 2026 16:06:29 +0200
Message-ID: <20260730141446.374305634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e113dafa5c2464..cfb7968fbac075 100644
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



