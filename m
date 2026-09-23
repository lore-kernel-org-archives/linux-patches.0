Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1844CAD7;
	Wed, 23 Sep 2026 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175359; cv=none; b=eHEMGL25n+i54RVtYuX9HJnazgtAuQDwg7MOiaTjsqUcE53j++/tvQm+2m9LzINYZLEAXhVDtARWvFMXXvl4rPIRylkNjdn8bfrjZHok9oHp/EvUz48UQ0WhSFYfQK+1RBn/7DsUo/XRkorkL6yBG0GCWW56h8GuDmB6XJ+zWpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175359; c=relaxed/simple;
	bh=U0THLm6IxjaO+8LwcLQ0gzrJF4PlbkIeMUryRqNLm74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvBdsDbVx0aGuV2uwttx17D5E4xC54vuwOcC2JSyAyUjnsV/wOQOu6xgmdn1RV3kQ4LmgebyRq28nZRLapSI5KVuHyx1lbwg1jrkmADv0RbXGC0vcur8uweSJU4V8N83R0iT91f8kzmVf5tJM4LvWN1UGPhsQAmAnxMJS8scn3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvc4/R0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvc4/R0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7131F000FF;
	Wed, 23 Sep 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175358;
	bh=44gr0ugpP3RStkwNtODTnAUCtMY2dq8+9bz47NcmkkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvc4/R0sYFOWbaXufho26+IHM0YNohyIwl47Y3xNHOopalb83DvTUXy8yK03hygAx
	 LmjbfdDmofRAFM9IL51JG3vamqWVdgDLUFN7GEAgKnobhQx+4NKY6CetUVpRRH1OUI
	 xZA8yyACA1uKppjX2UjhENVAZDMinueNAh2EWjt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/398] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Wed, 23 Sep 2026 16:07:45 +0200
Message-ID: <20260923140653.604804913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -3015,7 +3015,7 @@ int cifs_query_reparse_point(const unsig
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = -EIO;
 		goto error;
 	}


