Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2133B1465A1;
	Mon,  2 Jun 2025 14:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874818; cv=none; b=rHR5eogqrghBUA8MIKpqaOFmQ3G0eFMbduCPR+mrL886erBC14OC4HNYrcFVTP+4agKe9s0HEQOysBuxJGlxHxl4x21C0UpP48n2gXB3AfAJFdfH3pRGiMRpidmQ/8S8dGw7tCc7DkVX497ScR9+RVxbAWbeVjHdLZn5gXpuoYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874818; c=relaxed/simple;
	bh=4OgyoVQK2nh0EzeGK3945LhM2zcBYn5UVD5smgeRtFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6g7fYwXw4kTSA/ErTDq/Ta8e3+C3LpAGLfkFrD8ZSC1+W0jWdTa5ZucOIpofUKIfNvoc0M4EuNOt6J9MIrLt2BiZmrDWRrvpmbzdrtHDh8/0zyIQxXlynOGTTLuOoUQPCxlrRR1XLuGRRAYetvqvU0MhEIYvIUa87Q/tgvpxkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJA8Ao1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJA8Ao1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B6BC4CEEB;
	Mon,  2 Jun 2025 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874818;
	bh=4OgyoVQK2nh0EzeGK3945LhM2zcBYn5UVD5smgeRtFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJA8Ao1AmI947VQV1R6TTDsaNPSxYRIGQY+rlnpbtI9gFYbptu61TZNRNGWD56j73
	 iw8hZuar/IrY1frK5aolgmCXlaA+cOMF+1EAID/XsyxE7/szUcQjz8w7yT3qF0dqC3
	 xnz7KYwIF4vHesHBHDKqweg+MQj1TZXTGFbhAKMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/204] net: pktgen: fix access outside of user given buffer in pktgen_thread_write()
Date: Mon,  2 Jun 2025 15:47:51 +0200
Message-ID: <20250602134301.076364371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 425e64440ad0a2f03bdaf04be0ae53dededbaa77 ]

Honour the user given buffer size for the strn_len() calls (otherwise
strn_len() will access memory outside of the user given buffer).

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250219084527.20488-8-ps.report@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index e7cde4f097908..4fd66e6466d29 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1770,8 +1770,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	i = len;
 
 	/* Read variable name */
-
-	len = strn_len(&user_buffer[i], sizeof(name) - 1);
+	max = min(sizeof(name) - 1, count - i);
+	len = strn_len(&user_buffer[i], max);
 	if (len < 0)
 		return len;
 
@@ -1801,7 +1801,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	if (!strcmp(name, "add_device")) {
 		char f[32];
 		memset(f, 0, 32);
-		len = strn_len(&user_buffer[i], sizeof(f) - 1);
+		max = min(sizeof(f) - 1, count - i);
+		len = strn_len(&user_buffer[i], max);
 		if (len < 0) {
 			ret = len;
 			goto out;
-- 
2.39.5



