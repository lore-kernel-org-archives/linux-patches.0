Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E911170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8786C433C8;
	Mon, 11 Sep 2023 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442260;
	bh=9g8Sg1IlEtqrCSBAB0MFkzwDr6J1Mrg2kkE4MldwLGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNQy9LUciy8VAaek6jVKNfvP+wX6LZVOnIWwgplMzwJC23PGzD6y554hu7P2Y/VI2
	 r27gdZW+jURaMRPBkvdjsXrvBE0kxdsg9cTNmNHuKDzqX37yTBYgjNM6riSvF6yIRr
	 Mrg6li+djJ9/yvYFZAPviK4lxmSha4ihYtDVcDC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Ash Holland <ash@sorrel.sh>
Subject: [PATCH 6.5 676/739] ALSA: seq: Fix snd_seq_expand_var_event() call to user-space
Date: Mon, 11 Sep 2023 15:47:55 +0200
Message-ID: <20230911134709.982682525@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 86496fd4a2fabb7c978fdaca2d4b718207a96d36 upstream.

The recent fix to clear the padding bytes at
snd_seq_expand_var_event() broke the read to user-space with
in_kernel=0 parameter.  For user-space address, it has to use
clear_user() instead of memset().

Fixes: f80e6d60d677 ("ALSA: seq: Clear padded bytes at expanding events")
Reported-and-tested-by: Ash Holland <ash@sorrel.sh>
Closes: https://lore.kernel.org/r/8a555319-9f31-4ea2-878f-adc338bc40d4@sorrel.sh
Link: https://lore.kernel.org/r/20230905052631.18240-1-tiwai@suse.de
Link: https://lore.kernel.org/r/20230905081210.6731-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -187,8 +187,13 @@ int snd_seq_expand_var_event(const struc
 	err = expand_var_event(event, 0, len, buf, in_kernel);
 	if (err < 0)
 		return err;
-	if (len != newlen)
-		memset(buf + len, 0, newlen - len);
+	if (len != newlen) {
+		if (in_kernel)
+			memset(buf + len, 0, newlen - len);
+		else if (clear_user((__force void __user *)buf + len,
+				    newlen - len))
+			return -EFAULT;
+	}
 	return newlen;
 }
 EXPORT_SYMBOL(snd_seq_expand_var_event);


