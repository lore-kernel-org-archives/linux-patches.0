Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0C02EC54A;
	Mon, 17 Aug 2026 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979151; cv=none; b=qOln+UOqLxNmf+BxTaTDlyL5HPT+X7p+aYk/H+nYAIUIdBuH7rKPzJCs8/bpTmsy2wTfl+wjsbN3x/sZghQzHlhOYMUPIdaG9eLJzSPuKAfDuQm5STsYau6MOUdouAE+tu93Fw65OfzHYXML40PIZacR5YUcLHolOFHL9uGIm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979151; c=relaxed/simple;
	bh=u/NGs6Wgw7YOHN/y+AApbhoTOuIR1xC+Vb7G1lpx/NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNPdnvq/aWPwCAxsxbyERlytwQwYsu/ec69r6ZDcrHuD9TIGvTrvs6sk+2BRTh21wiYnJUFmfni6s6k8Jm1FLw61EXdMT/cDpHQQtNSFkf/z51jzIo8K6ARMUZlKRyQNoKMbBQZgU0lCHvhrMKyxEJ+qp3C9PdVybbNZYl/SH0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9Dd7zEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9Dd7zEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8162A1F000E9;
	Mon, 17 Aug 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979150;
	bh=ru1XOy1v+uCBQQdM5q/b/Y8nSgQpkLjdtKn2MPaWbQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9Dd7zErduT1KI2YupSWpoldIU9iVKilZD0NZZmg0rrWZbegv+8QZHvWcTTdzmDaw
	 JPLeJpfZ+JvQypYJQh6JXUI/atwDW0VBE76lvxH0napV1R+1XVROXaC3TdLrG4IQFT
	 P+/EKy4ppKIpkj24F/E8ZRWyhlwcUU/cK1TtAhMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/609] wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read
Date: Mon, 17 Aug 2026 15:26:45 +0200
Message-ID: <20260817132547.388839203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



