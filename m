Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0D01C07CF;
	Tue, 15 Oct 2024 13:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997375; cv=none; b=j+QzKvytbzs61HAcAjg6tNkpEW9bbs7w7fquoX1AdDX5PXgtYbl8xo6YWynHECJ9fwhYV5rIvVN0TRbnZ/jm5RZY12KCr5j4tyWMXmR4GwvMKTXqjsl4bqMzqOhAUwagQM0LzCIZA09EzpYeABhzs9v8XElkYfkihQBGy7BjWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997375; c=relaxed/simple;
	bh=I8ZyfvrVYw+rWD+N94+FWX0nwsjhUlDpZqkcYsxO+zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rT2M4cOQJIIC942k0N+myQ1UfhRJeTWDbEuQ3YZcLpN56YfjZ8uYs844JCDb6k2D639V34AGkfKYP+x+/0vdRhL9krBphgYBWXm/J8wuhNPgSTKfzGsLZtantW3kyQR4LBNNdJ6YXqnbgUThWSLOcJ67oyuJlkGtwlEObYYt9DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRgp+zLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRgp+zLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7E8C4CEC6;
	Tue, 15 Oct 2024 13:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997374;
	bh=I8ZyfvrVYw+rWD+N94+FWX0nwsjhUlDpZqkcYsxO+zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRgp+zLFtmatFQwYQa1bLyd42DRbUSPGx9eh9DWKqKAc5Bdzka9keBgamhj+KkNxJ
	 MLhukJMZIZ1khjyiOnLQ16UX074i6lXF3svgEkEa6Kgq3JEf5jyEyzgal5cyk6cTBX
	 /Yig1cfjk6AZ1zAWJAsd1VS8ozyqpx3UL4adcHvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/518] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Tue, 15 Oct 2024 14:41:07 +0200
Message-ID: <20241015123923.289771987@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e5bffaaeed38a..1c3e572cad3fd 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -982,7 +982,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



