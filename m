Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616B434E4E;
	Tue, 21 Jul 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665139; cv=none; b=VS/yDMt6qw30sdkhoC3YE3wG5hxdObok7dusZTxJCX/ynEBocAyC4WAqrIqgIoTO3S9SdR8Q/F9wY0VzXz41GySFy0RcuKS81Q6Kesi8irlR/IgkodxRH3CbLXRyznv67IsfO92FGVrelvOrfcvE5s0qEngafQdy95fIQhkgBjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665139; c=relaxed/simple;
	bh=o2H0zAba670jh1SEUHkyxfT6M3UTzG/aUylWp1KSpps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGjPExwbMkvphNkMbeW5ArFEXnhi1e3LKhsIGMI6XzjEKIPTWlb/ZE9XZimHmk0NiK+81qHYEcXFToQ/auhcCG1CYoX14qGxXGMV4ZrKqUeQXv5z2CR3sNa33wbW+H6IJNh8Q5AAhcrCQicOW6nopK+Miip30r84x+o8X3y37jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfCyc9f+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfCyc9f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0CF1F000E9;
	Tue, 21 Jul 2026 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665138;
	bh=EU9zjm9oEXSGlbMQ04k/iHY8aT2WLQPGU1eVhJRlaiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfCyc9f+osmYrbAme9ar9EaVqZRI217BDztJYO4+ZMgvaF5oQJxY3/Z68OkiP9nMc
	 gr1LA1oMUzKU50Nt4Tm+NHXGNQqLD9TfhjxLLAJ8+rPPGo0B/Yjd0dkpV1Dd0hA9aY
	 WZ7q7NpOnymWbYhhO2/h/3eN7WB2IOTp4QaY5I4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0192/1266] smb: client: fix query_info() replay double-free
Date: Tue, 21 Jul 2026 17:10:29 +0200
Message-ID: <20260721152446.101636489@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 2a88561d66eb855813cf004a0abe648bbb17de5e upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_info_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

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
@@ -3833,6 +3833,8 @@ query_info(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	allocated = false;
 	server = cifs_pick_channel(ses);


