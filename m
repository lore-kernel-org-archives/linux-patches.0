Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71211E485;
	Tue,  8 Oct 2024 12:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389762; cv=none; b=FuPDnPqNnzuOerSATjt8D78bhlYb8qMN+lhy4RZNEz3ZrD+Z17hh42/KPfAA5U+uK4FfhFn9kGrSN3HgEGxstbMyNJnBGqyyZOSUResnQqcF4WU1EbHlX8c6gtZkWQH/mB0RClZR3VEwiscmT8Jh0oYC/1DmkIepYGfZKvUzmqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389762; c=relaxed/simple;
	bh=3pnxy5RfIUJVvnanme05ymD2wjEBZeqNGdoKMWSU4ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h936T5dl7E88ziZfzWc8krXAx0izf042Yduje2YCstzknv58lP8Z7LLx2R3jQK/HUKXEwsSq+OIeJTRYa18SK41sa3NRkGfzdIIAcS8d3KIaKjiIj/2/TMheYp907vCw7i4xCXrbKbz5JSm3/+lbp4eUXHKPP1Liw46Fjy1OcTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV3MXCKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV3MXCKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B07C4CECC;
	Tue,  8 Oct 2024 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389761;
	bh=3pnxy5RfIUJVvnanme05ymD2wjEBZeqNGdoKMWSU4ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JV3MXCKq35d7OjQzzkvKDKJOW0mZbiqTfSouGsDl4fuih6AbpjRfRxgarlzBSPNxe
	 NhkRzP+/T26Vt11RZL8N3QOU3pfPR6D9Smxirne4Sy9MWjDFACgh7YVFCCJohAsOLu
	 RGCz3U4lwJq5oi6neC03O+5BE6j53V2/APEy2kX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 057/482] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Tue,  8 Oct 2024 14:02:00 +0200
Message-ID: <20241008115650.551437936@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6a0508093ea68..81af725ea40e5 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -901,8 +901,8 @@ static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
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



