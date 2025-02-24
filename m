Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5E1C84C8;
	Mon, 24 Feb 2025 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408008; cv=none; b=foVJBq/zpypHJwQc1iX/Tfp0+39QmWrN2ThyCXnry7/GQgKrH25lLjvTPUCPYqbNB91+R1NKiltX1v7wrRFsNL4wts0y09GiIKekwJkGX0yS9JcebPB20FPLH/crRHB0pLcp1XtyovMwn1l6UKJK99+FkEB2lAzT4wkh+IGgHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408008; c=relaxed/simple;
	bh=TPIU/quxUHBAjjPvI+8WDWu0UvtpqZVhLLYlVuvJOF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUU1Mxi3OcKmUI6ppRIfou/B7G6cNtUCk8OiVtfR6cUVOvQvcFOdoMLG+iLNzLYGeN/oCLjwjE77IAloLFKIUqE35Cl4yV9ZQgDqPm4vIp7kaaHu7UALovzRyQsA7KeZipNCeaSryKBsV+eYQT47mBHxROANxqyWWb6sHNnuKKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRU3iI70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRU3iI70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59469C4CEF0;
	Mon, 24 Feb 2025 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408007;
	bh=TPIU/quxUHBAjjPvI+8WDWu0UvtpqZVhLLYlVuvJOF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRU3iI70SfEnETPnYMeDG4i0vty+ZMolcYzFf2DuprMdX94Bygu+z1y4uQv6y5qwn
	 LLFwinhEKLl/T4oQtcE96AFrTx8IQu9zSeubEjIun+1cDSR3LygNAkpR0w/sV+3irx
	 +pg7atMrUfsNUb4iCecUaK11BE1zzxBTzGix8YtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/140] ALSA: seq: Drop UMP events when no UMP-conversion is set
Date: Mon, 24 Feb 2025 15:34:32 +0100
Message-ID: <20250224142605.877308783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e77aa4b2eaa7fb31b2a7a50214ecb946b2a8b0f6 ]

When a destination client is a user client in the legacy MIDI mode and
it sets the no-UMP-conversion flag, currently the all UMP events are
still passed as-is.  But this may confuse the user-space, because the
event packet size is different from the legacy mode.

Since we cannot handle UMP events in user clients unless it's running
in the UMP client mode, we should filter out those events instead of
accepting blindly.  This patch addresses it by slightly adjusting the
conditions for UMP event handling at the event delivery time.

Fixes: 329ffe11a014 ("ALSA: seq: Allow suppressing UMP conversions")
Link: https://lore.kernel.org/b77a2cd6-7b59-4eb0-a8db-22d507d3af5f@gmail.com
Link: https://patch.msgid.link/20250217170034.21930-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 8b7dfbc8e8207..54931ad0dc990 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -682,12 +682,18 @@ static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 					  dest_port->time_real);
 
 #if IS_ENABLED(CONFIG_SND_SEQ_UMP)
-	if (!(dest->filter & SNDRV_SEQ_FILTER_NO_CONVERT)) {
-		if (snd_seq_ev_is_ump(event)) {
+	if (snd_seq_ev_is_ump(event)) {
+		if (!(dest->filter & SNDRV_SEQ_FILTER_NO_CONVERT)) {
 			result = snd_seq_deliver_from_ump(client, dest, dest_port,
 							  event, atomic, hop);
 			goto __skip;
-		} else if (snd_seq_client_is_ump(dest)) {
+		} else if (dest->type == USER_CLIENT &&
+			   !snd_seq_client_is_ump(dest)) {
+			result = 0; // drop the event
+			goto __skip;
+		}
+	} else if (snd_seq_client_is_ump(dest)) {
+		if (!(dest->filter & SNDRV_SEQ_FILTER_NO_CONVERT)) {
 			result = snd_seq_deliver_to_ump(client, dest, dest_port,
 							event, atomic, hop);
 			goto __skip;
-- 
2.39.5



