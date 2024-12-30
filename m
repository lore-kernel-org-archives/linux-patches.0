Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B99715E8B;
	Mon, 30 Dec 2024 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574050; cv=none; b=LyKpLQKZQOgE4m8F7gcpqbgFYywJX14MzVDQEil8HucmNa4M3IBTviJpmcOWveMdi2dz5IDfHICiZBIbY8WHl2u54IRpRwc7xPqz098sjc2yC+F7+CzuusvMPPOKmKp48jtBci5Ogbw64+z4D5ivHAjz9XXF/sqvuhLMjaIsp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574050; c=relaxed/simple;
	bh=kw6uYQt2Z1RNA4iut1h2i1vX82n7VDLjb39roBUNCek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6WbytPNMq4wt7xNt5m1K0nhm+m2EldqP0+pRNeLyr9qRywRgKx/6ku796XMgPMCdq4/z6mTpPHDAVhGA9C37tFi5Qetxxe0aWFiXcYNT6/PeyxVtUZwR8SmXwYQIosU3MpLEJEreKVQr64SNb/xiShmuoVyQb9nnoYYqmwV86E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4gOZkSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4gOZkSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06571C4CED0;
	Mon, 30 Dec 2024 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574050;
	bh=kw6uYQt2Z1RNA4iut1h2i1vX82n7VDLjb39roBUNCek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4gOZkSkiCtoDcOSpILAJKZNMQyno+0bwVDDdTLoY+1NcsYu6SzB7J9w4tj1IeVt8
	 xQGMVf1p6O5+Iq99m0s9Xvd2KS0vqfkst5umdFQmM+znzTY340X65yUMu+J7NCkVsm
	 3ggyMqtmK84Jcb7yQcgzrh3vgcygERoNjU17HPHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/114] smb: fix bytes written value in /proc/fs/cifs/Stats
Date: Mon, 30 Dec 2024 16:42:06 +0100
Message-ID: <20241230154218.419760882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bharath SM <bharathsm.hsk@gmail.com>

[ Upstream commit 92941c7f2c9529fac1b2670482d0ced3b46eac70 ]

With recent netfs apis changes, the bytes written
value was not getting updated in /proc/fs/cifs/Stats.
Fix this by updating tcon->bytes in write operations.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d1bd69cbfe09..4750505465ae 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4855,6 +4855,8 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		if (written > wdata->subreq.len)
 			written &= 0xFFFF;
 
+		cifs_stats_bytes_written(tcon, written);
+
 		if (written < wdata->subreq.len)
 			wdata->result = -ENOSPC;
 		else
@@ -5171,6 +5173,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		cifs_dbg(VFS, "Send error in write = %d\n", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
+		cifs_stats_bytes_written(io_parms->tcon, *nbytes);
 		trace_smb3_write_done(0, 0, xid,
 				      req->PersistentFileId,
 				      io_parms->tcon->tid,
-- 
2.39.5



