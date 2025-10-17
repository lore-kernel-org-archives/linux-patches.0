Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDA82F12A5;
	Fri, 17 Oct 2025 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714241; cv=none; b=u49q2qiXeT3Q7CujhQgc3EUqI8gYjJONjfLmxA4cIopooEKRBb0qTv2Wr3XHCOILZff5Qqyq0bwERT3wVrTp7Bh6enMSUGXz6N8eGBc2ApxiA5UExsCpsIEE7kvuQV4F2r6Vf22WJjrkRaLiodnK9U9lgYo7xKH1Y2mgK89lnBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714241; c=relaxed/simple;
	bh=55wU2Ro8g08cl0ye4Z4UiQhubOXzexzAveiTgYnQtwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii4cT5HDu894IZ5kTMctEUsxyW58vrY34u03nQg+XRbm47ZoqewpzrV7WwgXuT/+3hEhX0V8HzuQEl3P7MNueiQ3Sw/j++CHLXkhc29FGWVzAAVQ0+81sbvjvThVQqZP4t1bUwqPJUDQWAt0b1p0x13wn8qGTMvmZuLfkCt4Y0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnTt9QCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnTt9QCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555B8C4CEE7;
	Fri, 17 Oct 2025 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714241;
	bh=55wU2Ro8g08cl0ye4Z4UiQhubOXzexzAveiTgYnQtwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnTt9QCwltMc+gwuYTBEUDSZBybY7/v3XQ8Yo7V0G8qtX39eERWtqbgLuE7S71oWe
	 Ik5LyAevuIXFX1L+/zfH3s173Tr1MbYiqCf7b2DuQ4VlJJzfznt4Pjq061TyujOB8T
	 3nmEsOZvrBPKe+sKMqOsLu4fsOeGofsAh0aH9Z7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	David Howells <dhowells@redhat.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/277] cifs: Fix copy_to_iter return value check
Date: Fri, 17 Oct 2025 16:51:24 +0200
Message-ID: <20251017145149.949513575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 0cc380d0e1d36b8f2703379890e90f896f68e9e8 ]

The return value of copy_to_iter() function will never be negative,
it is the number of bytes copied, or zero if nothing was copied.
Update the check to treat 0 as an error, and return -1 in that case.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Acked-by: Tom Talpey <tom@talpey.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c946c3a09245c..1b30035d02bc5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4657,7 +4657,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int pad_len;
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	int length;
+	size_t copied;
 	bool use_rdma_mr = false;
 
 	if (shdr->Command != SMB2_READ) {
@@ -4770,10 +4770,10 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */
 		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
-		length = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
-		if (length < 0)
-			return length;
-		rdata->got_bytes = data_len;
+		copied = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
+		if (copied == 0)
+			return -EIO;
+		rdata->got_bytes = copied;
 	} else {
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
-- 
2.51.0



