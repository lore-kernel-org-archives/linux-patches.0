Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A107B3D8127;
	Thu, 16 Jul 2026 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210888; cv=none; b=gg8eTYVwcXEo+6loo0CJYto8myfIQHZkyAEli+LhIq33Qa5ppjj5jMefhLezcH+XYDCekRmV+XJsSfA+thMhQ1/unP/FnZXqOtha3qfrhhFjaKwg+NsXtqThf53pRFghubbSuPQvV7ZHdLhHlFQ+e/rq71E5oOhjXo/7gAhxfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210888; c=relaxed/simple;
	bh=9CSvr1oHsmZFhdTGa7cq58+doacF+n/qshKgiw50sSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4pDjWwib9NEmViiSDNE1jrQXjPUPsVG9W/ZuDWCzfmqizXxee9EqUSsVOdAgBtfcZgqflXz0AFnex1HIlQ27MMdA8zxc8MEdjwb07u3K75M6hrlRDr4WAtPGf522ySGK62FWHB5i6E3/6jAvZJWOv1pFEy880pSB+LgGZkwCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liZ1tqZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liZ1tqZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5DE1F000E9;
	Thu, 16 Jul 2026 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210886;
	bh=etbwXTXjh5BqlzB8su76mlObFsjO3BiJggDzsaVnrgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=liZ1tqZAgC+QcSMqjOz4uf68mGfmJQ7wGt22xZx675NPvqOovsUy68jXY8cBpVDUx
	 o8NBxtu2FK2MaA+94LNGMZsG62Cxv+fyIbQ21jxwHWP6f0yGoE6/iYV1gEUX0y92me
	 ow/DtUPLL04aPqkGAZP+1R0fi4DpYFa+9Rr7DXCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 217/480] ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Thu, 16 Jul 2026 15:29:24 +0200
Message-ID: <20260716133049.426874457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

commit 388e4139db27a9e3612c9d356b826f5b1ff6a9e3 upstream.

The FSCTL_DUPLICATE_EXTENTS_TO_FILE arm of smb2_ioctl() overwrites the
destination file's data via vfs_clone_file_range() with neither the
share-level KSMBD_TREE_CONN_FLAG_WRITABLE check nor a per-handle
fp->daccess check that the other write-bearing arms carry. A client can
overwrite destination data on a read-only share, or from a handle opened
with only FILE_WRITE_ATTRIBUTES (which still yields an FMODE_WRITE filp).
FILE_WRITE_ATTRIBUTES-only destination handle overwrote the file's data via
the clone. Add both checks, matching the FSCTL_SET_SPARSE permission fix;
require FILE_WRITE_DATA since this writes data.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8563,6 +8563,17 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto dup_ext_out;
 		}
 
+		if (!test_tree_conn_flag(work->tcon,
+					 KSMBD_TREE_CONN_FLAG_WRITABLE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
+
+		if (!(fp_out->daccess & FILE_WRITE_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
+
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);
 		length = le64_to_cpu(dup_ext->ByteCount);


