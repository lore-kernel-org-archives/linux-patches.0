Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97007346FB7;
	Fri, 21 Nov 2025 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732045; cv=none; b=WC30HRPe6BmLpg0kdGtSvBRR6QZVsnyQLnHUO7xtLjrjdT5ejfBrwhxH1P7ahwLvcwRq1GceW5w1RVIrqABH347q0Kg/HXWj1LvZvv63ktC2LkajRpjHrjDoFY+QN7i8BiCR5s0o2Dv8FjNW6K/6eemODr5b+iprX49TF3aIuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732045; c=relaxed/simple;
	bh=JN7yNbJx0P5E2OWu0SooGhbOXYi7vG77xSgAuJMsDUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfmdBshjuUqcQuBPRdy4y8vdiiMhjELdqxxw+nUiZ1rZyhWQPkbVj8eJOnfc0YnBtBSJmjVb4OwyJWN9oGp+MQQzELPe8lCnJqZ85S2mJdDmLLnRVz/70AQJPTeRuN0y3y3gfyRYI/bFHYe1wBru+hfINrUSSg7X16+I3Du7DEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVhRWq9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVhRWq9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E275C4CEF1;
	Fri, 21 Nov 2025 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732045;
	bh=JN7yNbJx0P5E2OWu0SooGhbOXYi7vG77xSgAuJMsDUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVhRWq9g4iIW2ggxjFkIcKWtbdmiW9H8DX1BgEQcXac5Drp8bI8ULiuYK2qDiTGZP
	 DDAz3wiM5/s1jKR8/YezEFBoOVGKAxpfiYkfSby7Wsca5fcL30TbJXHSqZbMcLYfU1
	 CN9qJbrpMKOZQVQHpYxNWUjy2n+w7ZQ4kIUpTxJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.12 171/185] ALSA: hda: Fix missing pointer check in hda_component_manager_init function
Date: Fri, 21 Nov 2025 14:13:18 +0100
Message-ID: <20251121130150.055876319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 1cf11d80db5df805b538c942269e05a65bcaf5bc ]

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
[ Modified the source code path due to 6.12 doesn't have
commit:6014e9021b28 ("ALSA: hda: Move codec drivers into sound/hda/codecs directory
") ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_component.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/hda_component.c
+++ b/sound/pci/hda/hda_component.c
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


