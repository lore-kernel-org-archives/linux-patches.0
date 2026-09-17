Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12174ABBA3;
	Thu, 17 Sep 2026 15:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660417; cv=none; b=PuvoywTIWsM2MvyGtioA1+PyU3HHGJZCRKyTgM84L3mBQ1FvazhJ5jfJGJX2k9SDiVlNMroDP22EMjf7/gAHb3CBonstiCrDxuM45aToQgJKTzTEeV88Sz5/cGkoA19wGflPt/z40KJgH40yK3ChSuawyjLJiKb1c8udduiEYKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660417; c=relaxed/simple;
	bh=Z1CiOrCQNOEkEqWAC21kqBIW+Z7whbjkdZorUnNVxJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzGFFIGb4VFOcbnTcYIMmPCQf3wd81BA1At3ZV2ELnqjgemyBj2gXoGNCigeYz7dmX/ZE3oT2Cp+o2RvCO04E4qVi5U7s6PaxgffnEmoOLIQeiM0q9FI0cVR1g05MDgjJtwnsVSbE2Ap2Zl0uxP0U2iqc0xSxSiqT9/tMMSMhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka0pWA6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka0pWA6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249971F000FF;
	Thu, 17 Sep 2026 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660416;
	bh=jJlSazxRD/RdRkav4vauWZWZUFSNto5IYoaUIXAHUSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka0pWA6F2Owt8zvtHAmugFNbstHR4Nk/16Ip0UYpmIH7F8Mmi3l3HwwzJ9Xge5oin
	 Y8bRZ+6osFjkMGlzve6QVyHyfintsENZSUJS953/dYe33r/01Ah/CUCMqiP6j+/3V7
	 VE8QRvfpmm3b+wskFDGq+UNoXBdRgdXryjETzXJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 586/733] afs: Fix missing kunmap in afs_dir_search_bucket()
Date: Thu, 17 Sep 2026 16:14:54 +0100
Message-ID: <20260917151407.021117997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 950ae84b5cc944fbe27d81806d0b76af765f779c upstream.

Fix afs_dir_search_bucket() to kunmap the block it's using in the "bad:"
path.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260716103030.3065561-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260902121024.3328255-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir_search.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -173,12 +173,11 @@ int afs_dir_search_bucket(struct afs_dir
 
 	ret = -ENOENT;
 found:
+bad:
 	if (iter->block) {
 		kunmap_local(iter->block);
 		iter->block = NULL;
 	}
-
-bad:
 	if (ret == -ESTALE)
 		afs_invalidate_dir(iter->dvnode, afs_dir_invalid_iter_stale);
 	_leave(" = %d", ret);


