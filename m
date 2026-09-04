Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB436B07C;
	Fri,  4 Sep 2026 06:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502192; cv=none; b=AdeXajx1cBEikqXj+SzMYpXLP+UGenYQpPdnqXp4u9NocyMbdllBFDtJabmXI6Keww9hCyU7QG3TQs+0V1JgZv0SCUUWF6xhZ3HE6JaSrqsUVbBYXRu6esitZ61rXWbVxD0Scl/bugjTY9aHqc1cYii+WB+iCv5wtp3JQAc7eGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502192; c=relaxed/simple;
	bh=iY6sb1CmcxlMYAo3WE1smXmAKWIJa0g5rZWWEPyFnvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEIQEKJf6gwV3OOL9oAGXNMFXC+FEKeW4wiVVgVYhBG/bnqoHhVYLaTaIOab5xs+AuhMFSh3ANXqfJ+2GvixdcpJzjchQN1aOClTiUdPVJWtdJ0qHTCXdYMM+qFtAI9UthEm08SBD1gtztYYzUdG0ik3Frw+cOPB1xvuJQ74EZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOJltVMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOJltVMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DB31F00ACF;
	Fri,  4 Sep 2026 06:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502191;
	bh=TIwXbXpK5cnBOBtoJ4YhSUsmitU8b9LPJtypV4mfiv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOJltVMhb3Jj71J1eeC99h8aKLp2OjDSro6oOs1P2HJfzuExUznrA2DOZWnJc2MAc
	 cRPE3IBFJmi2MuHeslT0t6p0e1w6W4owAv4mJOBCOAN2sfrzY7DITlhazVKPm5xN0M
	 CF6rPpIidWGhoo3qwgJYDNDD3bQEMEvDplRFxFDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 120/403] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Fri,  4 Sep 2026 06:58:43 +0200
Message-ID: <20260904045737.563813785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

commit 6c322f5cf7476ded7a9a20f7be72462065a03c68 upstream.

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1314,8 +1314,19 @@ static loff_t cifs_remap_file_range(stru
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 


