Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000D3352012;
	Thu, 28 May 2026 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000569; cv=none; b=Kyv4md921hCaVOAYmZZMvWc+c/M3LXN+LwLid4FBgsGJ0wCpCV0lDySwvAXm7phv4psPYWV54hqzjztdhMZlLmljlqaQNv7Oism17atwU4W3NlZVGPHkWqx+8lcSF3jh5AvxlHmPh1pKGBWuod9woGadvnf7Ro8I6FJmNKYunRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000569; c=relaxed/simple;
	bh=lwgj2bBMTnycW42rPv5tik3uz08YmSIWb+P1Zb5xihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCbx9dPusG0CCjWHm+cpVcyXPpWw9/dGON1sUQWsUkS7Xd5VUojyeLL/iNChxbPMUn2Bp9njuVrp+pBochau02qs3Ie5Om+ojnR8+6tR5OeTdRPgJcBU0Ox7tPsUE3cCbPqf3ctTdJWu0X5NyxNUsqoaTPmhKRlG/gzIaV2Oz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhznIctl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhznIctl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE71F000E9;
	Thu, 28 May 2026 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000568;
	bh=0xsvj88V8+wBiTvYtlvtKyQl1Z+dGdeiFzEZlY6TGdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhznIctlvTxOd+IjR7JxYJ4epGOBIMqv22UerKLoZotfoG/L3+heiTmrzeFUmSeUs
	 XGfqx63999UxzzKvgAZd4D3GKY8hP2fRS0C6Tlto5BgmMABjG9U9a8FiJFAY81zZSD
	 off1xoGaC165Lmd+ku6mkfNAFyJqvDVyloRbVdZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 054/272] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Thu, 28 May 2026 21:47:08 +0200
Message-ID: <20260528194630.896065196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 7b7d6572145c1dab2dd9bfb550b188e5f0ff3c3f upstream.

find_control() to retrieve a cached info accesses the array with the
given index blindly, which may lead to an OOB array access.
Add a sanity check for avoiding it.

Link: https://sashiko.dev/#/patchset/20260511230121.28606-1-rosenp%40gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260515085606.242284-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/asihpi/hpicmn.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/asihpi/hpicmn.c
+++ b/sound/pci/asihpi/hpicmn.c
@@ -276,6 +276,12 @@ static short find_control(u16 control_in
 		return 0;
 	}
 
+	if (control_index >= p_cache->control_count) {
+		HPI_DEBUG_LOG(VERBOSE, "control_index out of bounce %d\n",
+			control_index);
+		return 0;
+	}
+
 	*pI = p_cache->p_info[control_index];
 	if (!*pI) {
 		HPI_DEBUG_LOG(VERBOSE, "Uncached Control %d\n",


