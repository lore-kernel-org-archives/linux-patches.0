Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CF04F390A;
	Tue, 13 Oct 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891971; cv=none; b=X17WtVRIKvNESb94dDDndBrrVzyiLEqkncWnAR27cCAWkF2G8URe9cRthpsygMXXQTdVxZ71wNh/4vxhyhEiGSAFe2CXoedGvRfWJFJdTYDgNxxteFXkJRty1ZnIK/39fnXFPPMKIWJw/TPlMiGP5juCDKDRktUgxujbd0H5xqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891971; c=relaxed/simple;
	bh=oVxLEhzKn+V/jOuapf66qgv0k8gEZE+F0ag5/nFKjF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJ1n0GT8aSBr7KlJqKInbt9XH3kYJrgqbFMZM+d5wFFkBUXqYwVDHfgoeTQe1DW8IPAs6AmGq+jc+1PBnon7Fo1ZQpgSke8bShQmM9ucKuFaGIrQoGeiVSdhJuI+yYRjsyqxK6q70QdxVRcUvjRJu4oRBPz1IRhMcT6ORZBn9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6NtvHVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6NtvHVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0D11F00898;
	Tue, 13 Oct 2026 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891970;
	bh=eVlv5NIXRinjfUNNLRTweCG6oNqBIUz3l2B/P8sVerY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6NtvHVEtmlBD2DLlLOZrhAl8xRhIs7bAf/MCqZUY/Y3exlrxTOdYJoNdqv6qa8oy
	 g1o3xiI2VStcN8UEfe41xRYiQufVG5Y6MTG5uYMAKoQw3rxLK4SeC8lkF7xHklTYcC
	 j2Mph5LU+/GimsEcmarKsY3xf9pzr48XduhnpR8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 018/281] ALSA: ctxfi: Fix memory leakage when clearing DAO input mappers
Date: Tue, 13 Oct 2026 13:35:34 +0200
Message-ID: <20261013112855.493005146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -221,14 +221,18 @@ static int dao_set_right_input(struct da
 
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


