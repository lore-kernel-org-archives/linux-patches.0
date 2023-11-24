Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76557364A4;
	Fri, 24 Nov 2023 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnlkVS9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01723C433C7;
	Fri, 24 Nov 2023 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850547;
	bh=G21ioJ3KxOUKWlyibpap79nLI1ij6STtT7uRhvZvkxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnlkVS9YYW5zf0NgcTdvrslxxAZrCUEJwNtjdIp6CskwPYGuE4EwxrAk6mdV9KNNv
	 BThdrzqwrkFlkj/zMl+TWdiifGY/HYSEQjzC2u5E7/mexbG9fTJceDkUjf6KDuaUPJ
	 q9XlNmYCiNnxwQkMCrUxV4XevZ57vNJmcq8DaXGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 093/491] ALSA: hda: Fix possible null-ptr-deref when assigning a stream
Date: Fri, 24 Nov 2023 17:45:29 +0000
Message-ID: <20231124172027.385493265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit f93dc90c2e8ed664985e366aa6459ac83cdab236 ]

While AudioDSP drivers assign streams exclusively of HOST or LINK type,
nothing blocks a user to attempt to assign a COUPLED stream. As
supplied substream instance may be a stub, what is the case when
code-loading, such scenario ends with null-ptr-deref.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20231006102857.749143-2-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_stream.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index 2633a4bb1d85d..214a0680524b0 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -354,8 +354,10 @@ struct hdac_stream *snd_hdac_stream_assign(struct hdac_bus *bus,
 	struct hdac_stream *res = NULL;
 
 	/* make a non-zero unique key for the substream */
-	int key = (substream->pcm->device << 16) | (substream->number << 2) |
-		(substream->stream + 1);
+	int key = (substream->number << 2) | (substream->stream + 1);
+
+	if (substream->pcm)
+		key |= (substream->pcm->device << 16);
 
 	spin_lock_irq(&bus->reg_lock);
 	list_for_each_entry(azx_dev, &bus->stream_list, list) {
-- 
2.42.0



