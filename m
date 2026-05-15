Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8A23FF1AC;
	Fri, 15 May 2026 15:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860555; cv=none; b=dhFiIR/i33R7EJCkczLwmmmgv4OQFXXxUD0XC7pseaaLIelZ3Hs1XO5SZLUaB8g5wl0dQV+tgwuglJ7i52qCYzlFPMfy/aAf8g6FDGU4uoDnw9u9wivCscRQSlD+w8h8umQWob/C2HuC+4pE1xILHCj+Vn8ZXdBxFbWIL6cSFNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860555; c=relaxed/simple;
	bh=jnZTRx6sw6BXSQdbkpOn856iAirUPtmsGCu8sm3nJd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi5h3ClO2q4OQKoohRW7KOcZrlBzT8vDXLNC2Wfftz8uU2+8HM+XOyXKHgQbV63TCzdK6bRHU4kMQ4USMVuYeLPgg/zRYdiK7G4iVqIRLkfRT6DKT+BBV+evNmNKxwu6DS9TEDnfVt8Z76B/jidhtGy8LNPT8aOYNFlE5ohBA74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqcEr9e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqcEr9e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BDC2BCB0;
	Fri, 15 May 2026 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860554;
	bh=jnZTRx6sw6BXSQdbkpOn856iAirUPtmsGCu8sm3nJd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqcEr9e3bpr8cORDNC63OCoNqqTEmnif6RoHQmCPEZM04TxwbjznhFlcDxa/if3zY
	 tSedwIpo3zvdQfUwsri6FtiBE7FvJf3V8tJcn6zU1lCvOjUqhq7lxDl9U1FvuvkNS1
	 QvAHj94Iv9dV0/XKErBpIKmJQb1sK1m+4FooWeG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Lentczner <mark@glyphic.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/144] ALSA: seq: Notify client and port info changes
Date: Fri, 15 May 2026 17:48:53 +0200
Message-ID: <20260515154655.975318396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b8e49e24cdba27a0810a0988e810e2c68f2033cb ]

It was supposed to be notified when a sequencer client info and a port
info has changed (via SNDRV_SEQ_EVENT_CLIENT_CHANGE and
SNDRV_SEQ_EVENT_PORT_CHANGE event, respectively), and there are
already helper functions.  But those aren't really sent from the
driver so far, except for the recent support of UMP, simply due to the
lack of implementations.

This patch adds the missing notifications at updating the client and
the port info.  The formerly added notification for UMP is dropped
because it's handled now in the port info side.

Reported-by: Mark Lentczner <mark@glyphic.com>
Link: https://lore.kernel.org/CAPnksqRok7xGa4bxq9WWimVV=28-7_j628OmrWLS=S0=hzaTHQ@mail.gmail.com
Link: https://patch.msgid.link/20241128074734.32165-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 92429ca999db ("ALSA: seq: Fix UMP group 16 filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c  |    7 +++++++
 sound/core/seq/seq_ump_client.c |    2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1329,6 +1329,10 @@ static int snd_seq_ioctl_set_client_info
 		client->midi_version = client_info->midi_version;
 	memcpy(client->event_filter, client_info->event_filter, 32);
 	client->group_filter = client_info->group_filter;
+
+	/* notify the change */
+	snd_seq_system_client_ev_client_change(client->number);
+
 	return 0;
 }
 
@@ -1452,6 +1456,9 @@ static int snd_seq_ioctl_set_port_info(s
 	if (port) {
 		snd_seq_set_port_info(port, info);
 		snd_seq_port_unlock(port);
+		/* notify the change */
+		snd_seq_system_client_ev_port_change(info->addr.client,
+						     info->addr.port);
 	}
 	return 0;
 }
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -272,8 +272,6 @@ static void update_port_infos(struct seq
 						new);
 		if (err < 0)
 			continue;
-		/* notify to system port */
-		snd_seq_system_client_ev_port_change(client->seq_client, i);
 	}
 }
 


