Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2DB4C6803;
	Wed,  9 Sep 2026 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962031; cv=none; b=USMwP0NZqE0Tr/Ubt+cPxBhC0Nbcf1XIrlRQaMoUnyEQImz6AFM3QMeV67LZQR+b/nRcvq2qYtgmEXIbnMa3wGEJzJYSGW9e2ozgNI+YS8htbnKGpdw86r8t/SOpl8XITDU+8kfhO+RccrVn/JBwgbeOtNNrpk2Zc7/zXQVMF7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962031; c=relaxed/simple;
	bh=CHaBiJuZ1Z5xYTy+Qth8onLtZoM8CPmGzYo6pZbE+6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNnrNeWXANZ+D1EnijMoLI3bGPEnO1nDD5dL72OL2KCyaLQEsiZ1UAbqCD1ZTG2pB+GLOibTU7Fj2jMhRzq/aIaoyEBslyLnJ8BJQkEPJNjQX/+x2apq8Jk6QTy6YbAjMyFyMUo9AHJb7EUWS+dp8JYe3qXnEWWxj9abFR2cuDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3zsn4wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3zsn4wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEBB1F00A3A;
	Wed,  9 Sep 2026 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962030;
	bh=GpaVttf5/EpfejmN5u9Uyoq2FqM5jbvK+E+S0a42t28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3zsn4wi0UqSaHbXKdyabHr5Au3ph9NV81t5PfTYU03Y0q+Y9zoCTweE/PcdWeGp6
	 FcSncj1iXDjpDv09qZY63FtfhPvGTwQm2X+Mj6TwATRo4Y1hu4wyorYNSVs2/QjguR
	 5N9laXkymnQc8SsPj7lSCbpNC8GD/uYE9JSfHmPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 149/556] ALSA: rawmidi: Return the error from snd_rawmidi_input_params()
Date: Wed,  9 Sep 2026 15:37:09 +0200
Message-ID: <20260909134235.681776671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit f4a23e17d84fd2a152d9e12369761934e1af0ee8 upstream.

The snd_rawmidi_input_params() computes err for the three invalid mode
combinations and for resize_runtime_buffer(), applies the new framing
and clock type only when err is zero, and then returns 0 anyway.  A
caller that asked for parameters the kernel rejected is told the change
succeeded, and the substream keeps its old buffer.

The open_mutex conversion turned the early returns into assignments.
It handled the output sibling correctly, which still returns err, and
left this one behind.

Fixes: 94b98194b62e ("ALSA: rawmidi: Take open_mutex around parameter changes")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260902125058.19499-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -782,7 +782,7 @@ int snd_rawmidi_input_params(struct snd_
 		substream->framing = framing;
 		substream->clock_type = clock_type;
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_rawmidi_input_params);
 


