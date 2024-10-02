Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487A11D07BD;
	Wed,  2 Oct 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878196; cv=none; b=UdfX+6qCcYyvTAZOLu0XXVftNyuZS8dPSzRjWzW1izNiPRL+wQxdu+uDL1BrywJFgEtNgJn9+ciC6uCTwuwY6ZzfkLl5Kba/walZvSAbNbwsGUBoJf38fQLtpvslzNQSoTz8IGAv+zMe3Auy0deR3RCL0dG9Bhzi8WrqiQmRgvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878196; c=relaxed/simple;
	bh=SR5QCr+DE3lQYwKDOpP1AkfSE1nkDJJ4dTYUFrErAN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djGsPmpIuWJ6g/U4w5yCc1zqNrfsC1SR4wqQOyuaGcOm57iGtW4/FaH2ocIKHHMumztOGLTxydoVfGzaNDmQ1fSgFDYz0yIEJWVYf+vYuZULoVjB/bSoqpZCVX+Z7qRlrMFzt7U71K9G7DlrwC8E1P8JJSRnw/EWjp/x2RK90Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT3FAP5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT3FAP5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D75C4CEC2;
	Wed,  2 Oct 2024 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878196;
	bh=SR5QCr+DE3lQYwKDOpP1AkfSE1nkDJJ4dTYUFrErAN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT3FAP5R/xXVk4uyVPyFRCsKMZGLY0PU9jasnUJfn1yZEF7tv5N3ppUq6RJPCPMoK
	 Urf3KBjCLOw/BLwIOxBB/YYWtLXd8UdCJyeIN3MHrybeWD6KFlqwqVgQLa0YxgXnqs
	 hPA2wo9i8P0ArAYtiTa8Nwvbv737XimQSfnjwuRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 331/634] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:57:11 +0200
Message-ID: <20241002125824.169309274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5142820b1b3d9..76c3f40443b2c 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -983,7 +983,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



