Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80903093A6;
	Sat, 12 Sep 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223466; cv=none; b=nCyNel2+3Bfmfac6Xzy7+L+DvombcRg3vAodwtZvB2o5sz1IaIWQ9M8/nNhMoD3mxrxdVFdy+Kyqg7nzsq0pKW/GRF+EZgTxETdyTwfN2Tq9QvLRoSl9VIiVt6HF2E7iHpSjZdOmb6aVOj/611CNzbKmCuAb4KBheCFAeaphKOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223466; c=relaxed/simple;
	bh=XMyeRwinft9eKC0l6wyasLkTg79nEwjVZWK6+gmlKpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZK53kt1oYS8fGEtFdO5+Xvm95xNLb0ktR7DGK0wyeoqYFTX6rziCoCL9goOYQ8ciHW+Cb2nhdJar1H50stTFU6yHCg7SxmVDCnbf/Ea21b17NqJZqMLN0MtPgQvhlYk0cdh4GtZDSXqwQcb5OKOVPdZvimTQNNwd78mz/cHy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpJGBxPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpJGBxPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10151F000FF;
	Sat, 12 Sep 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223463;
	bh=7fO4ypUgcfrSIk6FJwMuR9oXuGaeOhGMwBGAMIw0BfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpJGBxPT5b+wnr1ENlHK70aWjfp5CgnKoDtgIwpD8u0veHx6XQh8t9NXHI2Vps7qV
	 s8tvNa81MrH7BuDGgjeAk7hpP6XQnoMEOR+ErOdutvM5ylramjkOdWMtf3cWZm8M1J
	 kVKmNT+h42UJSU3lQN6oMaJkIU6lPz0R1XYNWwPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0795/1424] speakup: keyhelp: guard letter_offsets possible out-of-range indexing
Date: Sat, 12 Sep 2026 08:53:47 +0200
Message-ID: <20260912065625.100781038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit 6a19ad4d68c95185308cd9e5d169b10a2cf236c8 ]

help_init() builds letter_offsets[] by using the first byte of each
function name as an index via `(start & 31) - 1`. If function_names are
overridden from sysfs (root) with a name starting outside [a–z], the
index underflows or exceeds the array, leading to OOB write.

Function names can be overridden with the following commands as root:

    modprobe speakup_soft
    echo "0 _bad" > /sys/accessibility/speakup/i18n/function_names
    # then press Insert+2 on /dev/tty

This fix checks the first letter in help_init(), and if it is not in the
[a–z] range the function returns an error to the caller. Eventually this
error is propagated to drivers/accessibility/speakup/main.c:2217, which
causes a bleep sound.

Fixes: c6e3fd22cd53 ("Staging: add speakup to the staging directory")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://patch.msgid.link/20260531230804.254962-10-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/keyhelp.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/accessibility/speakup/keyhelp.c b/drivers/accessibility/speakup/keyhelp.c
index 822ceac830683..e632c53d6246e 100644
--- a/drivers/accessibility/speakup/keyhelp.c
+++ b/drivers/accessibility/speakup/keyhelp.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/keyboard.h>
+#include <linux/ctype.h>
 #include "spk_priv.h"
 #include "speakup.h"
 
@@ -111,7 +112,7 @@ static void say_key(int key)
 			     spk_msg_get(MSG_KEYNAMES_START + (key - 1)));
 }
 
-static int help_init(void)
+static void help_init(void)
 {
 	char start = SPACE;
 	int i;
@@ -120,13 +121,19 @@ static int help_init(void)
 	state_tbl = spk_our_keys[0] + SHIFT_TBL_SIZE + 2;
 	for (i = 0; i < num_funcs; i++) {
 		char *cur_funcname = spk_msg_get(MSG_FUNCNAMES_START + i);
+		char first_letter;
 
-		if (start == *cur_funcname)
+		first_letter = tolower(*cur_funcname);
+
+		/* Accept only 'a'..'z' to index letter_offsets[] safely */
+		if (first_letter < 'a' || first_letter > 'z')
+			continue;
+
+		if (start == first_letter)
 			continue;
-		start = *cur_funcname;
+		start = first_letter;
 		letter_offsets[(start & 31) - 1] = i;
 	}
-	return 0;
 }
 
 int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
@@ -144,7 +151,7 @@ int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
 			synth_printf("%s\n", spk_msg_get(MSG_LEAVING_HELP));
 			return 1;
 		}
-		ch |= 32; /* lower case */
+		ch = tolower(ch);
 		if (ch < 'a' || ch > 'z')
 			return -1;
 		if (letter_offsets[ch - 'a'] == -1) {
-- 
2.53.0



