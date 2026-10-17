Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A663B5319;
	Sat, 17 Oct 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256230; cv=none; b=KhC+1AQj3jWbmTYqa9TlVf6eNU8I8BwUqFVjy6fL1yGB8VozWKXVkLpT3rGbsL+GsCPccahXTxm25a7dm9I9aFc7qUV6BR8x3UD/XONxJ1Bp6jJp3Xb3tbG0XT53K+++ELM5YE+1+mCc98Zs3mMAbgmqBhQ5X92xv98+IbwHfd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256230; c=relaxed/simple;
	bh=CMFonaZUF16XixbTiCz1Zr/3sWASKo5x0D7qarKvKkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYuHZ2I2jQboUr06B9qIeRWS3Argy7Ta93nj1kbs5KR8jEiUmCP4fPXAZc0pNjI9iYMAQqSurjcjG+331zF0zvX+rS5RA4MRmBEwCNF0jicGuwIz04zaf6Bj//xF7NSka77cprodviej+QSsn/leokWJ81C5InQPzBuiPfzpOxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vg2+I7g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vg2+I7g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0291F000C4;
	Sat, 17 Oct 2026 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256228;
	bh=y8d4X9zlD/SRrwGuHrpRGKk0kSlLkyaeAWZA9NS++TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vg2+I7g4f22xpSZb+syZ8M/6VmDQUzCaNvfOzarW5gULiS8ACY3rg0HhpN7asNIQb
	 tM+v9+VTcp1sABJIVaUQT5U2wUrLNJCGunfrmkA9pyT6dBWzm397/NItNs1pgta+IV
	 FQntIfTx2/yEW8rqOu6Yvpmz327J0e6ro7Yo35Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0160/1674] smb: client: close handle after create-context parsing failure
Date: Sat, 17 Oct 2026 17:40:32 +0200
Message-ID: <20261017160435.266550042@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 566820af017e81497fb5e9d3ad6e7ffe2828bc8b ]

SMB2_open() accounts a successful CREATE response as a remote open before
parsing its create contexts.  If smb2_parse_contexts() rejects malformed
context data, SMB2_open() returns without closing the handle, leaving the
server-side handle open and num_remote_opens elevated.

Close the handle after a post-CREATE context parsing failure so the error
path releases the remote resource and balances the open count.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b831cd1dd3290..6bdcc942d36b3 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3313,6 +3313,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access);
-- 
2.53.0



