Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFB5436342;
	Tue, 21 Jul 2026 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665157; cv=none; b=RJtEYfESrZFYnEH60InKC6jDokclLkoIxg924efY9xBUXYrJPBeebrQcOvyO0sNuZO69jO5x9n7xC0/x+u849t9Tw+8Red3nu3uhPBCjx6SCQqmNlCqgdSss1cr8htR6DGaF+HqNyYZSz5S8KcZ+NP0Bm4CDjX4/Z4GxyBro+Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665157; c=relaxed/simple;
	bh=vNO/vVimKN500dsnGMhRdwKnwd/9B+N+NHXdLQSoSs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9u3P+l+zFTvvfVc6XzNaGAXq3bpzQuashG2HCbevgDX6O05pM2C5wN8M3o01B8oZZ2oUixh24fX2vvEh218jro9rBQe8MFyjMKtxEFaifHEn5TX5b3JWaI4Zm6of8UsnyNOr4PQXFWZUsesc3H0WU0hHz6voTRDRBb+MZ2dnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeNAtJxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeNAtJxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09161F000E9;
	Tue, 21 Jul 2026 20:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665156;
	bh=3J5+T7XxJ/zvRYRK0x/hWrsl9RsX3njFK9ijkGSxX5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeNAtJxHxnKTPJolrkj9e3rHs4GoLDdVqfzrmS7UiZfQTfZNE23NolqDsiFzz7olg
	 M+NHBDzXHNJki8y9tJjbIq0adbojpYvUA4KgYPZBh/wRoPV2FmbE9v+M3uMh9R/O95
	 5n0OJ8d92X1OC4ncPChMQEt9m3JAYXgqFjyvTEEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0181/1266] ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Tue, 21 Jul 2026 17:10:18 +0200
Message-ID: <20260721152445.856368043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -8482,6 +8482,17 @@ int smb2_ioctl(struct ksmbd_work *work)
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


