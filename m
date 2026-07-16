Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88BC414A2C;
	Thu, 16 Jul 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209576; cv=none; b=dtipkAZkUbGJ46PW3n7s1a1Z+4BzZos5alxgX7xpFpM8pv2whqDksymiudlSCfx37qDOOlVC1iJseC1E5jVby3F3Js7KfftyEeF09nXh9Tc5jsIh5UAelc/6CaBuf/U1RCyL995NzGPGchzdY7tk/yrja5y0i+RKcfXGGpjEzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209576; c=relaxed/simple;
	bh=16GS6k2naVqKJ0yUTzMUkxtSNidjim4wR85gafs+hMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opNpKinqVr/fa3zk8Twfza70dlhX1w2bzxpwtSN5yLV/y/R6ZTC/wch7PJRV7eMn8Xhmzf+V5JPoZJJMTQrIlAXOdJaHHVl844fpUba4xnE7yngLBLSxr5YCtKu7cS5O16iGn2k/bTChAkwsRIc6lyHUYwpqC2WorF2YW/957jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irTg6FKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irTg6FKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F971F000E9;
	Thu, 16 Jul 2026 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209568;
	bh=Sh2yh4U+kzvdW+dM4K7JKTUJaSStVjSK6LVJzlNofVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irTg6FKC0LCSV+bCrb894zXRHM1U6r3dU683mRJXqu8czW5lpGeBijccO0SM7NB0L
	 p6iMbywebb3tlgnsJvnZ586qrXYY0BC3GZLSCyF+IudTt9PpZtaYJgMInuCWJcwcP+
	 HDrzqvIWVzHrUhcZiytuCrxFw9hw00iXOdxsjF1k=
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
Subject: [PATCH 7.1 235/518] smb: client: fix double-free in SMB2_flush() replay
Date: Thu, 16 Jul 2026 15:28:23 +0200
Message-ID: <20260716133052.961977872@linuxfoundation.org>
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
@@ -4431,6 +4431,8 @@ SMB2_flush(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


