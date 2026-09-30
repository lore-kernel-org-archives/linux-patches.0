Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019553E1230;
	Wed, 30 Sep 2026 19:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795323; cv=none; b=lZKAoBWlCAdpfzs3ohpEd93uVqYjuQbiGz2M2qqqygixc0+zNUeBJSetYX/Wu++JEHB3J/vGv7wWiKzO/tpYq/ZLbL+Ll1txjpp9b+kaXYr8hajISUHl7IvaD39sU9y1pJ5daWCneRY031t76qciNtzzAjPRl2aJMQft3CDut7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795323; c=relaxed/simple;
	bh=0c0qEBy9QPphUi0INf4xbs0CLuVmx48rJ4S9PCPizq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkfOf7rbFSte9HxwL4vRTj/U6lePLIomIxzuUwM0x5csBT9m11B6jZIkIR/v2f/iGEersprucVqrHAylxNrBxL/uTVhl9NfCwYTqSAEgsNQtDla+XlmYACn7cVY7QtyVPeSMD+4AX8G880X8OuB8IADKdCUVhmANPBfMuDUJJYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IbOIODP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IbOIODP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8D61F000FF;
	Wed, 30 Sep 2026 19:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795321;
	bh=IHHO3Y2VMwgY0Zp3V9WSBz5EanqVLaAmLaMp4zZqy/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IbOIODP31M8KyhGbp4dolngAEkhwFV8SC91g7jha6OagE2GzvR7qCOxe0PSOF5nJ
	 Avql7Xo3G/KLKQUnHq7AIEy5ekrTg0Dhkn7KgRsKUUuNfsLRlrMbfDr8/ByWK86sGw
	 A6pmGyMGHnPjNf+nEr0Nida2ERJom9gaxa6o7NSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0476/1193] selftests/alsa: Fix the step check for INTEGER controls
Date: Wed, 30 Sep 2026 17:19:20 +0200
Message-ID: <20260930152444.738026801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 6fe4be43072fb..c43774056670d 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -299,8 +299,8 @@ static bool ctl_value_index_valid(struct ctl_data *ctl,
 
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



