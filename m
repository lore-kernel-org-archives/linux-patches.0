Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC5678F32;
	Tue, 27 May 2025 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365280; cv=none; b=pinG1YCOpILTO1ChECPPSqYZcv2TQ0y3avS71jY5AgKP788hZRk+i76omb5ZsLKUvZfeB2fsWR9SdRJ2MwFgpph1QqH8ZzC4BU0zBon8ftulc9+2SlHP+TcTr6NI40/dY7Xc4ZuS2+DR2QbFS5Y/QrWqyO9BV6D5QGQ+1J/Aos4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365280; c=relaxed/simple;
	bh=kQ6hLID7UHeglR4WLVU0S9TbQQ/tidJpKIiLcY3/2hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7FvHwSaohSgLApOdD2RJEZh8wUYBR+/On7HFXhG4qCcgorJ69fiLb/ggrc9v5nkdJY2eq6tzzwvGoIWv4z00ITYWK1ZkUSvTxHXlDbdaSXDoUn/kYSFM3D73YGmzOr1l7120uN5fPOBLGCyYT+12HVGBTiZ9eloZv/eIAaYGJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVFp1Q21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVFp1Q21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB5C4CEE9;
	Tue, 27 May 2025 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365279;
	bh=kQ6hLID7UHeglR4WLVU0S9TbQQ/tidJpKIiLcY3/2hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVFp1Q21BB4Ck8sl3r6/IfSydKoq43nvB6r2a/pJ9mcbWgTEMV4004wQ2dQc133AZ
	 daDV8KHf1e4DTVDZa60Ok2/2LSMkN+i6OM907oAyBKe8rJSbHKQ1xotOK5xX82lNFw
	 b+MoAlAqIMa/hIqta0IJUB7rE1RBCx9SLGw2AGG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/626] net: pktgen: fix access outside of user given buffer in pktgen_thread_write()
Date: Tue, 27 May 2025 18:23:38 +0200
Message-ID: <20250527162458.238070451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d87da56c56a0..762ede0278990 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1898,8 +1898,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	i = len;
 
 	/* Read variable name */
-
-	len = strn_len(&user_buffer[i], sizeof(name) - 1);
+	max = min(sizeof(name) - 1, count - i);
+	len = strn_len(&user_buffer[i], max);
 	if (len < 0)
 		return len;
 
@@ -1929,7 +1929,8 @@ static ssize_t pktgen_thread_write(struct file *file,
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



