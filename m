Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51F1D07AC;
	Wed,  2 Oct 2024 14:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878204; cv=none; b=F8R1D35gYrPvLHuHuLRdvjSC9dXUS/udaj+0Q3lSRn/l8iGT/J8cywnte812aP3wFgC+oNuG8eBaF+WAoPsV1atxnom3zI/UwTMjqvwLINkMK+t+sf8sb7H7qfymvT38a70Kj6CS/XWcufhvTcXIe0mFKO9PQehb+7ycibycBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878204; c=relaxed/simple;
	bh=MI1syw0sSS8hqIu0IgOpk5HFWFpvCnNYg0FhTRK9hT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvZwyAS/FndgXkj7SpdRlLmTtajAfMZKcqMdtgrXf36+JGwjjUwWV5Y2PwasRrtry9S+C1Gy027NJmJfUJOkJWYkn3WutIUIItzG6KbDfgRN0h/C6W7cCLtgp2kYXgaJH/h+GSBb+xMVnEKMvaVtbBvGQ5ofB9FPepFAH7QPPNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdvb/y6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdvb/y6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E51CC4CEC2;
	Wed,  2 Oct 2024 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878204;
	bh=MI1syw0sSS8hqIu0IgOpk5HFWFpvCnNYg0FhTRK9hT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdvb/y6U3V56GKwxEsqAHaXEhNhBQPhc0axZ0ggQdK7+4gBd7PMK9Cug47HzgOgbi
	 WuBFkTWYHU8Ua6/mURltHtndayky3BWRcUGMsztS76Ir8DrYISArSKeZOQaD5vxYMU
	 2J2F4AelOwcpMIgw/f/fVWZo7z3V2YryXcCcmzkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 332/634] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:57:12 +0200
Message-ID: <20241002125824.208974880@linuxfoundation.org>
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

[ Upstream commit 46d7ebfe6a75a454a5fa28604f0ef1491f9d8d14 ]

Ensure index in rtl2830_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Fixes: df70ddad81b4 ("[media] rtl2830: implement PID filter")
Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2830.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 30d10fe4b33e3..320aa2bf99d42 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -609,7 +609,7 @@ static int rtl2830_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid, int on
 		index, pid, onoff);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



