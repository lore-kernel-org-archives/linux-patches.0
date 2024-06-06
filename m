Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA08198E7B;
	Thu,  6 Jun 2024 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683083; cv=none; b=Y6eJkrsUiit9EWqo2uuQdgea64G2ULfRpkRaGywZBPZlyh5Owky+r9t6wdJWEYWQK9EErMrlucHK6PtTVh0hKz34kTMY1u7B4S+h/AzvYZDsng7oKNL2kbYx/zn2155zsjk/+8MAQ8NMp3eR/D9qbXqFq28tp2awsUK/Nn6wJRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683083; c=relaxed/simple;
	bh=0BZC4dkimIhTVAcS0X3AR3BYRIJK0dzUZFpQciz7AUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2SgNhLrN/4jWQBYcblqPIq4a5QwEh7WVWzatwMNNuWUEz1D8lPxKGcYFVJzsFvHN+i1P/H1YP5gGUyrC59+tJYsUKsyXE1QViI/KpDI1IPAK/ALZxRBntYAHo8qPsQKW8zkSdwPJ1BuHEkYja6jowYxjwdTdBnKm0w5DL+G3oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfGaflmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfGaflmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49931C2BD10;
	Thu,  6 Jun 2024 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683083;
	bh=0BZC4dkimIhTVAcS0X3AR3BYRIJK0dzUZFpQciz7AUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfGaflmEzE7rF2O+UN907ZBi2YkrNRXyOZzcSa7ekC3Xlvm94OiZ9rDWW0aUn0+sq
	 xA82XUSzAhwRalmp92HHzeNRcE1L7WUQmoPP7+ch0NmPkATpdu0UAu6YAlQCWSscn0
	 V8sbbMhQ7A2EBL4xj6f6AfXThPUMvwrRqigCtG2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 355/374] ALSA: seq: Fix yet another spot for system message conversion
Date: Thu,  6 Jun 2024 16:05:34 +0200
Message-ID: <20240606131703.764314382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 700fe6fd093d08c6da2bda8efe00479b0e617327 ]

We fixed the incorrect UMP type for system messages in the recent
commit, but it missed one place in system_ev_to_ump_midi1().
Fix it now.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Fixes: c2bb79613fed ("ALSA: seq: Fix incorrect UMP type for system messages")
Link: https://lore.kernel.org/r/20240530101044.17524-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index f5d22dd008426..903a644b80e25 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -729,6 +729,7 @@ static int system_ev_to_ump_midi1(const struct snd_seq_event *event,
 				  union snd_ump_midi1_msg *data,
 				  unsigned char status)
 {
+	data->system.type = UMP_MSG_TYPE_SYSTEM; // override
 	data->system.status = status;
 	return 1;
 }
-- 
2.43.0



