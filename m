Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AEC418A44;
	Thu, 30 Jul 2026 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423828; cv=none; b=C3pp+tNKoky4/hL3ZPRjhJdjAK1Yv8+Z4/HMt2WmBpf7YIaXCP/LLSlhdUU6yR3txmB9TnZ2+DIbABBLTmY6MWqe3wT7+ZDkDpEyCMWHSI9IJLzu5uh++3dB6AT853NWH/X4gDvRgkhded4hbJw3NCuc/OAGVW2ZlFCXEjQTypM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423828; c=relaxed/simple;
	bh=mYlkBGUMlQZTngyBDzpzkwvBbg6AVn2/cPQxF2YSqI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkTTwak7Z4CGbtkJqxoHbM+LVWeoZTak+ylYBd5KVrM6mm+ECNn1pt/agBcokFno9tGKijtl/GOSIM33Hmpoq6rZMUZ5ksfTeYQyRmJ37sg5/aBHyg4NvlT71lEj7W2/fToGoKMsthUo3TmGNw/Izh0iTRMx+YsmswrJF0+LoY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNLhi0Iy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNLhi0Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8451F000E9;
	Thu, 30 Jul 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423827;
	bh=3Gr+4IN+SKM42HqpenS0tI4x+zVok/xiCjFGpGFim1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNLhi0Iy4y8IJ/vDrekj9UZosFqn4UI9aDkqShLML19SzU27yWcs7L9Rm94obpbr6
	 +iugPKkYCTR+9Rv9SobCPgcb66knXpT+nLMA16QOo7Ot/0NwJgJQc0aQqK0+GqPwfl
	 7v2pJxsHeVZ9hECFfnfdRPW5v6uXGS0gC+g3HP0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/675] wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read
Date: Thu, 30 Jul 2026 16:08:31 +0200
Message-ID: <20260730141448.985183083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6833430130f4ca..f6855efc05c0f1 100644
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



