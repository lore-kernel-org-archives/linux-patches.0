Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC936998F;
	Fri, 17 Oct 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715176; cv=none; b=NmkFwjmVsM8dGSak/ZQU9xm9qBOutrGedA7C4Ibq8rq95OWpS+xH5qdMLSYB9eXZan3gTdhFHo/lFVRr8jVkswLBMMPEMMMdZXmA4rp4OCvfvco2m4pkCLQaVq5fzGTI/ZEQvfxTfLkZp8iDesCN2YZ3Yc/7Hpk5adTJ3PBiczg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715176; c=relaxed/simple;
	bh=pED2M9IhZvvWx22CbBYd8PBOJPWyp8hOaRNqu10GjFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiBr37fipWEttnP+QIvkCYYyX9Q9F7NpUWfQZnyLyu0nNiZJooVGi8uVIXGohxpeNBJxOHSoUydyJELHgGT4etmVh/wr2CjPOtEFJYzv5CmjzfXj2AQ3tmN4N/piKAoPgmtaTUCOsK2w44SDGM3c1bIjfT6TgiKZcHlC/iRPAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmJs73Gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmJs73Gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D151C113D0;
	Fri, 17 Oct 2025 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715176;
	bh=pED2M9IhZvvWx22CbBYd8PBOJPWyp8hOaRNqu10GjFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmJs73GbjzLdEnWWtncH8f8ikf6BEfEcll47fbo5K/Afn69RtPmxyRwWKFl0es65h
	 z3XZznDzdZx9xYx7EjixZetJo/xActjR+HCkzz2F4vMZ99YtmpYiIsl5cRXiSmvf69
	 LdBAk2YWMmGho5g5gyOEmLOrfNcIupvKYmUNFnvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	David Howells <dhowells@redhat.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/371] cifs: Fix copy_to_iter return value check
Date: Fri, 17 Oct 2025 16:51:38 +0200
Message-ID: <20251017145206.384255466@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 68286673afc99..328fdeecae29a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4653,7 +4653,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int pad_len;
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	int length;
+	size_t copied;
 	bool use_rdma_mr = false;
 
 	if (shdr->Command != SMB2_READ) {
@@ -4766,10 +4766,10 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
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



