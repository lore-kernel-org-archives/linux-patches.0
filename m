Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149731DEFF5;
	Wed,  6 Nov 2024 12:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895039; cv=none; b=kAjs7vYzgP3t15N1JVjM5IU5ysONF8yFUMoTIghjA7u7f8pb6Dzb3NKyq2UnQZnLVIfVIqKBEu5lEEp2J9wo56wfvUDbwNaXjBc7xwzM7a+c64Ym+8Wiq7klNnqhkJVgM3RH4b2NfbgRDbGr3OwFbg+gpaoIpru7dy6530dwhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895039; c=relaxed/simple;
	bh=Y6x6EI/ZUEWMM4NYeR33pWBG0k4/eMQrjlTI6/RxI18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv9h8aN5N7+VLz0tcuRHoxLa0qrRIpiDxOW9mNyIRg1MIuCRgA0NeR+ZSqUAHvSwR1I+B/HzF9AfZ371At5/b6ra0LTOpErNiDzUNoSfzUbE7CK1T+Ep3ZWOru2y5Ok9V2MSoL2n1EMbBgnuZPn/+xmyzH4ujvBDy0qewwfYIfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9dGQrpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9dGQrpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEEEC4CECD;
	Wed,  6 Nov 2024 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895038;
	bh=Y6x6EI/ZUEWMM4NYeR33pWBG0k4/eMQrjlTI6/RxI18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9dGQrpETQ/2Awl2PEQneDlKXWZ5VDH1O8u+KI9asCueS5KE4Ll2vq3KH8wx7cZUh
	 EqnfUsTWIOWlvquml6MyBPe3lfmqRIGxSQbGCTNqJLy+WENP5xXxh8yIQ5ErZroIm/
	 hwt+EjHDgq3x2BIad6+9xx5jkDKNrm7cieEqCSWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/350] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Wed,  6 Nov 2024 13:00:11 +0100
Message-ID: <20241106120322.946444611@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Li <make24@iscas.ac.cn>

[ Upstream commit 8ae06f360cfaca2b88b98ca89144548b3186aab1 ]

Ensure index in rtl2832_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4b01e01a81b6 ("[media] rtl2832: implement PID filter")
[hverkuil: added fixes tag, rtl2830_pid_filter -> rtl2832_pid_filter in logmsg]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7cad4e985315a..608bd2a81633d 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -995,7 +995,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



