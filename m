Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEDC42A172;
	Thu, 16 Jul 2026 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212048; cv=none; b=qRf3IPCrxX8MAhRxkIAzcurNOSwFe1ReCHJ9uQ0g0Vw7ZEpTm/KZ1scxN1oEjbgjQZHqFwdLhALKx9M3jIUJdf71PyTRUpsq9ZYiEhoEIfjf00sCFB23MQT/ZpgbrrAWemwAKsbsep1PNkznpY5LPGzjfLInNCaB4nWY+u1+Qv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212048; c=relaxed/simple;
	bh=NF3/6KXTEF5k1hYKj/fgqNL8IEaBwlMCjMkCM91RQag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONwg7Mn9A6SFDITLVlNy/CgWm10Ukx5rR20i5YSKFPAvxfBpiZqJeD5ipDypGLpp83LQOE1qng3M5818K7vSCxOkqNPeVuVvfHjYJbLS89QMLCtUwhjpfvAjSzJT2NUuex2kxE8l0xObyqodsHwxywT6NT9f2X49w9Ge6m6gTxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jug67WPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jug67WPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB73C1F000E9;
	Thu, 16 Jul 2026 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212047;
	bh=5zBVlKu0AFwa6flap2h4HZIX5+F4d1L7lFgVOtIs8NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jug67WPT/IWbOjHa8NF5/mYpqYbfCC8FS7V69nXYJRpiN/jdCoNxm356ADNtD2Wy0
	 GorhsmJmonHUQa9iLaEq6Z0kOSayR65VgvXDWaeWZH+lsHfKffnj3sBR4hDiwOwcn7
	 6Stb5jApWdq73HHJ8/s5d3Za51E2+LQRk7y5YZ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 178/349] smb: client: fix double-free in SMB2_flush() replay
Date: Thu, 16 Jul 2026 15:31:52 +0200
Message-ID: <20260716133037.360175637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Zhang <zzhan461@ucr.edu>

commit 4be31c943a3a27a5a0251dbb8f5cb89059ec3d5a upstream.

SMB2_flush() keeps its response buffer bookkeeping across replay
attempts. If a replayable flush response is received and the retry then
fails before cifs_send_recv() stores a replacement response, flush_exit
will free the stale response pointer a second time.

Reinitialize resp_buftype and rsp_iov at the top of the replay loop so
cleanup only acts on response state produced by the current attempt.
This fixes a double-free without changing replay handling for successful
requests.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4356,6 +4356,8 @@ SMB2_flush(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


