Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2715E8B;
	Mon, 30 Dec 2024 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574361; cv=none; b=f2Y0fLTM9ETjUduXIupQohhHvmc8rmyOE9WiSIfQsSl+XNUychF9LD0tF4BVukxLydB2dBeXqOUNpi+104RctjkluSOUYY3Df8Qhw2FcHtGyKpP+kocZkOPvfuW59ICoecaxsjkRK18wGNN5Bp2Td6+jeqriU+Coh/hDfqduztM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574361; c=relaxed/simple;
	bh=/PYOcB1HinUFGjDPU8FtSjNrfbO0CqCXzuha4RIqwRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2hSK8aXt7FJEce8/chKMGMM0rJHlyqaV0Z9HoxY4WkA38RIA4e5vPqXQicO8GGJFJ6p4dQWRdZMh4yG760wvU6/WjQu11qSIBZQVsSfFIJGYzME7lIuOo32iLoB4lhox1yq52Vog0bp0mTJCkPPQeBiE3c4CzG+uIxH7BYoW28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjQognlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjQognlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379B4C4CED0;
	Mon, 30 Dec 2024 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574361;
	bh=/PYOcB1HinUFGjDPU8FtSjNrfbO0CqCXzuha4RIqwRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjQognlJU+Z6NMLNPAPTHwgtkFWI6lICgY3iBeURb+RirruqWZynZQbEf0TYN2ouq
	 LjnVPKyrR7z8A048NAA4/B1dnOdMai6EPu0QoPiBTZ/PYx+lGaQp4BropDnVD2zkdh
	 i/yuOQY0gHL0KFz193zYnY/gr8hQn4yNYq1yQp+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 113/114] ALSA: ump: Shut up truncated string warning
Date: Mon, 30 Dec 2024 16:43:50 +0100
Message-ID: <20241230154222.479165396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit ed990c07af70d286f5736021c6e25d8df6f2f7b0 upstream.

The recent change for the legacy substream name update brought a
compile warning for some compilers due to the nature of snprintf().
Use scnprintf() to shut up the warning since the truncation is
intentional.

Fixes: e29e504e7890 ("ALSA: ump: Indicate the inactive group in legacy substream names")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411300103.FrGuTAYp-lkp@intel.com/
Link: https://patch.msgid.link/20241130090009.19849-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1262,9 +1262,9 @@ static void fill_substream_names(struct
 		name = ump->groups[idx].name;
 		if (!*name)
 			name = ump->info.name;
-		snprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
-			 idx + 1, name,
-			 ump->groups[idx].active ? "" : " [Inactive]");
+		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
+			  idx + 1, name,
+			  ump->groups[idx].active ? "" : " [Inactive]");
 	}
 }
 


