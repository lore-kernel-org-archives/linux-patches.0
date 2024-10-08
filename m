Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168901DF97F;
	Tue,  8 Oct 2024 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391277; cv=none; b=IXnTFQqg27K6AP5g564ZYNnIAaZbVIfqHc5liHm5E+W2d65q6MavIc1GtWdToAiixlAvRB+AnOVppbeNTwkBeXrznDQ312mExJ6TEmay2sen8y0Rz2HSyRIPi3N8oCiYJizAoe286Xys3IUpFuOGLqtCJG6867nnHRuAkF2WG/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391277; c=relaxed/simple;
	bh=LfrqeDMDI3MFeIhl4yiuccFDVl/DR2MT+8LWFlf7Gvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OznsZp9P2iRiFcNEvHIaitLMwUh3FfxVC4B82oXVXy/YaWC806o9q8hNudSxDboVrUhzi1Imi+s16yQkhh9/QCxOweJzLBqG3X5pPyO6lQPU7wMcycvn3Y9YUwniNXK1UTuYjLvwOH19WBy5BPHvcjHSJkyY9EkPNaW0gyZ4rgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdQIQdJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdQIQdJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72956C4CEC7;
	Tue,  8 Oct 2024 12:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391277;
	bh=LfrqeDMDI3MFeIhl4yiuccFDVl/DR2MT+8LWFlf7Gvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdQIQdJAnWbdzlaDpgr5suhfj2ggbA9swfkTzttAObeyOnN67lCbk/p2CGoF9Bv2k
	 +Pet0z3xkEiIAz+ijQjqbo5UNm3XE2aPiSn30EwCZrLYI1UbmCCr/DlXMoONOnSpq+
	 kY6DxxQzC0pMDeUMTN5C8oPfZI/zTwtg/a3ebqRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/558] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Tue,  8 Oct 2024 14:01:33 +0200
Message-ID: <20241008115704.699234940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



