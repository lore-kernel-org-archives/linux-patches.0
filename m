Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB6729CE7;
	Wed,  2 Oct 2024 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876209; cv=none; b=ii4r3wWbnRuVVvfEiSYnLNZmsYOc8yoRFBf7Y69SUDYjl48vAEo6r7cp4whn8HAvlf9sBgdFLuq2rmOzE/65fDroSE7VDuqezmgjCGQQZTm1I0ZWs9AlYEEQ/6zfTrpieN5jrOQz1qEtHfVDZnC5K8I9pPe/lwux8oT6cvS2YQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876209; c=relaxed/simple;
	bh=+gmCE7EMznq8oAsz9E5BCLtaftbNxTRoczms/qcz2so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTg97kOztR8b6RBROPVjBA2pE4B/nGdSLQoZIjtpJUp4DnOeqDvdpfY/DM3W25a2YgXeBM2EeZdN9HXbNxueMGfgiFqnzRbBruUx+n9ym0l2uzO1xmwgu4qiMPWkMWQ2UFetuI36dM6VVy4rOurOEb5IQ9OEUycBNcRxGmyj/hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2QmghzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2QmghzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667FCC4CED2;
	Wed,  2 Oct 2024 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876208;
	bh=+gmCE7EMznq8oAsz9E5BCLtaftbNxTRoczms/qcz2so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2QmghzSXaOUzRTtujjVhz597aNXrHoAEsOeLMao4u4Cl5/x2g38VE0KpF6bhQuoc
	 9hDHy9v/9W0AQFOS2iEOltIsbhZVqpFSU2iGmve6A1cJWURJHSumzO5moYmTee7V0W
	 gfZqBYWDFkX+DgXE03dqIHZB0OQee8SrX8C2f6Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 366/695] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:56:04 +0200
Message-ID: <20241002125837.056828425@linuxfoundation.org>
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



