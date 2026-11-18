Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027218;
	b=oxiq2HxxjgRL5Qs91gJ/wl3C3OQqkdViZrT+spqoFKeK4No8ALu9OMfhURddBxg7nHQH
	 9CmACKZZP5M+UPIf3OzRgRMbKj3QTM+m0HiLM3YWEOfQPv3siJ2XBrtQo8d6bHyLCw6+/
	 7NOefrMbGHoUxfX0Fc4Qt91Kvw3K1PYHEt58JHGECa8iXOapZe247CDrN+3PwBISKzYYp
	 9tRtg2rG4dsEMUUYHgk5QiI554RBJaGFcGTOn9peV/eiaHImbHPFtshpfAZs85vLz2+FZ
	 9wG0Tzd/eIsZEw87r5FzhyM8JDJJcFEwRDh/7Arzbh2ZXsNyO8VW5aN1/HJl8mkHinQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bsm8OSvLAwuDR0OP7gMW9+6l6JSHRuZSxi4dRJ+iXfI=;
	b=UWDnJUZBXsbyTAVUo9Suk+/LQCheqMFg/Wo+vCArhpGyVIDdKWg9Vp6x8ZV8axA6nY8R
	 2/G8lWAsLxvFX/TxDYHvgnmwouw9fgrk6Fnhe7mfvA5LkDoTO2CGhlfjenGI1AzaWDUWu
	 uU/QlqfYQMzkXrZWpFr4lKBT/FryPXdy0GtvyHf6sdHNfI4XWVaRcW/HNMbP+VQ59mz9e
	 qD3E721Qnh0kZDwOj2WnGpjESoAhxy+k8obEls63O0g0GnSMOzPBX3lthnUOMxqJ3ntgr
	 fh5XJ9UHDFaoVfOCKgJryuD64pHmhkUket+PuJEE04EeVZFRCfF5dJKBavplEcgwj8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BO1RMe1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750860A260F;
	Wed, 18 Nov 2026 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BO1RMe1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B081F000C4;
	Wed, 18 Nov 2026 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027218;
	bh=Bsm8OSvLAwuDR0OP7gMW9+6l6JSHRuZSxi4dRJ+iXfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BO1RMe1zTogTi+mZHFGOzPKig2E11zRHqmSFFrU2mXigzUFd0PY5lti+azesU7HhZ
	 R7GP1JdR1d0BzPgiJtLDKmmkW0ypBS8pnjjfqsNnkxlxRwMM9/i37UAAg3T2flhWVH
	 QZUh4mK+m4nA+vagIXDeCVsWDPPIHP/f5SNG8d4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1712/2151] ALSA: jack: Protect the index scan against control removal
Date: Wed, 18 Nov 2026 15:57:27 +0100
Message-ID: <20261118150224.186623760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



