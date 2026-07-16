Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E426431E6D;
	Thu, 16 Jul 2026 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212040; cv=none; b=DmuALieDViRFPXWrPtYtlzilQCEBpMINrpaviBQaUXJXe3lRhV+N6AVjI3WLcbRIyfrOw0OECvAZco4+fGW+8tOyC0MvCJlcD1Z/92KvzLnQJbT6+SDbi5y1bTKgDFeGN1+enlE8SGw8jB1v/scyEfQ20yB4oAxGWxXDx+o2UHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212040; c=relaxed/simple;
	bh=my30vk1FkTMcCBqwTRXKc6U4gPBpYeadDQSmKVsDVLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyzkXVtwe9A1h5KYxte14H0Lb7PFFi/YwcApLi61HLK/yEZ+Gbh5Tn6MDhIa8yFdbA1PcBnRhNWkdlJu7UqxOMDjcIdy7Wt7hi6A4qpS2BGZzJMGDEmHkkSJhE+dr/k59zTOUE5Q7m8aOccSzmcvLdZV6AoHhyYMCMY9GfMo7NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSbMV9hF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSbMV9hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F7F1F000E9;
	Thu, 16 Jul 2026 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212039;
	bh=QwS6p7heSgkHrNgAnJXK7fs/EUjGf1XvGaANh2BC2q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSbMV9hF+uMwvqqwWDox5BpgfzcjT0eRd8wniWI6w9MjlxjoLyKNyjc5aChbLVZZq
	 pW1IwUwgfdkq1j1lTOTsEI2SIerzzD0VwdHn4rMLfvLuv15zJE9guOu0D94tYxauhf
	 vT+ekg7aJ2aCwpRaoUYy0g7/f6NeuWCEFblr8LTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 175/349] smb: client: fix query_info() replay double-free
Date: Thu, 16 Jul 2026 15:31:49 +0200
Message-ID: <20260716133037.293627817@linuxfoundation.org>
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
@@ -3839,6 +3839,8 @@ query_info(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	allocated = false;
 	server = cifs_pick_channel(ses);


