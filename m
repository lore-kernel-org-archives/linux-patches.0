Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B8D400E15;
	Thu, 16 Jul 2026 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209584; cv=none; b=g1NufzCCalcR/b4Zqq8l7TI9lt03TG5CPukALCskAHDlWgLTzv7tVMYAPxug8XFXLre5SIe9HMqme5asncqCK8+OzTwB8oT1dufILfzEtGmSNNjm4Y0tXcxCWjREXXK5DNWVIg9aKZd5O0bAcEtEygdXJRUne7s5uZoOexYRXow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209584; c=relaxed/simple;
	bh=/fmIfhXw8tQDyu/6pI5WjdUBQFlGi6zoRx2AK8r3ThU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsT4DgBziqAsyK/OSOcyvnO0kIQtUeg8bBMkUQ4vxBG6kfEXpzCsWUSkzgUF4xy7Vqss5jzPn9eJmNdsYMPDvarbvOMXyywqM7DTfjNJpIvciiy57zrcAKishPi5fxrXzCvWT/ZDg9ZsslllpPYYIztaipptXGqr7ibERHQEm7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2p9ftP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2p9ftP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059D41F00A3A;
	Thu, 16 Jul 2026 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209581;
	bh=lpIijx9aShDThGHhKCW34Y1+cp/xC8lMiX7/n3Ak060=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2p9ftP3BewlvvaLRcQ040LxR0cfEtg0oU9mcQLVWYJ9vKj+SqgUApBpOlTQz/0wv
	 EAtCjnmj0U8vrUzKTp0opseynmRr9MQ340ucf0n6f7XqoP0K0BMeLDsh49dF1MDKTN
	 vJf/DlAGbv55NpFtm+5oYZHyjIFZRDiy0gh15xqY=
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
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 240/518] smb: client: harden POSIX SID length parsing
Date: Thu, 16 Jul 2026 15:28:28 +0200
Message-ID: <20260716133053.072657168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5380,7 +5380,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


