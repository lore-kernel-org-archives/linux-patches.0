Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477E3F86E5;
	Fri, 15 May 2026 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861668; cv=none; b=tZXLUF95vFkGFEh9pfTWz/SG/eiCKnZuD5wH06TmI6gqj17L+NavYTg13PCrA+EUpBWMq5RftegGhMsK0jCSawZnx577qHQC+V3xDjNLmt4P3LvwJ/0d9IuKPVQZ4ZgrYehiPgU+RNoj2bJhr+96I5AB0egREiA0buNzX8Fqnts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861668; c=relaxed/simple;
	bh=Qa9/9M6jlQR87nX9m3ZPcFHN2Piw3KU+R188zlBS/Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR28eO4BVmRFibD3SpknfLDJl3H1vDzcBemcOIiWhj6Rz1z6bpRV5mS8qnC5BSDhPeE5rUA5XUUcL6qduPwleX2TYWmhx2FrmrUOq1Y168EiJ8K7QT49CYfqp3GIr7K2w9L05uspaSLqtdxDYtsqxpyw9GxiPpy+m2yKXa1OqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t81MLhnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t81MLhnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C95C2BCB0;
	Fri, 15 May 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861668;
	bh=Qa9/9M6jlQR87nX9m3ZPcFHN2Piw3KU+R188zlBS/Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t81MLhnIHsB2A4+3sUaEzXtNCFEvzF3pgLO6vEZ337wWddGJA5xAXtaIzYOAbgUEW
	 GsNxpYuUgCc1PbtVhE56kxtC4H5HJNJXOudYa2KlLDlKtH2+I7vQ+9rxSn3U/HU52j
	 FVu250n1zAu81x+cW3yF2jVNT3m9GF1rzG8zK0eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Lentczner <mark@glyphic.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 416/474] ALSA: seq: Notify client and port info changes
Date: Fri, 15 May 2026 17:48:45 +0200
Message-ID: <20260515154724.060302565@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -1334,6 +1334,10 @@ static int snd_seq_ioctl_set_client_info
 		client->midi_version = client_info->midi_version;
 	memcpy(client->event_filter, client_info->event_filter, 32);
 	client->group_filter = client_info->group_filter;
+
+	/* notify the change */
+	snd_seq_system_client_ev_client_change(client->number);
+
 	return 0;
 }
 
@@ -1457,6 +1461,9 @@ static int snd_seq_ioctl_set_port_info(s
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
@@ -273,8 +273,6 @@ static void update_port_infos(struct seq
 						new);
 		if (err < 0)
 			continue;
-		/* notify to system port */
-		snd_seq_system_client_ev_port_change(client->seq_client, i);
 	}
 }
 


