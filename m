Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168A4350A3A;
	Tue, 21 Oct 2025 20:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077227; cv=none; b=LIMIoPZzPEjkUoN4a58kXFgy1V1YkVzigczQ6ltQ2z0H3G3CIRUPHlR28ZtZk5NAE0YALyWWWYk1qr0IsI2jbTf6uQAFXQA0Zr6j1emax+0fYwfBGtJkXCwjPx7YmSDk4cNzBLt4x1gfjsG/wgEUxWxYiXYaoN6hqIfPZ0i0K/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077227; c=relaxed/simple;
	bh=HK27Upwn0lqiaH0zuD11DiblzP3aN+mh1ulRmxZ5Dw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCMfRWntCqUeSEFZHQmrGlaCPvQsSxm93KudPAGvWxFkL9+97fyfevC4I5JB1idfoOAvKurw1DJPNJQWHOwfrwdZBO3+dSru74jgMVEEFcAT88DhrdRKzgPbkalRnlQOKdPDsRfRMegagC8ThditgIWxWdf1dmwu3EhEXsZZITw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3NU0e4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3NU0e4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E93C4CEF1;
	Tue, 21 Oct 2025 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077227;
	bh=HK27Upwn0lqiaH0zuD11DiblzP3aN+mh1ulRmxZ5Dw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3NU0e4J7iyNmElHmD5O/FUvB0ahgfPzkfv4jWe3x+eDp6TAG63Lmq9xq++H6pDql
	 TrXxaZ+iNXj90GyaNz8ZzHMrp4nvJxj5efxhC4W4QJh6KAcvlmTU7H8Gg0FlUyAQm8
	 df1rHejS1jhSEz+l7Nrm1eDNVtvBsLFj+ZWdHsyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 038/159] ALSA: hda: Fix missing pointer check in hda_component_manager_init function
Date: Tue, 21 Oct 2025 21:50:15 +0200
Message-ID: <20251021195044.113512304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 1cf11d80db5df805b538c942269e05a65bcaf5bc upstream.

The __component_match_add function may assign the 'matchptr' pointer
the value ERR_PTR(-ENOMEM), which will subsequently be dereferenced.

The call stack leading to the error looks like this:

hda_component_manager_init
|-> component_match_add
    |-> component_match_add_release
        |-> __component_match_add ( ... ,**matchptr, ... )
            |-> *matchptr = ERR_PTR(-ENOMEM);       // assign
|-> component_master_add_with_match( ...  match)
    |-> component_match_realloc(match, match->num); // dereference

Add IS_ERR() check to prevent the crash.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ae7abe36e352 ("ALSA: hda/realtek: Add CS35L41 support for Thinkpad laptops")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/hda_component.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/hda/codecs/side-codecs/hda_component.c
+++ b/sound/hda/codecs/side-codecs/hda_component.c
@@ -181,6 +181,10 @@ int hda_component_manager_init(struct hd
 		sm->match_str = match_str;
 		sm->index = i;
 		component_match_add(dev, &match, hda_comp_match_dev_name, sm);
+		if (IS_ERR(match)) {
+			codec_err(cdc, "Fail to add component %ld\n", PTR_ERR(match));
+			return PTR_ERR(match);
+		}
 	}
 
 	ret = component_master_add_with_match(dev, ops, match);


