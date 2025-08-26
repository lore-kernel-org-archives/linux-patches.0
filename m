Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FA02BEC45;
	Tue, 26 Aug 2025 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218413; cv=none; b=i2cFKaYprckFKJXfwrSZwGAh1bs5P0kqOPRX9MQcoHLSNDcJ4fSAv+1stUydtrASIZE1drWSFw295GCVPA740ouCan+9FdIkGqwzV/a3I7yUZyPrBJsmob4wRBPWBirLlUCmN3NV22DIhhThDR6c9xK0AledqLlBoCHqqtnGv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218413; c=relaxed/simple;
	bh=peF4RenD7hnA7QnrsmGeMyxfNWfnNDFOPVB88bHrRSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ2thE9Xn8HXC99R6Sn4eXAsqb32KsIQxME+O6jcb1zvc5WgA2CxMe8f32vnyQIkvU8p8YGGc0bnW+wwOw4AJk6j5I4LyJXcPf/xJSI1G10yB1DyVZ7/Tf+hQy2mOKHjRe4q+blY2CVHpN4ZPoh7FArqoagr0CAvY9OoxmJJ/7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJ9cmvsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJ9cmvsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E4AC4CEF1;
	Tue, 26 Aug 2025 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218413;
	bh=peF4RenD7hnA7QnrsmGeMyxfNWfnNDFOPVB88bHrRSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJ9cmvsZ6Cmje+3SzlzepOMBZHIH13aWdbHJAJw2mhWODQVugwdebRtkNwqsr+wJE
	 zHgzDZqeuca4C0yHPI49mZXW2iOsC9BPgKgGfDPQN/n0LHWfb5geveRqauxput9mAO
	 0zE3iT5j8OuPWcTkL01gHsqVQsv6Mu7WFd66nM7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 513/523] ALSA: usb-audio: Fix size validation in convert_chmap_v3()
Date: Tue, 26 Aug 2025 13:12:03 +0200
Message-ID: <20250826110937.092565307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89f0addeee3cb2dc49837599330ed9c4612f05b0 ]

The "p" pointer is void so sizeof(*p) is 1.  The intent was to check
sizeof(*cs_desc), which is 3, instead.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aKL5kftC1qGt6lpv@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 56c945d8240a..1bdb6a2f5596 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -350,7 +350,7 @@ snd_pcm_chmap_elem *convert_chmap_v3(struct uac3_cluster_header_descriptor
 		u16 cs_len;
 		u8 cs_type;
 
-		if (len < sizeof(*p))
+		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
 		if (len < cs_len)
-- 
2.50.1



