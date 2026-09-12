Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E13A7591;
	Sat, 12 Sep 2026 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239057; cv=none; b=XDz0ew/u4Mu8Atz2RZKGlTIxElCPAgFhTAI+dn914GXBr435BH7IW5EJ9Eo+/p47btKbCAaT9WjmOQX/tMtyWK8UH55nX1NDEGjqYyvzkRMKbpaSnxa8BgeZV/AhgrtnGoSBJtnPm+hDL60A/Q1iBnJzGTJB3KEPjVBBPZ/kROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239057; c=relaxed/simple;
	bh=speGfcod1Jp78NDL9wgdQbmVPsuZpMlLi8vlJmlkJ6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hA+URZiFq6yVywM3Fb/1BkYLRn0ylILlbxJ0RKNGX/mjRmJGxUqjWeotZgW/r+6kEjdt3vs0cb9SPXMfl7fR1kX5K9rneW1g+e7T1UrbOXGwPs/Mk2MgwVomXQEUZcZfPV0KEBWCvx2L9ksB4pDwOzM/g4ns7rH6oxxfXxDh9sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aF9AzI4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aF9AzI4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72691F000FF;
	Sat, 12 Sep 2026 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239055;
	bh=WTTdbAXUixSFBy/uGYu/AWOj4VwRfGPDQmZpcry5sM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aF9AzI4fPcSzoWXA0ZksBWaKiT4EbaoffN+3D9w8KpvVsvne2arSoQ9+Gn+JCldR9
	 wo+WKT3UVGA3kkBElmSygyWwNUVhs+JRnS6ihfDqm+b+SigyNiwupfqbaZSIFXGySC
	 eWLdzDO0nfSAJnl1jBXn9BR0mAbVgPfHWxL6W4dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 544/935] speakup: keyhelp: guard letter_offsets possible out-of-range indexing
Date: Sat, 12 Sep 2026 08:59:34 +0200
Message-ID: <20260912065539.300885746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



