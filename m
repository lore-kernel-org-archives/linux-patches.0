Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F4F1AF0B7;
	Tue, 15 Oct 2024 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997797; cv=none; b=JZKBO0g9MPe0+JFZ2hfw59FY/9dGybxlfxdfNUg8ZiDNGVLg0bUsK4UQc8e2q/CNLBz6d/AVPVfRh/izqWVp0KJhl8tEFxMZ2mjAt9+2TopC7Fr9WwKi7waK7hVouA/9hE+APNT5kTlB+FdOq8/J+LZBfxvCPC+nDpJcesKXKe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997797; c=relaxed/simple;
	bh=mfXkriexJvcgaZikSyJN1BkogVVY0P/m3UBTDTh6Czc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGXwcTapBp/r4zqWh6+cej9pYpUJPL5NpvTC1+xS7uvtwlNBGEdvIVaAxIS5kRvbyp0mfNwZOymT9/Mo91oTU7mmmetYEgTUOzChov3c656VuWjiazVnDoampwCttcoPnqT2nXRR2CYLwZ87wHS3AlcjN9dMogAZkY4r++6ZaEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMAOJfhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMAOJfhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748FEC4CEC6;
	Tue, 15 Oct 2024 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997796;
	bh=mfXkriexJvcgaZikSyJN1BkogVVY0P/m3UBTDTh6Czc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMAOJfhiSytoTkOeBUF2c1AoetRE4j+JgsADS8E/T2N0si+Mg40AGqTvvBqFYtsdj
	 wpoEIFL2yJOMqFiLnzq2a+AC1yYSr1qqCPzXHSZIwIyZsC6gnrIZ0eLdDmSjhS5fU0
	 aGgwZZhLciYYuieupNEJtLmeS1MSBr4rkQl5Xt0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/518] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Tue, 15 Oct 2024 14:43:13 +0200
Message-ID: <20241015123928.143038126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 368e4663c557de4a33f321b44e7eeec0a21b2e4e ]

"assigned" and "assigned->name" are allocated in snd_mixer_oss_proc_write()
using kmalloc() and kstrdup(), so there is no point in using kfree_const()
to free these resources.

Switch to the more standard kfree() to free these resources.

This could avoid a memory leak.

Fixes: 454f5ec1d2b7 ("ALSA: mixer: oss: Constify snd_mixer_oss_assign_table definition")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/63ac20f64234b7c9ea87a7fa9baf41e8255852f7.1727374631.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index bfed82a3a1881..eb1a6229a31ca 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -957,8 +957,8 @@ static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
 	struct slot *p = chn->private_data;
 	if (p) {
 		if (p->allocated && p->assigned) {
-			kfree_const(p->assigned->name);
-			kfree_const(p->assigned);
+			kfree(p->assigned->name);
+			kfree(p->assigned);
 		}
 		kfree(p);
 	}
-- 
2.43.0



