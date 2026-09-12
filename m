Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5711A282F1B;
	Sat, 12 Sep 2026 07:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199010; cv=none; b=Mrz9QbRvthB6slhIhxBNkuo9Oo0zkNXTnDgcwG2xTFFLkRxSWH+6uCFP6Tz/MH60psUQRc38WaKH9lxxftSwNk/+utj7CHABAVsiROWsGbSwOnuu7ODZpSQ5lEnrFrEJkmz8B1vCMFI00vrH59FS7GldBvXPL/6772o34szG51s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199010; c=relaxed/simple;
	bh=Mo/29R+P3Eg0WJdoQbEkIhidyiuNIS+GP8rpv7r7Jfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYfsJK5Y8GQgKzm8HRYsgz5dk6VA+GhR6Pl3cOMq7Fi7BoXm540rLNzDb62zLfOHvEM09pTl9nvhT6BkqUKIg8lcyqsmKLXNQ0jDaG5pAt8/jftjI54QEIduDEYEuDWWTTLqsaRp/c1iZx8aZGKxPD1Vk+5QI3ZVbBp6B4lN3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW4O1Wi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW4O1Wi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAED1F000FF;
	Sat, 12 Sep 2026 07:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199009;
	bh=DHXrnRi1JqSfW1YlPWVmLE9GZ8ZLV/Ys5G8L0aJ8ZK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pW4O1Wi90u42Uu9+X14MbipmkLdUfPEplwwh7eUjEsRJKxnpjhMnJaC4mr2nrsGse
	 TrInnOhmJ0eTrADKC6UGrxURwp+mipwdnc/8h3L4QdLbum11FktDFpxCow0Myxbc2Q
	 doYwZTEdqZRnggdNELpZ4/HG4D6Eszf9IkxMaQxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0495/1815] speakup: keyhelp: guard letter_offsets possible out-of-range indexing
Date: Sat, 12 Sep 2026 08:37:25 +0200
Message-ID: <20260912065700.513341718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



