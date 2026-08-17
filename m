Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A5E43711C;
	Mon, 17 Aug 2026 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974547; cv=none; b=TM2k4LjZz9nS/vPMM9R3waOvdjMz0D7Wk5V5knjQIuegufnkVuLn6NDGB5iCECZENBLGeapaCrMQDaZwysYiYxD1jb+uggx24gS/HElKXCg66B1oSbO82a/WN3F3P1hw6SDmBImyW4FLa1hJgbRE06tz+WPczxyVdW4p2HWzhH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974547; c=relaxed/simple;
	bh=JxNa0xzK7ND1B7FeL7dvlsEx6I1aMi/72I56J61r3IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu43OO7RJcNSRVwE8nJSroBCuMJYxhBHwWlJ6EAJqR8sOA/BWDQtiWqxHFMgAX0nocznFH71ZzKcdtvq35okkoAOXB0ifVzMWx+MptDNM/Md9Bj6rXqWeEHXFWrtbWGvCrn/UmtN4wBMuWO+GA32vY10AOHsmDmAtU/xCqV6+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyazw1aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyazw1aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8081F000E9;
	Mon, 17 Aug 2026 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974543;
	bh=7OEqTjoa9U9yY2160Ahj8KZz3wop+q7ym/EH0Blh+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyazw1aRsu7UPlFimfgt9WScBeduVpniym9aUH4KQQsOmlYV7+4v3+Cq/CCiODNeG
	 D/FSkwi7GVcdxWQLv1sA5dcRuR+hPD8eExKRfvjxa5Kt7NAU30gvP02OsJ9Dn9vuIh
	 HU7bBnKh6lDfMUBaMcLw/Z9cyg2U8mI85CTuQ3IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 241/271] smb: client: fix SMB1 TRANS2 multi-response truncation in SendReceive()
Date: Mon, 17 Aug 2026 15:32:46 +0200
Message-ID: <20260817132546.671100686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 26fa4d17c023dbe5427a92d3a7bd9ae1d1e58bc5 upstream.

When a TRANS2 response is split across multiple secondary packets,
coalesce_t2() assembles the payload into the large response buffer.
Two bugs cause SendReceive() to copy only a small fraction of the
assembled buffer into the caller's output buffer.

This manifests when listing a large directory on an SMB1 share
(observed against Windows XP); the first getdents returns only
partial results, and subsequent getdents returns EINVAL.

Bug 1: coalesce_t2() computes the coalesced size as:

  *pdu_len += total_in_src;

cifs_demultiplex_thread() resets *pdu_len to each secondary's own
pdu_length before calling coalesce_t2(), so this accumulates from
the wrong baseline on every secondary after the first.

Bug 2: after reassembly, cifs_demultiplex_thread() sets
mid->resp_buf_size to the final secondary's raw packet size.  This
value is later used as the memcpy length, so only a portion of the
coalesced response is copied.

Fix both by replacing the stale *pdu_len arithmetic with
smbCalcSize(), which reads the BCC field that coalesce_t2()
maintains correctly throughout reassembly.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1transport.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 53abb29fe71b..966f2cf83a51 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -260,9 +260,23 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 
 	if (out_buf) {
-		*pbytes_returned = resp_iov.iov_len;
-		if (resp_iov.iov_len)
-			memcpy(out_buf, resp_iov.iov_base, resp_iov.iov_len);
+		/* Use smbCalcSize() for both single- and multi-part T2 responses,
+		 * both here and in coalesce_t2().
+		 */
+		unsigned int copy_len;
+		if (WARN_ON_ONCE(!resp_iov.iov_base)) {
+			rc = -EIO;
+			goto out;
+		}
+		copy_len = smbCalcSize(resp_iov.iov_base);
+		if (copy_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+			cifs_dbg(VFS, "response size %u exceeds buffer\n",
+				 copy_len);
+			rc = -ENOBUFS;
+			goto out;
+		}
+		*pbytes_returned = copy_len;
+		memcpy(out_buf, resp_iov.iov_base, copy_len);
 	}
 
 out:
@@ -386,11 +400,13 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr, unsigned int *pdu_len)
 	}
 	put_bcc(byte_count, target_hdr);
 
-	byte_count = *pdu_len;
-	byte_count += total_in_src;
+	/* use smbCalcSize() rather than *pdu_len: the demux loop resets
+	 * *pdu_len to each secondary's pdu_length, making it unreliable.
+	 */
+	byte_count = smbCalcSize(target_hdr);
 	/* don't allow buffer to overflow */
 	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cifs_dbg(FYI, "coalesced BCC exceeds buffer size (%u)\n",
+		cifs_dbg(FYI, "coalesced size exceeds buffer size (%u)\n",
 			 byte_count);
 		return -ENOBUFS;
 	}
-- 
2.55.0



