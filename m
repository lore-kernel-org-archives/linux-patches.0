Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E6C2139CB;
	Thu, 12 Dec 2024 15:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017818; cv=none; b=lvEbfJdGcyqjs5sh3UiErwB33diVHdaOGpCl4Yt8VWcDnbMiz036MyswA5EDGJpZ5S2zwfmGsWjOf+ZlqFmzzsOTIxKtT/youoYEM0f9Dc5btaODy7t0M1V6LH5pd0CsrTwg8xcHpsFmwFdqLChjGSB8z3sgmtTmleNVb57EGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017818; c=relaxed/simple;
	bh=pF2HcqScIK46DMFAaA0juOn4w4eqLCYG6UJ/96PPfvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFnDPpb1MrW2yRmHHOs/UG2RBGH8/lpYd1hye3CXRm5uUZKqW50mtcF4ldfFEg3yGRiy91HWFLDRgmBnVkXdCqgne6If1ClmNocFHlJCsdalp98Oa0VuOGUFImuNf7uRN5evMlQbtyXaw7r3daAgap3Q7Wvs4aPzcKj5F23T9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5XxyXE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5XxyXE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC21EC4CECE;
	Thu, 12 Dec 2024 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017818;
	bh=pF2HcqScIK46DMFAaA0juOn4w4eqLCYG6UJ/96PPfvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5XxyXE78s9JaZIFs6ZRvF1lCIeoExLDqf/jBE1BQ0O4rFcAesZ2gZI6TNiPQY3zw
	 IYvpQwAIc8f7H63uHAVYbF32Gg6jUTYrnRmf5uWB9i1Vs/3d+XMv5uZ9ZUeIK6kAfW
	 7TRsk+yob8bHrEGcOMGVRegEimjSBTnj2kCZZhus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/356] ALSA: seq: ump: Fix seq port updates per FB info notify
Date: Thu, 12 Dec 2024 15:57:18 +0100
Message-ID: <20241212144249.356475554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit aaa55faa2495320e44bc643a917c701f2cc89ee7 ]

update_port_infos() is called when a UMP FB Info update notification
is received, and this function is supposed to update the attributes of
the corresponding sequencer port.  However, the function had a few
issues and it brought to the incorrect states.  Namely:

- It tried to get a wrong sequencer info for the update without
  correcting the port number with the group-offset 1
- The loop exited immediately when a sequencer port isn't present;
  this ended up with the truncation if a sequencer port in the middle
  goes away

This patch addresses those bugs.

Fixes: 4a16a3af0571 ("ALSA: seq: ump: Handle FB info update")
Link: https://patch.msgid.link/20241128170423.23351-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_client.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index 91773f8ca7828..1c6c49560ae12 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -258,12 +258,12 @@ static void update_port_infos(struct seq_ump_client *client)
 			continue;
 
 		old->addr.client = client->seq_client;
-		old->addr.port = i;
+		old->addr.port = ump_group_to_seq_port(i);
 		err = snd_seq_kernel_client_ctl(client->seq_client,
 						SNDRV_SEQ_IOCTL_GET_PORT_INFO,
 						old);
 		if (err < 0)
-			return;
+			continue;
 		fill_port_info(new, client, &client->ump->groups[i]);
 		if (old->capability == new->capability &&
 		    !strcmp(old->name, new->name))
@@ -272,7 +272,7 @@ static void update_port_infos(struct seq_ump_client *client)
 						SNDRV_SEQ_IOCTL_SET_PORT_INFO,
 						new);
 		if (err < 0)
-			return;
+			continue;
 		/* notify to system port */
 		snd_seq_system_client_ev_port_change(client->seq_client, i);
 	}
-- 
2.43.0



