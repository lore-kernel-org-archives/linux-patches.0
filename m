Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E611DED64;
	Mon,  2 Jun 2025 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873737; cv=none; b=DxETMraMAmBpFBYhlUCw6hXMsuLH9mWb2dfxIS4koCmuvPw1ZsiaxZsEKUAQnGOhonFWB5FEzZR+26u5PyQn/2IQrEE6hhlS6zPG/6h91rdB8T4uIMVK+wizp7Q5t6ZKwKt9Ve1Seqy/ccYHdxkhiiBrHERHFn4g6MR39hdFfuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873737; c=relaxed/simple;
	bh=WRav0Otm4mZsAfomFaqt91KVTOWyXKnD5j2l9n2QQIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWxHdUZWhRWUBU4muVgIofNr4v4twI0rYzPBzmfZCmNqDBJNMY3hxvHikdSZJB+eWjxvQ5FUmP8uJYqRzAQazsomMXwnsGVnemZ+ekNUFrQHM/Fqz5iD0BiWJi5cBfyGYgjsPyEBDbnwtMY0nkBnBAZ5499dPH8RXCiPN6UxBHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYRJAhc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYRJAhc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BADC4CEEB;
	Mon,  2 Jun 2025 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873737;
	bh=WRav0Otm4mZsAfomFaqt91KVTOWyXKnD5j2l9n2QQIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYRJAhc568kRv5u3kiJs/IamiGHrpuVnnb93YmUc6k+xCNTzGpLMxbRXoP1TuU3Yc
	 AC8tFOaN278vALm1a/S1UD3Ys6LVzWQMZIoZlGs6yrFbbKNdHPLJLTGROIsIV+NjDO
	 yY3cF8nXrqmNa5O+cCTZeMOroYcHcRharXoWWfQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/444] net: pktgen: fix access outside of user given buffer in pktgen_thread_write()
Date: Mon,  2 Jun 2025 15:44:31 +0200
Message-ID: <20250602134349.308190226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1decd6300f34c..6afea369ca213 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1877,8 +1877,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	i = len;
 
 	/* Read variable name */
-
-	len = strn_len(&user_buffer[i], sizeof(name) - 1);
+	max = min(sizeof(name) - 1, count - i);
+	len = strn_len(&user_buffer[i], max);
 	if (len < 0)
 		return len;
 
@@ -1908,7 +1908,8 @@ static ssize_t pktgen_thread_write(struct file *file,
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



