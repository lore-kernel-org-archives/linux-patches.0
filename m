Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E71D0434;
	Wed,  2 Oct 2024 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879911; cv=none; b=NoNpBc/Q4M+ytTW7X2yliGZ6ByGs5cwPcGuZ3ZJ0e0a7bvmua9jR1r/z6BTQGlP8QdPCxJgAKL6BwcW2LlclNHOiIuPHoOdgjobHy7QCJwLPGUK1uBa5RFR1Ohb7gf3yxVE8htGHWMJjT7Z5vVXT/EjzL7SQjoJJV1E7m/C7dvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879911; c=relaxed/simple;
	bh=JvIXgDaaD7uVEVQKKICDFOKdiIPo10LgkWVspCUp1GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZtaPNRw6jx0u+FvqGykxmZ4gBjMOcyfYz5KQ/kAF1W0BPTz23iKr8DC0VYUhBtrU9HP+R5Qfy4jfvC7qvUFo7k9uKXq5yK219tJ9q3J6+s+ubpxs+Gm0UEiG84zqmeQyU5zmpBEF0CntJCeV3o2guSO3ktZ0jucl2yEIk3n570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb3DSd75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb3DSd75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B886C4CEC5;
	Wed,  2 Oct 2024 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879911;
	bh=JvIXgDaaD7uVEVQKKICDFOKdiIPo10LgkWVspCUp1GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb3DSd75mEh/L/hZ2IBC7JeMFmTR61vtoRN5/1wKGkYUdS5WqxnbFBSlktS/u6Ubw
	 izamrh5252ingJsBmx0j6qjAnambHfj6HG/hSJkBVg22aBhti8Bo2dAoc8jsdLlPoa
	 KaTRgYsXp2crLasnGFFWg3YrJzomYAbR8vvLukOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/538] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:58:40 +0200
Message-ID: <20241002125803.347456365@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 601cf45c39358..e6a7877a98541 100644
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



