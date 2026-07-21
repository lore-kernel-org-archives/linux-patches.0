Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D3415F33;
	Tue, 21 Jul 2026 21:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668333; cv=none; b=IvieLpgA74larZ2HgpI2dnJu/TXuKILLAsaQSyzwZ7K3SUjq5Off5SZccSw7CsihyQ5n5GISdnL1BPl4n1TsM3vNG/bLuW6/AEiy0o1mr11ZD84DbeaqKb3yI6Nh487yKZkrmcWUfG833kLAUkcQtS3K2Rpg6uAsDx+6KlURxUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668333; c=relaxed/simple;
	bh=PzC4GT6i+tUQssdrXDQHGr+yClBAiQ5VsoGFZvk0MG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ode0bFWoVwjJSskCqvcOW64r9khqb/FHMzlPCR8VeeiZJZmdArtYute0BoeC7Mm5wVKKsmTGU4umhOJHua+984Oa3oXj8iPOGEBCWam0zhXajuBBmG1WHBUSJd6Ec9RDD+ZpjxZkEgC1c4m9R+qxtfq6wWMPKjcU5q0Mge+ABR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBVLvzeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBVLvzeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495711F000E9;
	Tue, 21 Jul 2026 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668332;
	bh=VBq3wsClhVTIyBsLz9IG8z7sWrhWjjKh4Op1+9EkFX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBVLvzeKQyxlE9AhS1xR9QAk3F/jVESnuH2GUgBrTtUa/x+r2SQRvzuy2aCtVdrV2
	 w4XuUvTALdahZChclXSy8oBiLa4AxmeciZRLEiZRu1mSKjeOTaPF7ixD23BiT+ko9c
	 M+mVvUUYwYVn9cCTkWTig3TsNI2C/Qh28zkDNCzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0135/1067] ksmbd: add permission checks for FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Tue, 21 Jul 2026 17:12:16 +0200
Message-ID: <20260721152427.614030342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8033,6 +8033,17 @@ int smb2_ioctl(struct ksmbd_work *work)
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


