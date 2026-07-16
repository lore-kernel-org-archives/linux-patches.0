Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E473D9554;
	Thu, 16 Jul 2026 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209566; cv=none; b=AkNQLxmryhS+JnPoSH+IlyUKk+Oo4AkkJyEe9kEk/ldgPhAQx6uM3B9yC2DQ0wDb7/hhbGpmpKoE+U3Kr81DWp2QWzdD01aHbzVY6T/4JuoZX6+COTr8QtnjJK3V6JsrI7dBvguEcfvk07d3pLGaNKDKfrmFwE1rKW9eOxqaK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209566; c=relaxed/simple;
	bh=X8VCJgegC4mEt6lUP5IvOjKRhnDsBlcbYdelZTFD5ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzOX7k7ioDphhSLfpk3bG3HOrlBzIS4SYnfgsYNgl6RHiA7w4tu0E4rTQdIXAmkXFzOo4PxgehZI6ydYSi3ZzIyD8eCDpMXDWB7UYV/PQajV4CZD8deil6Oco9TcNFfBMBuxpc+lVkXKEVeNSLCyii+9OZKOkvpIsEYbRrJmbl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eWpYQUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eWpYQUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C941F000E9;
	Thu, 16 Jul 2026 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209560;
	bh=ng+1Kp4y9egenuCdMgdkFEER+KqMnVytBhFhQ1vcGt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eWpYQUNZ0tHp+jZqiKgQP5S0Pl6VFRzk8OTAktbRxmNW5RbK/PHS8K0WyHqLeEhk
	 ITyu3IbiYJqbFUJ4GkaLXaM2vCMx3uM6rzflTNkdnu49EN2SIQUTXkS3uCma5TZ+Pu
	 Ab40oo2jAlMq1I0q6z4FZt9xrmGqQ5HaUHZx5hQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 232/518] smb: client: fix query_info() replay double-free
Date: Thu, 16 Jul 2026 15:28:20 +0200
Message-ID: <20260716133052.897718715@linuxfoundation.org>
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
@@ -3911,6 +3911,8 @@ query_info(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	allocated = false;
 	server = cifs_pick_channel(ses);


