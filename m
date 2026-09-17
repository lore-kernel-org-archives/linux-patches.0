Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AAD4E73A9;
	Thu, 17 Sep 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665573; cv=none; b=Ruxfel4RA5RwoyIaTl7IDaQoYenj6e1Rk2ZXAo1qaWD1PiwEeum+Q5nkt6kEt3Z602ntU2LXQptBehMsqEWtfqGI9xV0wp8K5+CaIYJ1L9SUOo4UQre5r3E22DqGv26GHh6dmWKuuBCn5FY7K3MSL1gGPZ1Nk+ueizgsXDP/1IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665573; c=relaxed/simple;
	bh=Eq98nrMT58QfR8hz3PT1BrurB0YM1xKOflLCJCgud6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnAGDYK2dJPte9xk1eMYwFflddTNIif0SHb/+Hhi1fzQvfeLPTo0AIe7TkbMVu94lC0qg7bDsSW5IOwKB/0SXxApTojUMhnu2134LdZBSwdhh6RYeAQE2ucgW4uD1VTqMZAa+1OASDaJjQkbfg6KSXld54Ut5KhK2awvxjvyYMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5x1hdBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5x1hdBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A831F000FF;
	Thu, 17 Sep 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665572;
	bh=LBauyCEI2M6xizCRtReUVbL1VKGtkBGlZcly2wIyuss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5x1hdBBdWSb+1ogQBQ5ZUqLc15WHf4XFwiFCiM9XK/UNV9rr9lw4lTPXggDPASS3
	 8yoGAHpIFURCeWyY/aU9xyBh1f/3QXnBgm1jWie7bC7vfHtF5wdxZLf/o3uhN7dGVo
	 IbUcPJ/+Qeoitvfu7/Ep0c64bpeXfnFkoiiRTFz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0750/1250] selftests/alsa: Fix the step check for INTEGER controls
Date: Thu, 17 Sep 2026 16:09:05 +0100
Message-ID: <20260917151612.209533567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8efd5f623c63584c2e284a837a7795d95a0491cb ]

The modulo sits inside the subtraction, so the check evaluates
int_val - (min % step) rather than (int_val - min) % step. The
INTEGER64 branch below it is parenthesised correctly.

The written form passes only when the value equals min % step, and such
a value is always on a step boundary, so it never misses a real
violation. It only reports valid values as invalid.

snd-aloop declares step 1 on four controls, so every non-zero value on
them is reported. Before:

  # PCM Rate Shift 100000.0 value 100000 invalid for step 1 minimum 80000
  # Totals: pass:660 fail:101 xfail:0 xpass:0 skip:296 error:0

After, same card, nothing else changed:

  # Totals: pass:740 fail:21 xfail:0 xpass:0 skip:296 error:0

Eighteen files under sound/ declare a non-zero step.

Fixes: 5aaf9efffc57 ("kselftest: alsa: Add simplistic test for ALSA mixer controls kselftest")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Link: https://patch.msgid.link/20260903123832.97377-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index cfb7968fbac07..2b9278475e6de 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -319,8 +319,8 @@ static bool ctl_value_index_valid(struct ctl_data *ctl,
 
 		/* Only check step size if there is one and we're in bounds */
 		if (snd_ctl_elem_info_get_step(ctl->info) &&
-		    (int_val - snd_ctl_elem_info_get_min(ctl->info) %
-		     snd_ctl_elem_info_get_step(ctl->info))) {
+		    (int_val - snd_ctl_elem_info_get_min(ctl->info)) %
+		    snd_ctl_elem_info_get_step(ctl->info)) {
 			ksft_print_msg("%s.%d value %ld invalid for step %ld minimum %ld\n",
 				       ctl->name, index, int_val,
 				       snd_ctl_elem_info_get_step(ctl->info),
-- 
2.53.0



