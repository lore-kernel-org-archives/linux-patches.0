Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFF322A1EF;
	Mon,  2 Jun 2025 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876210; cv=none; b=RSiJ2xHK3H8vtOFTD5vW8GsifuULUDoaQxSFpJagCdXyfEbk9lpVqu63uIL3EbwMPP4uobBawOEN8yGAnMb7Q9zF9iF0ibFyo/nOgtxXm1N63AlFuUglHZwUgL5/JHeC7N0AyvIKa8rb3ajh6iG+KIhojF7YmpEzBML6pdImxeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876210; c=relaxed/simple;
	bh=rRAFeekxioYgxFCkRzdEGSrIG17WhQq9NbkujgEEsKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlCL/GJ2DbuAOzTHtkBJkB/E1Rc3oApw3m2hWZDMdXZcJn6oViBOvT79E+yItupq1SBrIhP1dseinqfXURlOYqvmIko7KWgL0PHECbLswX8WBlKdy/h861hvBpCvD8tLW4YfF0X9GPaJxAw9gZLq+7CvrzwMvm4t7aB7dDOUWdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCruVBXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCruVBXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A614C4CEEB;
	Mon,  2 Jun 2025 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876210;
	bh=rRAFeekxioYgxFCkRzdEGSrIG17WhQq9NbkujgEEsKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCruVBXXjDwfJGxLXZzWzCqk0InRDs9YAV0IlPvO8Ghkvw4mvsz54hcjcmMvAPeJu
	 x0ZzXnd2yEY7Mg9rh9DJ7Y3PpThLzhSoeP3J5MEPQYR+gejB4l4aRAWsLyGf60aFjJ
	 c1iSmEFOXrNvZcPhNKXl8loRQeU6/ii9owi1ayKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/207] net: pktgen: fix access outside of user given buffer in pktgen_thread_write()
Date: Mon,  2 Jun 2025 15:47:58 +0200
Message-ID: <20250602134302.886993319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 28417fe2a7a2a..2b7b1de70cf47 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1876,8 +1876,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	i = len;
 
 	/* Read variable name */
-
-	len = strn_len(&user_buffer[i], sizeof(name) - 1);
+	max = min(sizeof(name) - 1, count - i);
+	len = strn_len(&user_buffer[i], max);
 	if (len < 0)
 		return len;
 
@@ -1907,7 +1907,8 @@ static ssize_t pktgen_thread_write(struct file *file,
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



