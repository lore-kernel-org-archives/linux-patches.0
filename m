Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2871E1A76A5;
	Mon, 14 Oct 2024 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918743; cv=none; b=MhYkbv40q2LLaRlbYKnv+L4mZ/jXG0986MasZDUcLEyKrz/LphRD/84vA0nS9YK7QvtUYMpUKfo+KN9khgII1041r9Sk5FyET5GXga74y6kzJBeWVspuQhTS2QoAlhM07K4Jh6lunKB7r+A85N8mpWHnPCfbc5995P799XVkRk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918743; c=relaxed/simple;
	bh=kM1Suw+S50/uE/mSrfOTm2cOebijuIRhtCp+2kVNp1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOXLsheAqVrYKWoKDLJZxrFxtw6Rn7tNwdfWP43V2IJY7+lmiaTk7ksnI4w0Qj9fCCr6ssz2Q7RpTX8gUyGYUJ5O+iOv0uB9nkoT7kT3Tke/0EB2qdz8D5De4TmJYZHENU4VXaADrwBJXN5w6G71TBvffXD7JF+VWxgtObpqgLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srzzJlFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srzzJlFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDE1C4CEC3;
	Mon, 14 Oct 2024 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918743;
	bh=kM1Suw+S50/uE/mSrfOTm2cOebijuIRhtCp+2kVNp1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srzzJlFmQW1agbnOZvqaIZmvEvnk6FCPxq9+A1cohl9CEpR3Q0qbEOfWss6a1R//n
	 cubZ4LvMTdQmuhm0R2EsKnHqaa7YDyi60sX3cfVBUytYxxp6UjYY7ALiJFAQKHWW3a
	 TvFETqJjXfeYNMmzkeJSP+AnAdWeiuy2LbgDwF8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/798] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Mon, 14 Oct 2024 16:16:05 +0200
Message-ID: <20241014141234.097464955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9620115cfdc09..c8291869ef906 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -967,8 +967,8 @@ static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
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



