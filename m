Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A22DA76C;
	Tue, 21 Jul 2026 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665136; cv=none; b=ZXW8IbkSsorG3rY47p6N1wdLE3I7LVZ2MGPTR3rnF1nBSfEIOZW2gkRQ8Jp9jxO1Y24RWPBQFjgEeicXU4ZHmASk91/jJ4c73aB2GXaPW9rN3BUBgrrXcjZL65npmCZYFNa+1BHiibk4XHQ5684NpNn0JjtphQSOAdePQej+U1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665136; c=relaxed/simple;
	bh=vOw+eKKswnNOJe5ryG3cOmMvhSSEnCs1K6m5nL5Ct7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwpgUMdon8Zk6gyDdYtSRiQko1rhNpxLiZEH2lN5mTO4rfV1g8Z2xUSJN6SSYOANm4DyJIPgNgFUEC/RF4Y9ZAxTZcifxoycKVYcHFVJvBmLPiAVjVfxuSgScWX++tThkrLUF2M4dLtx9liKF/ttIa+tLJDNv4GwLXShT7jWBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rneKzwXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rneKzwXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEAA1F000E9;
	Tue, 21 Jul 2026 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665135;
	bh=mtm2jKCEhrtBZvCUeCubot6KdhabX1AtrqnUcA+21fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rneKzwXgeuU3GqimvC5Dh1ypcmjrJRRBON+NehpsSjK3PcCaHXhLUGzsKEm//k/iB
	 qiCkZFRaF5ScM0R1CL1pEl+d6ybYr7vwhf/WvFO1IgqvCpQ7KPL7kDNL6AK3IeYFNg
	 +USksgRGwYgtBBzAoHV18dQkrn5TOyWT9mVg9do4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0191/1266] smb: client: fix query directory replay double-free
Date: Tue, 21 Jul 2026 17:10:28 +0200
Message-ID: <20260721152446.078357932@linuxfoundation.org>
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

commit 9647492b5e41954be59d5157eddbcd4cdc1656f7 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_directory_init() fails before the next send,
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
@@ -5814,6 +5814,8 @@ SMB311_posix_qfs_info(const unsigned int
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


