Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58513158878;
	Tue, 23 Jul 2024 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759674; cv=none; b=dLvYWxtgejL1jXjFMdxH+F68jwdJg5nL0GGye2+mdVugN1rZ3RjMdKdbZzBToWCQ6Y8XZpDS6xWOzLlNDfmlVyG10UOR7yARLiar4vtoW9opLXnxS3QJS1KJ3RAzEI4TOEjTOdAwrqqG69FF3X26jjRxZJxNQ0dE00/9gTPq+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759674; c=relaxed/simple;
	bh=y1SFZgK7rAu9Enmgf7Gqd/oovAy10sDpekUq12s7XIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxU3M48lD8/Vqpk+3PMOWR0lXAL3T8B8CX37EOsXJx+Crq9oDo8sBRHiVYGDJ4ZTBHYeblRrNRJqctgSK2yQpfuHNfCcGSLKgvxdvyZWbWIe2URdrms+ZtWQz4X1NtUfr58QmqpHRAxR9yyKFRrytwQGaNnbEnmzqO+Q7sdGLFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEjdj8SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEjdj8SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3394C4AF09;
	Tue, 23 Jul 2024 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759674;
	bh=y1SFZgK7rAu9Enmgf7Gqd/oovAy10sDpekUq12s7XIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEjdj8SGOZgQm6lmwnQDcc5AUnoes9z8qNezkM344SAPpBa1XaYceUKJ/MQFnjl+4
	 I7gipBjdeCSJlm6rYbgn3gB3o7zK/D68VdPvMnFyDU/1yN3x0pK9hkVs/AFo6CErC1
	 Gs/P0gKU+ciYtPqkv9sivWqd79/2YzigieOkU9No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/129] ALSA: PCM: Allow resume only for suspended streams
Date: Tue, 23 Jul 2024 20:23:56 +0200
Message-ID: <20240723180408.187076142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

[ Upstream commit 1225675ca74c746f09211528588e83b3def1ff6a ]

snd_pcm_resume() should bail out if the stream isn't in a suspended
state.  Otherwise it'd allow doubly resume.

Link: https://patch.msgid.link/20240624125443.27808-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index bd9ddf412b465..cc21c483c4a57 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1783,6 +1783,8 @@ static int snd_pcm_pre_resume(struct snd_pcm_substream *substream,
 			      snd_pcm_state_t state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	if (runtime->state != SNDRV_PCM_STATE_SUSPENDED)
+		return -EBADFD;
 	if (!(runtime->info & SNDRV_PCM_INFO_RESUME))
 		return -ENOSYS;
 	runtime->trigger_master = substream;
-- 
2.43.0



