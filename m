Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA555C316;
	Wed, 30 Sep 2026 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790399; cv=none; b=nF7YdO1XIppHH9SzG7wKkpOzvtm/hYn0Y7f8dZwwoA7UklMAm9awg39infPhlaWgglxlySPBLyE8+1ybuJXPcBE0PRMXGv7G1MRHm9RMv2eDXAzYbkKvEp9Uzm6XlupdwbQUUm6zgti5FA1xqb8bkiBF5NbrYIhz5PlHUlYEkQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790399; c=relaxed/simple;
	bh=U99E7WunZum9qvrYo7EnX59SZrpIlOq99b+0J6Nk0z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+OF3KXkBap5un6Ki5nCVrcdjg+TE2heyA3ivXTtFudtMiBzC+cTMvg4cil68m5OdPJcUIuocqwBJnz4ejBpWjnVWOo/HtDzURybw0xf8/C+UhCfsY+x/iJJWDKdHTLicUxh1Qq6lBg03y4QTVBikfN6mj74IV8ZWFpPV7+CdQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNMwb20A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNMwb20A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE991F008A3;
	Wed, 30 Sep 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790397;
	bh=ZsblEVdKctG4oFqPAWXrOwNAsjg26xOZ5JsieyxDTM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNMwb20ASG87IUgFb/F1M9g5Rf9Nn52H40qrnjgcLCL5rCE3uHp8Bm4O1yx/XAZlj
	 HwTAykSN+2zrME7taJ3HPX5wjwbfGjwNiZzQ3744/4LiJ4keaCafo6fOte+okLSFpF
	 40pGBbePKcRNJ9nXOrfEmpZ1KdKk95nDPk43OvNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 814/877] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Wed, 30 Sep 2026 17:28:45 +0200
Message-ID: <20260930152432.287989630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2829,7 +2829,7 @@ int cifs_query_reparse_point(const unsig
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = -EIO;
 		goto error;
 	}


