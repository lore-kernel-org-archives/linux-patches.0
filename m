Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D4218DF60;
	Wed,  2 Oct 2024 13:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876206; cv=none; b=RpxzV4yC09PqMVly2Aelk7YQuRT3GBMAshKyKFqCk+pzZvdCOsN8oaS8eIfW4gMM07MIH5/LupOwgSvhrEOXxCSe6ix82BTwL6XIuMC6u8FRAzkkA+8wZrNo9aQde54YslHE8lY3oa7YDtuMOkPLTq3O4bIZ3YA9N8lOJLUqp0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876206; c=relaxed/simple;
	bh=CpX3YC1/B3rMDkCQsLBOiGvAo4jB+PzYMi1gli6Tgdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXt65jmafk/E6bhuswYxhTi728b+YlsK20TeaWSdJn7H0DD5BnuJPjwKhPmNy2Qu9bcjR7sDhhZq4PW1yLSaz3Urd5i21+kvBXRXbS7h2YPMyUSwxzfctUDFTXO/e1yv/PCgnrA0YWbtp59G7h08Uq9mp+DoCgxfP1lvfyHWVag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A02OPMXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A02OPMXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B3C4CEC5;
	Wed,  2 Oct 2024 13:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876205;
	bh=CpX3YC1/B3rMDkCQsLBOiGvAo4jB+PzYMi1gli6Tgdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A02OPMXOnPKXq9U1XBfrjPvyvegQhC+sAjOWKkkibyRT18rpzsa285ncOHhwaBWQ5
	 rFtYV96a3nEkwbQM3RS358TqUEkMGvvtY6lqYG+ZKwWGgoK9xyZGFlKigFiDSUfPw0
	 yqCZbYPXRwDl8txbmaN0bE//VrCOUkSRuc1wKg+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 365/695] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:56:03 +0200
Message-ID: <20241002125837.017840125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



