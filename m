Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A634216C;
	Mon, 20 Apr 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701409; cv=none; b=nD5gKFFlbEJLhmHRY8qDy45ESNXqhKFX7wPrqxLcbW7LN9nGMxDH+rNEIODVF51fx4ZKjAQECeyqGXKJ24eqlzBQNz0D7Pi1lRSZi3TUobBHBdjYE2+vYrnTbY4KyA7nUV4stje2mWvZ3U4z0QMVuIzSnDN5B9yifw+nYxndayA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701409; c=relaxed/simple;
	bh=O3RUAERcUEueS9+lrNdJe8jZ/BNn7a0+RunE0dZf3s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp46zFu15UFIECbtxJYVtxRbFp3xlVbVnZuNYYvqnrO2KVCiG4nifUqAgURpdut5FZnR4an632hj3PQji2JVD+6qyLt53zSFbKEeR0MVLsuKIQR3WXnwykZ7uHXDoO2Cim8sJAcF6F9fI9qPB9sr0HYjxnbjBeb7tGZkYYGXSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYGvYCqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYGvYCqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE6BC19425;
	Mon, 20 Apr 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701409;
	bh=O3RUAERcUEueS9+lrNdJe8jZ/BNn7a0+RunE0dZf3s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYGvYCqOyyk/qe7K10T4g6k0iRwIihxq7UPT9zT3FMtb1S+lcxwtHTA9YYgZVXc91
	 yLVaAY6NsIcAACk5wYhKnKEMWYblrJp2FxjTvjUg6Tjmn9b+lgAOZl+VZ5dTVxF+il
	 D0ajVz9l/flA5dC/SB7pNMMlzIXYkSe7y1VRjPPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clemens Ladisch <clemens@ladisch.de>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 102/162] ALSA: fireworks: bound device-supplied status before string array lookup
Date: Mon, 20 Apr 2026 17:42:14 +0200
Message-ID: <20260420153930.734643074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 07704bbf36f57e4379e4cadf96410dab14621e3b upstream.

The status field in an EFW response is a 32-bit value supplied by the
firewire device.  efr_status_names[] has 17 entries so a status value
outside that range goes off into the weeds when looking at the %s value.

Even worse, the status could return EFR_STATUS_INCOMPLETE which is
0x80000000, and is obviously not in that array of potential strings.

Fix this up by properly bounding the index against the array size and
printing "unknown" if it's not recognized.

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Fixes: bde8a8f23bbe ("ALSA: fireworks: Add transaction and some commands")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/2026040953-astute-camera-1aa1@gregkh
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/fireworks/fireworks_command.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/firewire/fireworks/fireworks_command.c
+++ b/sound/firewire/fireworks/fireworks_command.c
@@ -151,10 +151,13 @@ efw_transaction(struct snd_efw *efw, uns
 	    (be32_to_cpu(header->category) != category) ||
 	    (be32_to_cpu(header->command) != command) ||
 	    (be32_to_cpu(header->status) != EFR_STATUS_OK)) {
+		u32 st = be32_to_cpu(header->status);
+
 		dev_err(&efw->unit->device, "EFW command failed [%u/%u]: %s\n",
 			be32_to_cpu(header->category),
 			be32_to_cpu(header->command),
-			efr_status_names[be32_to_cpu(header->status)]);
+			st < ARRAY_SIZE(efr_status_names) ?
+				efr_status_names[st] : "unknown");
 		err = -EIO;
 		goto end;
 	}


