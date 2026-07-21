Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6A4394783;
	Tue, 21 Jul 2026 20:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665163; cv=none; b=Mt/SZeo0Ps4fgMMALM3YkLritwCugMnHP1bbn6jzFKGSAVYNZ/XqZeKVY/bMXsORsbW06X/eMAVJ0okLYOUTrh6jsmpwf1fVbO0PlgOryEv7CF/dYKYbn57NANsE3U0UNnaWiC4I7p5IfIUGzCZVRHhHiUlhAmXY+ixB/BtiGI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665163; c=relaxed/simple;
	bh=DJhCl24CWQxzeRuG+sNTBySUM588NfOtJjp3tZ2Yt2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI2NNbCILmX/tncc760FvdiLut1gt8L9sdekX2bd7Usgo8dT/wALGLJFA9zU7C6+57RqJlBdNa3hjE5zsAeH26Y3kLro3GreDrg333x2Ieczg0hVsl8ivNtUO9NsyEYwyegKUjKFduZ7zcPTILMqxsP4UFrYsYDDboQ2WnnoZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr6WmRwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr6WmRwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AD71F000E9;
	Tue, 21 Jul 2026 20:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665161;
	bh=gZidgQEtejMLbRIo6365JLILaQgerSUw+4egDAozdF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr6WmRwbn7fYiM/re9ZvlfiNgRh6Ouv8jyGN3jYSdKUGXXmci/DocLTNjM/dq6mw0
	 aLUX0o0tskUB/NoWleprcE72Cb3tpxw0dAalP3X3BjR8+5jzu104LIzVOzy5JOPdUD
	 xrtPOH50oIkTiWe7p+lqNhBCEO7+diaHJCWeHp3s=
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
Subject: [PATCH 6.6 0200/1266] smb: client: harden POSIX SID length parsing
Date: Tue, 21 Jul 2026 17:10:37 +0200
Message-ID: <20260721152446.284208032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5130,7 +5130,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


