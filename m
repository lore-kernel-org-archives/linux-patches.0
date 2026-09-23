Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAA25304DD;
	Wed, 23 Sep 2026 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174068; cv=none; b=UfO3fehy+ouqrNvASJrwKnrjJS7L2U26Jq9P9Wv0dvTQIfcQOk9DPZNpof1Um2yjZ1/3gbNAbf4HCHqWEK1zVPE30zb80qgNiYh+17J/FuMFbr++Es102FueQcj4AowGkMmsYIkMXGLcBEQ5+JICHj5cZQk0mvCXCglpc+TRb1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174068; c=relaxed/simple;
	bh=RHXQ3G+j0UC0dkf3Qk64bmtZlmwhOLnvTeR0d03VsZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJsnDlwL/Abjh+md8zL4pGAQrj+dAYd4KcvaoEbzQwTliOpM3eK7e2MSegrN3Bl5CXMW3wyTa4OHcWYsZVZTwLvD+gZp/Zgne11ZrtG+v7CxVBxXCapwQPtuI+DqZQsHY18oPqPu8wqyKDQoMnGxg4GgyuuMfzEQJ3q2hrogz6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTuTj5V/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTuTj5V/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4501F00893;
	Wed, 23 Sep 2026 14:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174067;
	bh=0Nx47ccmi7R1VcCzjIpIvoe+hHmgdw5ylipsMXmcCGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTuTj5V/xNpakAm0+L9zn9tAUxCalQSWNoXL8yPpQdy11VgnCicalIeLebrIN+HNc
	 75LE0oeY7GQVMftffLBbsn621ieNRMDheK/12YW2phqxqNAr5Po9KelWfoPZbGlOFk
	 VVle1c47/iI0ukAwAfMmXKhOLjYgBXIqPcqOFleM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 424/438] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Wed, 23 Sep 2026 16:07:25 +0200
Message-ID: <20260923140655.908970030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 5f0306e731e2f46e91419eae57eee3a241c055e0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3080,7 +3080,7 @@ int cifs_query_reparse_point(const unsig
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = smb_EIO2(smb_eio_trace_qreparse_data_area,
 			      (unsigned long)start - (unsigned long)io_rsp,
 			      (unsigned long)end - (unsigned long)io_rsp);


