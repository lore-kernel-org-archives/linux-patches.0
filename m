Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A043E716F;
	Mon, 17 Aug 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976737; cv=none; b=MZ5KHK69PazJLXSNO0/3wyVKGhEXzBhj1e7TNU7+wzoxkM5kS2mdA4wXHEmOzrb3BlTijbULPxxg/jGqNO2i2IaSl+8KZVuotqls035oehOHHcBY/nVTaKuBfhrB88V820mwRAJyDGc7/kdtglGcFr+t7Jgk0n+sD1WxCqvfhF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976737; c=relaxed/simple;
	bh=7FWj2SSmRooNZS/IZXylAQiLMi5/RgY+g6fyQNJeo5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK2wjnxAY2pepipgxhKLOOvn3OmCLICkpnma6jiltFBOWcHQlt7xmBLbOP+rgZcI97pPXEYAHeKTx5BuZvEgShjYGRix15j1rai4FGYLbMSlJK33W+LvqPwiBgNBh56IURjdpAifuvQjU8dv8VHfqHbaw46xjhRRpCDs6UpG7OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbP0/U49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbP0/U49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F701F000E9;
	Mon, 17 Aug 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976736;
	bh=Eaggv/4mR+6utHvF1n/XsgM8U6nYCgL3h2xhFHATuUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KbP0/U49DNYctMmoUTEMtGfVuZrjDmM2A97Gr7ujNQ5ktMi0PoFT7ptRCcaS4SOJ7
	 My20cQgvNqHmRkIIJlvc2Q9i0T/bWDKRT8IHUv7JPbGyauYugbEbgLQE96z+IP0Ghj
	 mCYP2rqa7iEC1G/aTj/f2kLqieyIh2t5crKnLHFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/456] wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read
Date: Mon, 17 Aug 2026 15:27:56 +0200
Message-ID: <20260817132543.480834804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 4cde55b2feff9504d1f993ab80e84e7ccb62791c ]

When the firmware sends a command response with a length mismatch,
carl9170_cmd_callback() logs the mismatch and calls carl9170_restart()
but then falls through to memcpy(ar->readbuf, buffer + 4, len - 4).
Since len comes from the firmware and can exceed ar->readlen, this
copies more data than the readbuf was allocated for.

Bound the memcpy to min(len - 4, ar->readlen) so that the response
is still completed -- avoiding repeated restarts from queued garbage --
while preventing an overread past the response buffer.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-2-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 908c4c8b7f8256..9a25c2a540b95f 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -150,7 +150,8 @@ static void carl9170_cmd_callback(struct ar9170 *ar, u32 len, void *buffer)
 	spin_lock(&ar->cmd_lock);
 	if (ar->readbuf) {
 		if (len >= 4)
-			memcpy(ar->readbuf, buffer + 4, len - 4);
+			memcpy(ar->readbuf, buffer + 4,
+			       min_t(u32, len - 4, ar->readlen));
 
 		ar->readbuf = NULL;
 	}
-- 
2.53.0



