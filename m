Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB682DC79B;
	Thu, 16 Jul 2026 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209575; cv=none; b=Gk1UDggX+kyTUItp4vM9f4fv+6YaaaJBbdggRAWyCKQH90uadt15DymsX/wytC3bkxTpMDguSvf9JGsMHehjq6/J0pRePQ4nAqg/iuFBqrJw1cjhz/QYyL7fLhgvRhl0FFEh0wag2jE9uvk/K6DcMAg/s1xZcZCnpwgabH56luA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209575; c=relaxed/simple;
	bh=rAcS9X5WWjyRNW0VTJhgmf4UmT/ecERCKAh27L19oIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUD92V6ePPQVfiJl5K0PrpfBg522EvaHlb+IezoMWL6hoqo0XUkoT/e/qPjHE+aqeFrQ6JiTqYffFGjJcE6OFPQTnGSo/P7GfRrtgnFf6r8VLmtb6fcYVVVQAA3fRwHRnMjym1wXgtaRrVFDgGxqrjiq0K2kIRLkUls1ma4r5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0pFXjWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0pFXjWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752DC1F00A3A;
	Thu, 16 Jul 2026 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209571;
	bh=3GmA6vh9G+TtGzTb22lcPfEBawICutxXuCBEzFORMng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0pFXjWp70jkOhEiGPtqYE5mzZ/ulq9YnXpl8M5X2JvnWZ6guBg2NuFG0bGN5Gvab
	 StRsj6xzruwostLy/imCQc5/k+QZKFcjHJTcbM3d+D8fo5HsLwIQftpEmks3W9ipFA
	 cPERC6aKnnksPU8rgPE4mhRJb1FT7QDl3qRKxs9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 236/518] smb: client: fix double-free in SMB2_open() replay
Date: Thu, 16 Jul 2026 15:28:24 +0200
Message-ID: <20260716133052.985182228@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit b55e182f2324bc6a604c21a47aa6c448f719a532 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_open_init() fails before the next send, cleanup
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
@@ -3280,6 +3280,8 @@ SMB2_open(const unsigned int xid, struct
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	oparms->replay = !!(retries);


