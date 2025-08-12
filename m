Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E7F247287;
	Tue, 12 Aug 2025 18:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024662; cv=none; b=F46aJvj34MRKkvrHB/XldhJ6GrWa8yTabPgj0B5xFkZSH0U5lCqVKhzduqJZrl1nGjDU2Su5ElFkiQ47XAZpl1EUsnkCLQcFOJ2SQC7t7I6hK2eKosVYyxMbbCyB1X1Zovno05Egy0AiNi9TKICwCqVtM888p0qhQm6z6TfBZQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024662; c=relaxed/simple;
	bh=aeyFVODnCGVxqzkOBj5bWh4KFNim57foklb7sZ/CUe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGfVH6W1WoBg3uIvdXNWCYwsh97lSBdVok7h31QVSg3eV+5uWHUYEnPeitD1ZRSfYvV86qLRxG51E+IYYf5h3f5zNCuRxyqPHTqtLVkTJ1wyj5sP0evH4JnunPWrAmAEWJXKNUhObWWnpfaual1x743phm4iwc4tMBjIj5MT0Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O18O3ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O18O3ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B9C4CEF0;
	Tue, 12 Aug 2025 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024662;
	bh=aeyFVODnCGVxqzkOBj5bWh4KFNim57foklb7sZ/CUe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O18O3nsbl43dybBzqOHsSOxoXH/IkU3mBv8bVkaPiCb5x4Af+FWvLkDoNR1kALh9
	 LoiqWaP9AcGiYHyToXW020kX9pb2DbYNcYlhO+oMWQL/+nbEk8HWr/396vhw8lJEY7
	 hR6HLLAtSCA+7gesIibE/GjFh3cRrXsVewDFPn8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 439/627] ALSA: usb: scarlett2: Fix missing NULL check
Date: Tue, 12 Aug 2025 19:32:14 +0200
Message-ID: <20250812173435.978889278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit df485a4b2b3ee5b35c80f990beb554e38a8a5fb1 ]

scarlett2_input_select_ctl_info() sets up the string arrays allocated
via kasprintf(), but it misses NULL checks, which may lead to NULL
dereference Oops.  Let's add the proper NULL check.

Fixes: 8eba063b5b2b ("ALSA: scarlett2: Simplify linked channel handling")
Link: https://patch.msgid.link/20250731053714.29414-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index 93589e86828a..c137e44f8f8c 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3971,8 +3971,13 @@ static int scarlett2_input_select_ctl_info(
 		goto unlock;
 
 	/* Loop through each input */
-	for (i = 0; i < inputs; i++)
+	for (i = 0; i < inputs; i++) {
 		values[i] = kasprintf(GFP_KERNEL, "Input %d", i + 1);
+		if (!values[i]) {
+			err = -ENOMEM;
+			goto unlock;
+		}
+	}
 
 	err = snd_ctl_enum_info(uinfo, 1, i,
 				(const char * const *)values);
-- 
2.39.5



