Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584EE367B8F;
	Fri,  9 Oct 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557171; cv=none; b=BnTtDfEmR8b3ZHAaMmjg9LNBHpUSSa/vRIOV4KMcG9cSzv8GcJbEk/HMIPRWvpBoHmLSn5c+TWxDcvZJy+XaPLDQxZvgS/NaoR/aSCk6Yk+H/S0SkdyJ6rET4eKbofbnd60f6gq+oPk+vlixp1Z+l8TL+fW95n26qun7M+K+MBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557171; c=relaxed/simple;
	bh=5JIZI1DIZlwNzsI8TWfGjqSvj3PEwN8Nkcd6SED2nWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaQetgtWdDXj4Vu+vFVa8GiViKCMZKXcyCjUCRjYnZYPW1Syl0I9Ay9BKdEVRLg0ANqXSYRr1KLj04jbSvHNxbneg4O1Ob4InY62V9OypDnd+m78UWmhyQPmjrzW+1jKNcFLsQM2sk8+4eADJi0cu9U9OXM6yE9X+fvQ54sa7bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=032yej8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="032yej8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3301F000FF;
	Fri,  9 Oct 2026 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557170;
	bh=OSRfZuSv1BJ6VWiWb+SupkkN3+q20h620tMjca676hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=032yej8iQP/1T/gWrUvsJdFhcKiuT65OLITgp6dryx8ExBtl4049Im6bUIfOJpL80
	 u+LosSXpYGhE+wqDX98kcTjZLxqz4cF10uTnhQb9b2UU/9w7WhPrbge3hBjdGUi8Ki
	 6RuCIvJCU8eNc3gOY1jTxdvlRHPAzie9KBs4cNns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 268/428] ALSA: seq: Serialize compat port-info ioctls
Date: Fri,  9 Oct 2026 16:10:05 +0200
Message-ID: <20261009140951.981502409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
 


