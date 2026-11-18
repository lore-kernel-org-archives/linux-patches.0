Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020787;
	b=w4XOpmCQqN6/n4WTiA3ueKNRG5lPYhcOaUNjtGTGEAyxcrb9haX7LIkxzNyMhW4wd/Fp
	 bzAxwjXNzcRv37SW7vygYaLpnZDnKCkOh5sbonvWgoDzalaIsCt7JkxwsT63fxMWT1JhE
	 v7kSFRFzeEotbgr2AsZpAxvvIGPTX8j74idIV0ucIYCRw6xlq0bfWFDZEeQwKGlKy+5TB
	 FFvJEexwhJ+csaatMk2lOt6QYNrpETyMsFOhLFa/pYfQe0NP8smsZVBgZNxcd+Otol4YW
	 3dJCNqWAPe3qUX5Z9XXMQJBytdJfNRgwWyDTUqzMUN7/SI+56JbKZ5bqE64TRQ368FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CxLMHCzP/Y3zisjIdZHg++fSC/3zfz9Mfen0JVEY+DE=;
	b=a7tW4ettcCEvm8uStL7Ppw5MGGxD2cWJYyewlgOwdXfBP+uFHTEuB1+y6Un8Q1Y9UFxL
	 +raZEiESmynOUNYOSeW05QOtesvsaItFxkKMjE5IcPk6wrL7tFRx4u2NjzJYokq/OOo+b
	 8NvYmo9oSBYKJ44TeyfmS9IWH8p1hLjPqpgJzlMgJ0FKtt4VSvHaJ2EDrpRSvvgxUIcYx
	 9UkCtEbvIdYpk1rQwldYk5PEzf1Y2wKWkIE3ivLIUT5n0QAPE44YRl5tHwiBwH5u1OsTY
	 vucO9b5Z6TPfZr2JcpacmLtovSMEjsDzXPvaWAAr1E/GCLc8YMhyGGCBMc5kaEw989A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xm3dlpF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB660A6F7E;
	Wed, 18 Nov 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xm3dlpF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452801F000C6;
	Wed, 18 Nov 2026 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020786;
	bh=CxLMHCzP/Y3zisjIdZHg++fSC/3zfz9Mfen0JVEY+DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm3dlpF/wwRTcvAQXzxbNvjn2bR+Ug19/K/gKp+Yi0VmNbHzq7dBUACevnc9DV4sP
	 k0D4kLf8kMLF8xukU4Yk8O3yUd8NNWSGn1h5T+jP2slIy/oC3TpqMka75m+zBc4v8+
	 Te9o+tK4Rvz38w1XfuaCSuc8lGTUrx0uR8mlOE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2076/2651] ALSA: jack: Protect the index scan against control removal
Date: Wed, 18 Nov 2026 15:55:16 +0100
Message-ID: <20261118150400.773040256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6b6ab34fbde89..36700fda79f3c 100644
--- a/sound/core/ctljack.c
+++ b/sound/core/ctljack.c
@@ -38,6 +38,7 @@ static int get_available_index(struct snd_card *card, const char *name)
 	sid.iface = SNDRV_CTL_ELEM_IFACE_CARD;
 	strscpy(sid.name, name, sizeof(sid.name));
 
+	guard(rwsem_read)(&card->controls_rwsem);
 	while (snd_ctl_find_id(card, &sid)) {
 		sid.index++;
 		/* reset numid; otherwise snd_ctl_find_id() hits this again */
-- 
2.53.0



