Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9432E319601;
	Thu, 16 Jul 2026 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210966; cv=none; b=bTClqKtKibcKZljHmTr/m5RrzedBqoGxM8q0r2aXN3BRk7C5dlzebmaztSgDS7oSNFmKDDBJukmP91GhpRupYlQUEdU9PeohrjMg4etLhbWZp7DGdMfFTTj8ym5RYeMjKR1Hit7P72SQAnjy6dZKnQBrDBIQPCVeEHjqY8pNhzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210966; c=relaxed/simple;
	bh=u/XJ028ucY3iqgNdOcxxwkc5u7CECveJaPOzjRPh5p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9iNFwXMOB6W2AGhymzwCXumob1RQl9T67yVPbLAC6iOiFq8/pTP+GQlG6B4GfFb9YwZMH/SCEcBKG0Mmp4hMZRGKR7cxAQEkxLJ7GmB5fRqOYqpiqfX4tFJ3tLIrLKnbgCsSug0ksshLtpKzqpoqTq4DNWJAZ0d25i77wJOZtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMwCJVjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMwCJVjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EC31F00A3A;
	Thu, 16 Jul 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210965;
	bh=h+ov59XGsm4bw9HBT+D5TIrVC1PW7DeI+3j7G8MHeng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMwCJVjVc3tc4lQLTiZ+8GM+O+njAX1yLcc/HnOwnl3GIHJ5YiNjCAd01bJIjtT7E
	 zG47l9hRT+cAYI/oWbeRgJiZ08CLxcqpqdtu9cgDf0G3oNp7f/BeZDjVIRctdR7pL5
	 HlvsO4imYVWmYemDQ3l8/ymC3nmJt0DQSb03isE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 231/480] smb: client: fix change notify replay double-free
Date: Thu, 16 Jul 2026 15:29:38 +0200
Message-ID: <20260716133049.815752454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4010,6 +4010,8 @@ SMB2_change_notify(const unsigned int xi
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


