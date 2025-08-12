Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157042D4802;
	Tue, 12 Aug 2025 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026392; cv=none; b=S2IYnmQ42ndRFVQqq0hy2zVPVx12TfbfxJJNPOvdpEbZM0wuBR4xDfRPSz17JC9Z4HJE6EYCPTBGyNmDH9ZSfUmZoN9BDD3EHbzXWDwime0wb3entN6+hO8nVgC1zMxtH0VuGtaw6H4Ewde+BPL4E1AeQyzeS8gtd7ckiCz3MOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026392; c=relaxed/simple;
	bh=UX3M90zPSpvBBt+5OPtl0I/PhvIbfKNM9kWMQiSrrqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc4M6c7lssG+1+QOy4PNqYTpeK1Y31/dFo7zgr/QElj5LUdDfONGv1T+30jM3eLfDHJxIjY0gOarxfgsRijqORaZvuq4B7v2pt1QWPsyGRpdFpp3xjvtQhA8uQKq5y55XaTF2iIF9/aR/YpVnjwimlXFf/AogmxoGUai/vDtDso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXvqcj6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXvqcj6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B7C4CEF0;
	Tue, 12 Aug 2025 19:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026391;
	bh=UX3M90zPSpvBBt+5OPtl0I/PhvIbfKNM9kWMQiSrrqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXvqcj6FmIhIRkZj1UZDo2Nesa5n/mmXwVVS5hmuCseNfxZYj9/QkNHFG01UAEL7G
	 gGBBvVrcK8iEgfpWrdzAx/GQy7GX5HxoiE8BC0lb9tCVY71FpGBJ36a3ZdEGnYWXk0
	 WvlmE71tKwMcfG0Li0YPv0ggv9x7obaKUikYS5Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 322/480] ALSA: usb: scarlett2: Fix missing NULL check
Date: Tue, 12 Aug 2025 19:48:50 +0200
Message-ID: <20250812174410.719651171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit df485a4b2b3ee5b35c80f990beb554e38a8a5fb1 ]

scarlett2_input_select_ctl_info() sets up the string arrays allocated
via kasprintf(), but it misses NULL checks, which may lead to NULL
dereference Oops.  Let's add the proper NULL check.

Fixes: 8eba063b5b2b ("ALSA: scarlett2: Simplify linked channel handling")
Link: https://patch.msgid.link/20250731053714.29414-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index 288d22e6a0b2..5d47502c2858 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3971,8 +3971,13 @@ static int scarlett2_input_select_ctl_info(
 		goto unlock;
 
 	/* Loop through each input */
-	for (i = 0; i < inputs; i++)
+	for (i = 0; i < inputs; i++) {
 		values[i] = kasprintf(GFP_KERNEL, "Input %d", i + 1);
+		if (!values[i]) {
+			err = -ENOMEM;
+			goto unlock;
+		}
+	}
 
 	err = snd_ctl_enum_info(uinfo, 1, i,
 				(const char * const *)values);
-- 
2.39.5



