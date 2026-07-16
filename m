Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869142D752;
	Thu, 16 Jul 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212006; cv=none; b=A3Kwzx/X0bsEhZYLAr0SK+iTCokGld3ZrvrZzeuhlZFDh4I83yAS2u9syDuK6lRGewVhEW46Oy97cPu+CdkLQUwVIQrPto3YYeAubDAwIjnFfZylUPfeyi4qSCT5M4+a8ClRld/XSJnNw2iQxrAT5AZxUih0BEw45Bj0T0sVrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212006; c=relaxed/simple;
	bh=+lhvoitCRwaTr2iwkdqmkHN0rw6YT1m4vFZIeH6k8jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNYjxMgBtthoMs6bXelqx1XJWaLrF2OqkFq84INShV2dp3iib8aB9gPpDvGr7anYIp8Z/DXi3heljESoB5zVHlAbHJ2RokFrtKDpuPfFSgz0FU5IXBEpVKii+TK/rZX/toOL+vsO1gaAsk70laz8Uo8Wj7nAxtWyyRR4QP7+yJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHXsoM6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHXsoM6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF40D1F00A3E;
	Thu, 16 Jul 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212005;
	bh=CGV816c7qbceuumOx0ZVaP2MHbPxsq5PibGaaUls6u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHXsoM6c2Ulf032t0cAstqaU9flwu2SZPgDXv+YuXQ55GLUJ9rqOy19aJ98dHAN6R
	 yyOs5Irl0dxg5G7u1MOIpVtbKI5bp2bXwAEw2thYLgh0emlWCt5Y2ukgFNsPFK3K6f
	 gleY88ORux7VfMmF1RDM52/5pZVCiCQrj9akNeRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 163/349] ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Thu, 16 Jul 2026 15:31:37 +0200
Message-ID: <20260716133037.029411629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -8492,6 +8492,17 @@ int smb2_ioctl(struct ksmbd_work *work)
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


