Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AC7244687;
	Wed, 23 Sep 2026 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175301; cv=none; b=TWRCthHM0AGtWUR9u3nOGMKnKvqC3fewWwBtP4d3INyg+wqMbhqsoBwUR3CzMk+6zLuN27sKmXW0VLv53R+BH93H+5T25Vhb9SNq9aAs+cnZ7fa5NFW1Ooj7xDHAtqA1sxxcYUtvTZXk6YLasuOWeKixCCyZw96oniZx0/bMbH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175301; c=relaxed/simple;
	bh=2bZJ+kgxb24rACi4ONusYrL65bCawwBB0xoAKhkLKE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWbciMpDcJGjNqG8VuzXmhvOEGCgu6cGqfoROxHR0C+XkRq6BAub+SG2nFJcGq6Ysxz63Dp0qHuFdB9w/LVxRVRDxBowvHdJWnaEneePuGoqtXYq1zxebXrMZ6vSBsnVtAQUM3ABMraPbNbUI8G62YZTzR1U4fD3nu5aDo3CMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r40MQqDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r40MQqDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FA71F00893;
	Wed, 23 Sep 2026 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175299;
	bh=8d+vecwiqa9nZOZ33Z6pwzw1UkmLTw8mfwRop+kQfsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r40MQqDZQhSmSuqme0j/agFVHJM6mDMggIpFFIsABDkxRhAvne3XCEKExd94/9yaV
	 K20JZO2FvsHvG96hOv91luHj3R/PSF7z/yDYY2w1ydKKvq9pZhmPXONKft8wv3GZnc
	 FDTKERxjZCBKWktSaXlqnYyPG69e0IiddH252J9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 356/398] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Wed, 23 Sep 2026 16:07:10 +0200
Message-ID: <20260923140652.657264782@linuxfoundation.org>
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

commit b09d092eb24ad0110f16a9b7c1ed5d2a0c1733dc upstream.

In parse_posix_sids(), sidsbuf_end is calculated using the server-supplied
out_len without being validated against the actual length of the received
iov (iov_len).

If a server provides an inflated out_len, sidsbuf_end will point past the
end of the iov. This defeats the bounds guards in posix_info_sid_size(),
allowing out-of-bounds reads into adjacent kernel memory.

Fix this by rejecting responses where the calculated sidsbuf_end would
exceed the received iov boundaries or cause pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -70,6 +70,17 @@ static int parse_posix_sids(struct cifs_
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)


