Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7552080FC;
	Thu, 12 Dec 2024 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015953; cv=none; b=rPmp0Q9rgd25WZ7qF3P3gZH5r7KZleZUG/0PI2ZvYKAmkG5XOEQElOg5Z7J9L+GVGUwdr2N3x8x+rcx5QoAW+Kg9Ty4vBHDdKR7ZyVbk3t3ziVcBxNurEy5YaSwsmS+AMTPAbscYa83XB87ch0unLYHsZaDV+7NkJ2oyiX6zuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015953; c=relaxed/simple;
	bh=UT+2cNNATiI75AoYoournL7hOwCWTITHT+CU15Cl/hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZQX9BQOQBc6fya15vcV+M9ykvA3r2gd5Ffd+w5eXBeg4XPZBl8DqZDW1HSawPw4p0LjGYHmmE8RHckPZbF4mB5P2evErXxhdqlydZR8meJDalwdzy1hdc5V8Hqr9ZvKHenUDoQaQ+P+1hH73y8STV+qh8sOcG4X8BxJ+nIWOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1ncEPxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1ncEPxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EEDC4CED0;
	Thu, 12 Dec 2024 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015953;
	bh=UT+2cNNATiI75AoYoournL7hOwCWTITHT+CU15Cl/hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1ncEPxvr+KxmoTg6V51NX/UTrDAVok4rYEpfhLufv8QpmK+SAFYS71QUWsf4Ip9d
	 pJXDRlAPb6aqExfcNRoYsybZRBunY8axQajkKZSsFykty3h7ybT0I8eJylr4/TZNZa
	 wesynXeBLDz3bqNICRVFlpI1ZwoNDAWHhw6a3HhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/466] ALSA: seq: ump: Fix seq port updates per FB info notify
Date: Thu, 12 Dec 2024 15:54:18 +0100
Message-ID: <20241212144310.333022086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5d3f4d206bf6..e956f17f37928 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -257,12 +257,12 @@ static void update_port_infos(struct seq_ump_client *client)
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
@@ -271,7 +271,7 @@ static void update_port_infos(struct seq_ump_client *client)
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



