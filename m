Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8030442315E;
	Wed,  4 Feb 2026 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218021; cv=none; b=i6QV0zXvi3NMPt0jJNVBgIebWxdK4VT+fFdGQtu+enegMmWELBhwZoRMJcmsM99VDMFgucr+nETCkwIi/eIDLCspKbBEH6aKqT0hr4nqBFbk+tYpxYGiBfWBg8RgUjZLqZvXF4n8KZDXf8IZC37ivQgE+mfrBo57PmJbCjY7PWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218021; c=relaxed/simple;
	bh=Vah/wqgHkRuLec5x0zMoEuoyFXhoQbqncVLC93tBLzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFyd5ukmukyW6pexDTU6uBHjLR+rHl50afBnv51v5/Ea0nxCX/CCzy+8851kg0OfvNpmD7r/f0EwFfCA+wwCRGPKlCt2Uej7z7qCJ7XNXeCF2gMeAoBRvLLDFstyGpw5IqcwI6DD4XyEFQ6LkVCxBr5I/049DszP+zcRIt4ek5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qksHCqLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qksHCqLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE8DC4CEF7;
	Wed,  4 Feb 2026 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218021;
	bh=Vah/wqgHkRuLec5x0zMoEuoyFXhoQbqncVLC93tBLzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qksHCqLOI3+hU2XhFxigfO068iGWfKx4VnyFMkIioKu1wkxRjcrGI/tSA+qo0RxeH
	 cxZLHSkYbZbgSW+bbSswHTTpTjmS73TZ1ZRL+oJYxmqWQgaNyXfZG4SAU5c1/mJwS0
	 AKLArbqJCXsgbAPIb81YWEVZ2n5LxazBM5Pk1Quo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Karsten Hohmeier <linux@hohmatik.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 161/280] ALSA: ctxfi: Fix potential OOB access in audio mixer handling
Date: Wed,  4 Feb 2026 15:38:55 +0100
Message-ID: <20260204143915.420466638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 61006c540cbdedea83b05577dc7fb7fa18fe1276 upstream.

In the audio mixer handling code of ctxfi driver, the conf field is
used as a kind of loop index, and it's referred in the index callbacks
(amixer_index() and sum_index()).

As spotted recently by fuzzers, the current code causes OOB access at
those functions.
| UBSAN: array-index-out-of-bounds in /build/reproducible-path/linux-6.17.8/sound/pci/ctxfi/ctamixer.c:347:48
| index 8 is out of range for type 'unsigned char [8]'

After the analysis, the cause was found to be the lack of the proper
(re-)initialization of conj field.

This patch addresses those OOB accesses by adding the proper
initializations of the loop indices.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Tested-by: Karsten Hohmeier <linux@hohmatik.de>
Closes: https://bugs.debian.org/1121535
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/aSk8KJI35H7gFru6@eldamar.lan/
Link: https://patch.msgid.link/20260119133212.189129-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctamixer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -205,6 +205,7 @@ static int amixer_rsc_init(struct amixer
 
 	/* Set amixer specific operations */
 	amixer->rsc.ops = &amixer_basic_rsc_ops;
+	amixer->rsc.conj = 0;
 	amixer->ops = &amixer_ops;
 	amixer->input = NULL;
 	amixer->sum = NULL;
@@ -369,6 +370,7 @@ static int sum_rsc_init(struct sum *sum,
 		return err;
 
 	sum->rsc.ops = &sum_basic_rsc_ops;
+	sum->rsc.conj = 0;
 
 	return 0;
 }


