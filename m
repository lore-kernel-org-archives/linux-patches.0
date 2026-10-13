Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE4B4FE2CD;
	Tue, 13 Oct 2026 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895151; cv=none; b=pU3ARlJPyK5d5e83Ke6bEYsebyefJtGFvH60xvno8ve4YKBBD4Gc2Cf6xG7pzpIWE1kQWTHA8BX2AchTlFRWSmSbZXvjGq71lCDyVW1T/vH4q3u/JadzfBu1ITYobhJfNSLwlJOzLMSqbyvscWXLmLYLepIyyhsIpc1OYjyoF40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895151; c=relaxed/simple;
	bh=MJNO6VQrO9EKhNwjd9mHJgHhagPRHeDuR67IcKSzfC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS9XlrM8ykZ6NfOshLmrH3HJXH7A+wzYhjFbD9FY07i1IzviTKvyokXu6Kzq/qLwx2t378Q3wQeBlM+XCtePwgo9oancihNGDGh/dyto5C/OvRsScf5v+TnSVnvCNcVhRXZRcjvh2KrC0BOCG51JBKkyLk3EXa3AKtU5Y/qWQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg38ovI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg38ovI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A0C1F000FF;
	Tue, 13 Oct 2026 12:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895149;
	bh=zzq/NoF6hFxP7KYtRxpdjJEAqoc07DIqIKzOrCUdsnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yg38ovI2Dclz3upl4GBMYA6sPIsXAAZX3KZZsH2zD3rEQru+FWw+efdJfV+Q+qPHf
	 2Qe5Hw1IlqNdLvqB9bRFzsK1oeUeRaP0YmFftRZQfttFPbXeyeWmS1OyRwbc9WOJlq
	 UoVkVISv9NGEuziiWUwpYeLD9D9b0+yIMB7QG4Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 176/497] ALSA: seq: Serialize compat port-info ioctls
Date: Tue, 13 Oct 2026 13:35:43 +0200
Message-ID: <20261013112912.067995535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 95b2e0361c88753afa030c10698be0a1a5b67650 upstream.

The native sequencer ioctl path serializes handler calls with
client->ioctl_mutex, but the translated port-info compat path invokes the
same handlers through snd_seq_kernel_client_ctl() without taking that
mutex.

This lets concurrent compat CREATE_PORT requests pass the port-count
check before any request reaches the serialized insertion. The computed
integer port index can then exceed the address field range and wrap to an
existing index. Subsequent subscriber teardown can resolve the duplicate
address to the wrong port and access a freed subscriber.

Take ioctl_mutex while dispatching converted port-info requests, matching
the native ioctl path. All translated port-info commands share this
helper, so their accesses to the client port state are serialized as
well.

Fixes: b3defb791b26 ("ALSA: seq: Make ioctls race-free")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Link: https://patch.msgid.link/20260917105643.90102-1-bruno.produit@trailofbits.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_compat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -44,7 +44,9 @@ static int snd_seq_call_port_info_ioctl(
 		return -EFAULT;
 	data->kernel = NULL;
 
-	err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	scoped_guard(mutex, &client->ioctl_mutex) {
+		err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	}
 	if (err < 0)
 		return err;
 


