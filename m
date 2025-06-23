Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB32192EC;
	Mon, 23 Jun 2025 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717504; cv=none; b=SEeRQXNEKE4BTyCp9MmXmagYAABzWHzMEnJnR5C4BOu1O2Sm4r05rqo1PJLFrJpaS96gTlkTlhSVw1uCRG7QhWYuzKnJK1a0sYDDWdMBbuZ0tN2oEoqBy4YfEz9QdBt1C1ooc+E22iHSWLayC4kc+YFA9f3ezrW38dSTjwPuL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717504; c=relaxed/simple;
	bh=tgln7OInEwZBmgXD5Va/iFQK6n4R5Lhboq4r/nfUzJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iupog9tKi00vWVflHzxzLmbX8mIetc+bQsrI6lNTX3fa0EFkPO/Pw7y+Zc+nWWK/8fDFRetLLaCW0LQUUTy9T+Fs4Lwagon24Xt6BEp7b3y17q2kP7ap8G8I2a8sLJs+HuP1YI8tbD4Qic3EXm8i6cmzb5g22k+WarbpU5AVVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCDKr+HS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCDKr+HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A16C4CEEA;
	Mon, 23 Jun 2025 22:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717504;
	bh=tgln7OInEwZBmgXD5Va/iFQK6n4R5Lhboq4r/nfUzJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCDKr+HSru5ll5JDKGNlh1qy/EfhLbQWjlg9g/rnqesVy4GaYXMIXIyHMi9N+gUSt
	 vIDCWoJqr448OFMl4jBcwQy2V8RWRupzoV7LqXbsbd/R2/943Zo7BHTF1u83pr0Lyc
	 0XWPD4Qs8QhCFp/rLWHHXc+Or66y3lfI1hwMCOiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	maher azz <maherazz04@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 442/508] drivers/rapidio/rio_cm.c: prevent possible heap overwrite
Date: Mon, 23 Jun 2025 15:08:07 +0200
Message-ID: <20250623130656.038279118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 50695153d7ddde3b1696dbf0085be0033bf3ddb3 upstream.

In

riocm_cdev_ioctl(RIO_CM_CHAN_SEND)
   -> cm_chan_msg_send()
      -> riocm_ch_send()

cm_chan_msg_send() checks that userspace didn't send too much data but
riocm_ch_send() failed to check that userspace sent sufficient data.  The
result is that riocm_ch_send() can write to fields in the rio_ch_chan_hdr
which were outside the bounds of the space which cm_chan_msg_send()
allocated.

Address this by teaching riocm_ch_send() to check that the entire
rio_ch_chan_hdr was copied in from userspace.

Reported-by: maher azz <maherazz04@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -787,6 +787,9 @@ static int riocm_ch_send(u16 ch_id, void
 	if (buf == NULL || ch_id == 0 || len == 0 || len > RIO_MAX_MSG_SIZE)
 		return -EINVAL;
 
+	if (len < sizeof(struct rio_ch_chan_hdr))
+		return -EINVAL;		/* insufficient data from user */
+
 	ch = riocm_get_channel(ch_id);
 	if (!ch) {
 		riocm_error("%s(%d) ch_%d not found", current->comm,


