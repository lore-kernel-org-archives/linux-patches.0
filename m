Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10C3AEF36;
	Sat, 17 Oct 2026 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256214; cv=none; b=rAFSAUVj3l83OL7Rvi7FtyyxYKErLepYMIpm/nGeV4sx3+I/OUh6Ed6EsmbehGJa1ollvFQsaOyj6UGHQbdYeKTQoZu6+Aonng585xLCy5565wg1PAevv7PdQTgY4WfsVZG3Xrl7N3ErkV/UdD+dQG7jR7+q7zHZApxazXXvaVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256214; c=relaxed/simple;
	bh=RbuwOoJ+/D3uvHKHcSvwxXtkJdjGuyE5pYL233pnD8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5a40UtiBh/jVQ0jcf19gVyO7e3wS5w5ORgjQb3n7lP5WqD6GfvGjLtPuG9HEln7CXCqZA/yIg1x1eMwP2hZmRRIf2EE+3pbFSNbVAC/Ss4jY9N6+WRps0yzYfY/liLrLEjIXTfnPqqZy6z1xQKIf6o1x9r55K09ZZF0MVgfm5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQAtbBJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQAtbBJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E74E1F000C4;
	Sat, 17 Oct 2026 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256213;
	bh=PdYQFoq1RsFZLBLJ7tlZvS7KufuL1nAFTJXUHY+oimo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQAtbBJ0LhumIwsiRXb6/1xbwoA2IrFk8y7JfIyFFs+1SEks+404F0B/tO/0Q5YZV
	 zGLccl5STOr1+1tIY+vTaB2nTZxuA6h6+iEpi4qebpxDTH254X/M3UUshGTE8TnOsg
	 yF2tBWJ5gtKjEvIDVRY8OKDwHJUwWO/TW1ESNvEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0120/1674] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Sat, 17 Oct 2026 17:39:52 +0200
Message-ID: <20261017160434.232461081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 5f0306e731e2f46e91419eae57eee3a241c055e0 ]

In cifs_query_reparse_point(), the start >= end check before casting to
struct reparse_data_buffer * only ensures the start pointer is within the
response. It fails to verify that there is enough space remaining for the
fixed 8-byte header of the structure.

If a server provides a DataOffset that leaves less than 8 bytes remaining,
the check passes, but subsequent reads of ReparseTag and ReparseDataLength
will occur out-of-bounds.

Fix this by ensuring the remaining space is at least the size of the
reparse_data_buffer structure before accessing its fields.

Fixes: 56e84c64fc25 ("cifs: Fix validation of SMB1 query reparse point response")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Adjusted context to retain existing `rc = -EIO` error handling instead of upstream `smb_EIO2()`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e7df15011ae33..3ba39c375077f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2793,7 +2793,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = -EIO;
 		goto error;
 	}
-- 
2.53.0



