Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DA9426420;
	Thu, 16 Jul 2026 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209642; cv=none; b=uI3WjAbEckXJvuBeiYJRIw88jKbUSot4JI+0YYrWSBzhS0k50gEF76NMXSmBPoiugpx6ZNzLUQFAVkOck9yieOVnSyoUwCQXBsSD022kBb7+mv2jZNZm7Eig3QfeKoLxwDcg2E04gFYm9av3t1eFQWuzTOzn9Q5OE3MoMGnMB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209642; c=relaxed/simple;
	bh=7NTKuRWOgRYoy7UFz9JHLYffK009uoYdP8g4MD+OPtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0aZ9VJVv4pGeDophTU+Xw5JPrwGNtjFxtee0b3Pk6Y3Sv/V9TYL5VulboposhBm6zZoe7wy1r8nZPgnFWe7QbNmybiZ/d0YTaGZW2n+2ZtMpRgZyg6lPvAPrcsAlfQXeimQN/X4HcStsrAk2H+6Kvj7ge6OvN2tDIQs680u5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKxOikoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKxOikoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBF71F00A3A;
	Thu, 16 Jul 2026 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209633;
	bh=rNwJ1E4Z3B3Z3nepbB67Y5YRH16jbFnrRWa04/3zFpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKxOikoBjVgvwyL234P67AJ9prtlX/ytTsJ/nNl3dmdLP/TLzEjKJ6irpp+NZvGKj
	 CHvPjCfsMxXl9ePS4BnWKkb/PWp9jDb/aozkog9+3UY0XMr7B2tPPKx00gszJWdZl/
	 HMMFzaf3OwvXKOtCIcrtHzwwxyij9XP+JD7jOrjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 217/518] ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Thu, 16 Jul 2026 15:28:05 +0200
Message-ID: <20260716133052.563719845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -8562,6 +8562,17 @@ int smb2_ioctl(struct ksmbd_work *work)
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


