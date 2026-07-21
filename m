Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7C35C682;
	Tue, 21 Jul 2026 22:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672858; cv=none; b=OUJpgb0m8Am9XO3beXV9JYCMzQq8RKf143ZKV84yhg9hkf5T5UdqAY4Que8cb+mLG21bQaGf7Pg/nQ9YVuZBpA3SlY0eZRwSENYTJJPaxEYpuXSvmH+mQD3KtXzq80HX5/z2UiMzeAB9oN/QLSmrWy1WW6R2LLD49cL7EUzN41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672858; c=relaxed/simple;
	bh=yLjSsTnsRB/RS5+ZFTlbYSb9atISxtYViAPpvgln2DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6uA5nLmSklMorDgfq0K7K9wn4EDU/2jScYjFb9He0lTxaNF1NhbnsENE/6ma7SW8b3sjOe2D4mX0ZdJlJFZPX4BM+gTCW4M7d2pLb6guigkRsdXqgwajPXkx47Me76GC6T/KBnyDoWgD7kG+4aEXTWItdn6uCfnuBh/mI5Kmpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRBZDgjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRBZDgjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834A31F000E9;
	Tue, 21 Jul 2026 22:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672857;
	bh=/s/WHUd+Kyp5dBe0cw4gW38L0egL8MIH4x05blRK3gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRBZDgjWZxZ8RVB0VvH9P3JJsjgoTd2DGdtD8PDb6tASvtnDczY4xuie+XvBsDpVX
	 R5jhI7WonJ5eWU0Hw1PmL9eVTq6CESnu+foVLRnzCZEgoKQTqexzULx0JFD5uZ7a/S
	 sG3dBv3yZ9lgX0Snc9eXGTld6DHMQyhFYC0It8nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 784/843] smb: client: harden POSIX SID length parsing
Date: Tue, 21 Jul 2026 17:26:59 +0200
Message-ID: <20260721152423.696618504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zihan Xi <xizh2024@lzu.edu.cn>

[ Upstream commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 ]

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4592,7 +4592,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


