Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC24F68BC;
	Tue, 13 Oct 2026 12:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892840; cv=none; b=Tnl4iZr9zw08nYLLXAXHr8kz12HKZErER4H5BIcu5RKh6QFCkkvMCEJS3ddCy/QJaQ/F0Psx3PdshDtzDtkZ0WjLv95xhzg899YSC0kEU+Yl6ptM7TGG8wSHlpuneGH0dGkxowPlwvi2yT5PhqCbZLgDxeV4aCxmjf+pokl82q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892840; c=relaxed/simple;
	bh=AKYmpCkbcCQ1c4cTVeSGyqXW3Dm2vbyfHk7zw9szSOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMKWVEm4sFSKs1aWN0z2UUI5ZVvg6/IZeJoeC1EnxG5mXlyB3wN/+bd6q+e1DVIRML1u3dgZRXwTHYAQgK+ZUMPFH5keM/a51TOY9c0xLSmuRuNgg1qQfu7siEK5TcyEDRiL9Nleh0MSMeY+534wYd5Ex7a/bUBW6tgcVrZyfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6JTt7yN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6JTt7yN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672C31F000FF;
	Tue, 13 Oct 2026 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892839;
	bh=rGClOVSAU2N3IH3uwHFxH9PblBnqOgBuI9lZOyPByjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6JTt7yNuVr51elg4PmIt2XxpXbhmlUhftSYIhZyOSTbg/6dGwY++/L4WlrZqPXd8
	 kAcNlu6MDPo4yO4aAsCbsiDAzlBexYBMFU1pr0MTSVJ1o6NeCW0cCMare5fQ4SnQV/
	 4HD7squJL+oXtDBro//i2NPkhoGAKEiSS5mLADgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 026/621] ALSA: ctxfi: Fix memory leakage when clearing DAO input mappers
Date: Tue, 13 Oct 2026 13:30:21 +0200
Message-ID: <20261013112921.487568421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harin Lee <me@harin.net>

commit 593d46fc6af9a0178a46e77d6d24b20d2314165f upstream.

Commit e576e7843c0d ("ALSA: ctxfi: Simplify dao_clear_{left,right}_input() functions")
centralized the DAO input mapper clearing logic in
dao_clear_input(), but omitted the kfree() calls.

It removes the mapper entries from the list and sets their pointers
to NULL without freeing the allocated array. This leaks memory each
time dao_clear_input() is called.

Store the base pointer of the allocation before clearing the mapper
entries and free the array after removing entries from the list.

Fixes: e576e7843c0d ("ALSA: ctxfi: Simplify dao_clear_{left,right}_input() functions")
Cc: stable@vger.kernel.org
Signed-off-by: Harin Lee <me@harin.net>
Link: https://patch.msgid.link/20261001144501.3050667-2-me@harin.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctdaio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -214,14 +214,18 @@ static int dao_set_right_input(struct da
 
 static int dao_clear_input(struct dao *dao, unsigned int start, unsigned int end)
 {
+	struct imapper *entry;
 	unsigned int i;
 
-	if (!dao->imappers[start])
+	entry = dao->imappers[start];
+	if (!entry)
 		return 0;
+
 	for (i = start; i < end; i++) {
 		dao->mgr->imap_delete(dao->mgr, dao->imappers[i]);
 		dao->imappers[i] = NULL;
 	}
+	kfree(entry);
 
 	return 0;
 }


