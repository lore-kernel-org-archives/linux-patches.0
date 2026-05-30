Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2631A9F90;
	Sat, 30 May 2026 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166986; cv=none; b=RyK7S/JjocvWLNsTX5abMAZq54KSZAqBoeQdfakAANMitRWSIW12mtEPSRQJv+MeHqHiUOxQUXDrvPXSL4x/Ww/f8exp5MTCEZgkuf2D+u1CdAottHv8qxXj1D+WzXTUszY9wPG68alDptMsooGPTS+jg+QIAYWN912VVmc0Rss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166986; c=relaxed/simple;
	bh=UEFBKSwECs9gHZVDQz7+ezdQWUP2tvj+xsJrWLRKSoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgQTFAdbmmyuy4XBqx3txSeQHy9OfT7qk/c4CeA7oU4cPwOFiCb9JgCL6EGpcjTKkpYgo0YBdZBqK6M8vYxP8A7FcwImY4L7vfUhvqDEwArzzqgkMk0xbmxp5MOhferPAPMxZn3Giw2jU/7aylycNfFOgzsXAkGV9TYpZq/qGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIMWfGTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIMWfGTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172831F00893;
	Sat, 30 May 2026 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166985;
	bh=N5YIrPBPBBHNzEKHfVd9pkjKeekcUlUAgeamKcIfNHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIMWfGTZMQH8bWMQlbV0l/23ydrW6R6mXqHl2u9fhbdb7P2fj2SXtvG3xjUoXv5yg
	 IkZ02RLQhKOsh3Vi7HodebUY4M/SAQY8FzGJX6ouVEvEB+oyepa3HO4z75Zglq/Pcf
	 2xn94HKK8uelClACcGG82ZzKFuZkYDaNcTlc/7bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 530/589] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Sat, 30 May 2026 18:06:51 +0200
Message-ID: <20260530160238.640325469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


