Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7618933F595;
	Thu, 28 May 2026 20:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001277; cv=none; b=YzlaQOxi9pFhP5Hq+oAiJ1szef3ARUULlXybR5JcEa9dO0BUnFiwgTli55b6/xVf0+wgaw+lb1nNJzOKvnfc+h2dfh0ThluTJgakzZn868Q92IPXiiDCZkKaLpkOu4JdheZ03Bm8cnpalXS0TFxb9k+ZBfd6u+zeCopqlOYjRxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001277; c=relaxed/simple;
	bh=3fJ07+tJtuLSUpqE45RHWN4mZD1UbdO9wZMEk7MkO+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNslG6TnqBmA2uCO202um10pgpL6dr6uUNDnh8hqEATGsnqXqlUkdUf3FuFrfLeh54MQwzd8YwDcOVf0RxUJwgNwp2oqDZ5lAzn2P9imkLkQ+PB308XA1ngM4CmunGu78AKxVyzU2kt2/b1zfDuabDEGmjwEfTfZQy1mDUCfYiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjtFTg8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjtFTg8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A1D1F000E9;
	Thu, 28 May 2026 20:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001276;
	bh=RHAB45tVw/ZhDYWCdXkmpHjy1JRI/Gbpe0bUZIYqO/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjtFTg8ZNL/mf9pdh4iFogGP8RQFTI7X6w+wU7Bcc7zPeNlbcXua8VVHbf3kzgzl2
	 gbFnTlahrfIAJkVu6zELlHBJl9pvAUhxtGlI095S8GpRsZssgbY2nfA7o/skI6V2no
	 QtFoQXR4oLcyoarJmry2W7RQ9SpIMsFaPwPdKwwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 031/186] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Thu, 28 May 2026 21:48:31 +0200
Message-ID: <20260528194929.802751721@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7b7d6572145c1dab2dd9bfb550b188e5f0ff3c3f upstream.

find_control() to retrieve a cached info accesses the array with the
given index blindly, which may lead to an OOB array access.
Add a sanity check for avoiding it.

Link: https://sashiko.dev/#/patchset/20260511230121.28606-1-rosenp%40gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260515085606.242284-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/asihpi/hpicmn.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/asihpi/hpicmn.c
+++ b/sound/pci/asihpi/hpicmn.c
@@ -276,6 +276,12 @@ static short find_control(u16 control_in
 		return 0;
 	}
 
+	if (control_index >= p_cache->control_count) {
+		HPI_DEBUG_LOG(VERBOSE, "control_index out of bounce %d\n",
+			control_index);
+		return 0;
+	}
+
 	*pI = p_cache->p_info[control_index];
 	if (!*pI) {
 		HPI_DEBUG_LOG(VERBOSE, "Uncached Control %d\n",


