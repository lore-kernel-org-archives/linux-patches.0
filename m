Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F13DB310;
	Fri,  4 Sep 2026 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498915; cv=none; b=Y+Do69j3RSDbYLMgiaFbCGITjRuFoG1ZlKViwjmrKyCIbYMmaM6ymwy+luz3FS6GdxYO99/mTAHyAWWwdjZpOg9OBu2JCxoCmI7JkECB4AKCQK19xz0uEdb8RDxJ9a+Hlb6atQL+z+N2HIJXbATIG/LMi1Qa21QxjaJrYCV7JwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498915; c=relaxed/simple;
	bh=sTKBK2o6y7E2ZXm2BewDgv/4/sJoDT5jlNDKJeZEBFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0/NF6oaUtlKRvqCbz0OQGv8qEQBFR5oVBxf9d2LYGylzc1EaP8x9KhR66BkdvGTWIaE5TfzzXjSc/xZBn9YRiZH0QZRpH+9kYRE7Z86CRBvxAIchKO4/GCwphT8T7pEtSoH1+jPB5oXtxkBR7oXN1Ghu3/N/EAJtL2JIOGuD84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC0M4Pbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC0M4Pbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5C1F00A3D;
	Fri,  4 Sep 2026 05:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498914;
	bh=+ro7g/glPfA+MQqtFrko4U07lU7ZBtNCCiwa/1Ow/yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC0M4Pbla74p3i8RIQ0sd/I1l75Fmbhy/pEuZhLBwhmoS5OioW8W4QflvdxRMyAFy
	 o6mkEhUTHMb7ZzgfRUZrc/a4Gp5Yn/aeFQJSnmRpRZUwrLb8/za0LUp8pB07Q4J9WV
	 O/Dr/gWQfDYIcNSWEGG/iuI5VJRu5TyF3hi/kmAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 233/713] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Fri,  4 Sep 2026 06:53:21 +0200
Message-ID: <20260904045809.045626982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1413,8 +1413,19 @@ static loff_t cifs_remap_file_range(stru
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
 


