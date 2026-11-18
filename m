Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032280;
	b=njJ/yB/KDIKVH+IUWccRjcNrm3C9y2nM7FrT1NgbOHhcCpZuwIAZ0E/l3D7J0igOABO8
	 iVtzQEA8I/sWRv/Rg7i4ifNbaQ9wrVG8pdy2eKy4kohuMDayxdwFR4Q07wVT6hs8EHdWp
	 qEpb+NyhaGNiS4q+k6ZDArVNZGbOYXMMNDwf89mAvw8bao0vUhILpWI62by9QVXc6rmTf
	 LZPFIvT9eoCd8a+lPPg5T5LYbMg2HA0cQ7NsUUzTWaMC9D62HMve53GQmvcHInIYzGSuH
	 9VbmYITAOb15q5KqUxAA0hc0PjNgDjVlQLUc56fnUUaLrIY3/wxAOEyb7OInj1f4WAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcZNK5KmhxAv779hCbNPU0TSXboDTjTuCqF6AcKhtjw=;
	b=xbpIS4h8ape+yhYU+AdrvwI7S+ts4YZzYrwEhl0/LSD3XjuieYhGq1WYbfl0vQLocGjQ
	 zLAOMw41qXbooFmD+sKzoD9CpuapADLUpPY0oQ6WwC3o20Zt2Q3FTuaRJeEWAFVY0QmDl
	 UPAhb25lu9XF5Wwlm138n/iWDjLKKjU6BuetvluArQhTB2uFyFZATo4xmRwKxOMXTycYa
	 Xx3uYozMNECbiPLVpeUHFvoeemC3hsAxif+W7ryYh2iv2SY/hyn9f1tkTOGqZQJEDYqHe
	 jMz7VTDos9B1SHeMDdQRC4p2IZXuViGAlTQfSrK4/5/3w0X8MKFb/lgZGjqh64nRh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kv5xLUnR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA94606A31C;
	Wed, 18 Nov 2026 20:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kv5xLUnR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C891F000C4;
	Wed, 18 Nov 2026 20:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032280;
	bh=mcZNK5KmhxAv779hCbNPU0TSXboDTjTuCqF6AcKhtjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kv5xLUnRT/CIoDESMzQXV5NuXEXfrGSQqg1AQw5iJT9Tk6aFNKyjriJ6aKsOZCGsF
	 BieZ3ggDvaWZBIKglHDfdqcA5LAP3Avs5qH9cq/8IlKt+pb/rcuSej3Q24U8pFUabE
	 8wFpLuoiFfVRZzYQYqxiLFVjYxnBq7UeiUtZtRj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1355/1756] ALSA: jack: Protect the index scan against control removal
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150103.242977927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit ba8c3d5fc27ac3f86962641dd3b6600906234bab ]

A control found during a jack-name index scan must remain alive until
snd_ctl_find_id() finishes comparing its ID and count. However,
get_available_index() calls it without holding card->controls_rwsem.
With CONFIG_SND_CTL_FAST_LOOKUP enabled, the lookup loads a raw control
pointer from ctl_hash and dereferences it in elem_id_matches() without
any lock that excludes removal.

This can happen when a jack is created while a different jack owner on
the same card removes an existing control with the same name and index.
For example, probe and unbind of different HDA codecs can reach these
paths on a shared card if their generated jack names match.
The codec device locks do not serialize operations on different
codecs. The unbind path can free the control during the index scan:

  Codec A: probe                  Codec B: unbind
  --------------                  ---------------
  get_available_index()
    snd_ctl_find_id()
      kctl = xa_load(...)
                                  hda_codec_driver_remove()
                                    snd_hda_codec_cleanup_for_unbind()
                                      snd_hda_jack_tbl_clear()
                                        snd_device_free()
                                          __snd_device_free()
                                            snd_jack_dev_free()
                                              snd_ctl_remove()
                                                snd_ctl_remove_locked()
                                                  __snd_ctl_remove()
                                                    snd_ctl_free_one()
                                                      kfree(kctl)
      elem_id_matches(kctl, ...)
        read freed id/count -> UAF

Hold controls_rwsem for read across the index scan so removal cannot
free a control until the lookup has finished using it. Release the lock
when get_available_index() returns, before the caller adds the new
control under the write lock.

Fixes: 38ea4c3dc306 ("ALSA: control: Optimize locking for look-up")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-f08c844bb1163c8d4fa1-v2-2f3c99e40f90134846ee@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ctljack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/ctljack.c b/sound/core/ctljack.c
index 709b1a9c2caa3..e6b0d98ca480e 100644
--- a/sound/core/ctljack.c
+++ b/sound/core/ctljack.c
@@ -37,6 +37,7 @@ static int get_available_index(struct snd_card *card, const char *name)
 	sid.iface = SNDRV_CTL_ELEM_IFACE_CARD;
 	strscpy(sid.name, name, sizeof(sid.name));
 
+	guard(rwsem_read)(&card->controls_rwsem);
 	while (snd_ctl_find_id(card, &sid)) {
 		sid.index++;
 		/* reset numid; otherwise snd_ctl_find_id() hits this again */
-- 
2.53.0



