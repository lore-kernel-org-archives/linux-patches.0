Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC56422E3C;
	Thu, 16 Jul 2026 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212045; cv=none; b=hSDtsAKFBpykBsTnBVRH8YKSQ5HhSD8tVFMZtdNCLMYAUJGi7tL+OjIrPFOImHRi5/QtnCL3aveKpl7QyzYr5jGTH/3d1gz2qAGgcJEcJ5rMTfEH9HYhhLaThd5wKOPFR6xoHMDohVjnhD6CbssR/8wUqNOL7uqLqc4R1B+amEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212045; c=relaxed/simple;
	bh=mWOWQLjuHucWUqYMZ9sBrC0T37/IGuGepFdZO02bsCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPC1aQPz3fpal7VG38Io/cRsWB1EXanrP6WN3kQqD2QG2wNAecNl4M2F8dWa17LfRM7VNNWPCv7+/Kq8Ew8Tr0jILUmz4mE3XPG3IAc0cdskAFpiR+gWscLF7Dvc+twmSaD6pEJs6O9uIxHdAs69eihwlaygHDmdo0fGJ4SGvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7EmNzBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7EmNzBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FC11F000E9;
	Thu, 16 Jul 2026 14:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212044;
	bh=GjS5rbkXQGN8fjLMgHBTfIOjmAK532XBqNoZ9iMNLTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7EmNzBqNF9rfFpPc610oHbEJIiTlGqYpHPAKP5knP1B5gfTmY0puxG/gvMQ2W8T2
	 xw1kEfFnzB/DixoXeix0ScKVY2G5pBJ/QTeri7eNB+xkrJbWRSz08+oFoqcMPOiixi
	 PQYXOpOLd1jt+lErniTTD4SzJvFAL1SMUMaFSyUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 177/349] smb: client: fix change notify replay double-free
Date: Thu, 16 Jul 2026 15:31:51 +0200
Message-ID: <20260716133037.338400144@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 145f820dcbb2cced374f2532f8a61a44dce4a615 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_notify_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4030,6 +4030,8 @@ SMB2_change_notify(const unsigned int xi
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


