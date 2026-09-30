Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC242BC3A;
	Wed, 30 Sep 2026 19:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797178; cv=none; b=A76jI/5Y/LIkpM9jbn8BZU+lthxb4idLWGHpaZQerysqDaFvvD0Vr3aLZf/qKJQ3YTtuu/NRVwfbSEqq4cmA/JRRrR+ZAcNV3pC79vI38TnJXtsFCFNnk9ehp/wPCk4iFwr1vMFiSlR4BEG02Vjb0JzBjy9MldejiggCmSvU1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797178; c=relaxed/simple;
	bh=sEuLqPjWYuG6KE8aoj+7KEk9WmuKMAD1RYWZrHVXVKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrYb4k4zKm4t2sqUS7tGFdfDierziXWxonUU8768OjxXUQ/jE5aylmy3WN22YhMDtQMoh7quJG+Yh4yibLqHYI/r3RDBtkLT7TR5m+SeJbr9U25wcv87gSGJhmHqt2+p9be6AhC3rtQ+haKKs1gXeDB4vTwBJRBZ5QUBB3NCn8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYV8IcD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYV8IcD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EAF1F000FF;
	Wed, 30 Sep 2026 19:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797173;
	bh=z/hjjl/3uGFDaaIE14kXtmLl/tW/v1Ir0Bp9Wl/Zpro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYV8IcD5ZqO4ZWlhKW1bVu1738aXiOu9KiCb0rkdxqoPTwljsft4IrE2NOBaDHEof
	 l0eMx/qOFQPPpNhL2wT/2cpn8mGEE9ZRDrUUtMHhrshE+DDxprL4eiKpbiLApy/xRM
	 ly9lCnELP8JuyE/H1V/NkRHFV7w+7az9YAdXB4bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 6.6 1172/1193] ALSA: hda: Fix missing pointer check in hda_component_manager_init function
Date: Wed, 30 Sep 2026 17:30:56 +0200
Message-ID: <20260930152500.284555116@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
yet exist in version 6.6), a check needs to be added to the
cs35l41_generic_fixup() function—the very function introduced by the
offending commit, which calls component_match_add() without verifying its
successful completion. A check should also be added to
tas2781_generic_fixup]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7052,6 +7052,11 @@ static void cs35l41_generic_fixup(struct
 			spec->comps[i].codec = cdc;
 			component_match_add(dev, &spec->match,
 					    comp_match_cs35l41_dev_name, rec);
+			if (IS_ERR(spec->match)) {
+				codec_err(cdc, "Fail to add component %ld\n",
+					PTR_ERR(spec->match));
+				return;
+			}
 		}
 		ret = component_master_add_with_match(dev, &comp_master_ops, spec->match);
 		if (ret)
@@ -7084,6 +7089,11 @@ static void tas2781_generic_fixup(struct
 		spec->comps[0].codec = cdc;
 		component_match_add(dev, &spec->match,
 			comp_match_tas2781_dev_name, rec);
+			if (IS_ERR(spec->match)) {
+				codec_err(cdc, "Fail to add component %ld\n",
+					PTR_ERR(spec->match));
+				return;
+			}
 		ret = component_master_add_with_match(dev, &comp_master_ops,
 			spec->match);
 		if (ret)


