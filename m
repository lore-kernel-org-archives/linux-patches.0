Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB22036CDE0;
	Wed, 30 Sep 2026 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786803; cv=none; b=ROx+ePS/CHMoFtHuX/tnjgpUXATm4NxsR2O7y1cYcEBSAaw6XmC6LKDFtkkiMuaaMD6dR6wHoydU8ugo2OQ4k0hJI5NF3IEmtFU5h+lMbaCgpjnRwBqjt3Nv4XXV7u0POto7l9OVIaUn4pkbaOCu7O/u+89zmD63/9utHheyPvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786803; c=relaxed/simple;
	bh=xH3ZsjauZWZ+Wvswy1pf0eqrb9Uk+X2W+lJ+q1rTDc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KMLQPKhPP3js77LpR0jeVMK0O/Ky593KPZxIEIMslGAPitrDn5IrIyXHN7IElGh3HHzY6tvkOHY8S+eNsnvrzIIaw95+LeJeaUltvKMTlivGsUvulL0gdzSr8hP/qe0x25CrUTw2xH1ms7J4xs1jf3U8xahi2kZDpbOSn1aEL0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsOXlYM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsOXlYM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ECA1F000FF;
	Wed, 30 Sep 2026 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786798;
	bh=2Sc1TWQAYDIur0ikwDWYNE9rC15XO1RSHXTDHp8tAA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsOXlYM5qawCK2S+3gvGca/uVdgjFl+KGLXi3uway/FBYvBekzTxPYgbs09swrUuL
	 numUu9MdTf9NOFU4mU4HekRmqHV1C5m9JMJgEqqZsw5uyOhoA4EAacEZoF1/kIhhab
	 vSkR/BLQMqPlJsBt5U80XrR17wPW4cY5xXRnCwSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 6.1 982/982] ALSA: hda: Fix missing pointer check in hda_component_manager_init function
Date: Wed, 30 Sep 2026 17:28:38 +0200
Message-ID: <20260930152437.837407121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[Roman: Instead of modifying hda_component_manager_init() (which does not
yet exist in version 6.1), a check needs to be added to the
cs35l41_generic_fixup() function—the very function introduced by the
offending commit, which calls component_match_add() without verifying its
successful completion.]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7021,6 +7021,11 @@ static void cs35l41_generic_fixup(struct
 			spec->comps[i].codec = cdc;
 			component_match_add(dev, &spec->match,
 					    comp_match_cs35l41_dev_name, rec);
+			if (IS_ERR(spec->match)) {
+				codec_err(cdc, "Fail to add component %ld\n",
+					  PTR_ERR(spec->match));
+				return;
+			}
 		}
 		ret = component_master_add_with_match(dev, &comp_master_ops, spec->match);
 		if (ret)


