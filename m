Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BCD50B437;
	Wed, 30 Sep 2026 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788884; cv=none; b=ObalXEcNvsiikPporAt4CjXVmZU+P3Wvi78vVJaqL8RgkXNlYcfXazL3OGC5/0PynjsuJ4W4KobV2/hexxQpy2tbVvuj78Nsf4LpjEGrVuCY32lJdHJr2pWlgc5viJvRKjedqhGhWhj31UVUV5ab/MEXJ+K+YiKvnQEu37/BdVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788884; c=relaxed/simple;
	bh=AFuNR2aLHRQP1GbcRf7kC1h6AYnYR2/85YQEsofiQOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD5slRlF6uvbSVESsUVGdoaWV2PqyAFwLK/6MunMD3/xROI/mHhNukD9iIKe3sGsd8Sio9Xt9I/LQ0KIyKFxtYc1Kvb2oAZGq3tWcDQAZrHi8vGjz6gf8v4qSlj/rvNprrprmoW2ocn1RHVKkUaYpi+bCa9A7JwbDsdLagpd06Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb2hjs7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb2hjs7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C1E1F00898;
	Wed, 30 Sep 2026 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788883;
	bh=tkh2Rj1iLCfGtYYRX1HsrWFnD2Q4GaHYM2U4aSigzaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sb2hjs7TzkUlC3gisWJLFVNF5JfZAJRZNDl45Z0raI9txcLBzH7weCMMqPwDSQWX5
	 +FhPzvXYrTG+ldfcHpwPm3Tf2aRxXwe5zvKKgKUSXb+FjCvPs3CsKcova+boKMouTe
	 1GTqCcWdcFwMS4EwE/XW3wxl1aWVK5PaZvo+v3/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 282/877] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Wed, 30 Sep 2026 17:19:53 +0200
Message-ID: <20260930152420.802163421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

commit 4775c3b7a597907e0b97556c7986fda238a377ae upstream.

If snapshot_array_size is smaller than GMT_TOKEN_SIZE,
smb3_enum_snapshots() sets ret_data_len to
sizeof(struct smb_snapshot_array) without verifying the actual length
of the server's reply.

Because SMB2_ioctl() places no lower bound on the server-supplied
OutputCount and allocates retbuf to exactly that length, a short reply
results in ret_data_len exceeding the size of retbuf. The subsequent
copy_to_user() then reads past the end of retbuf, leaking adjacent slab
memory to userspace.  The subsequent clamp check is ineffective as it
only reduces ret_data_len.

Fix this by rejecting replies shorter than
sizeof(struct smb_snapshot_array) with -EIO. Note that the bound is set
to the 12-byte struct size rather than the 16-byte
MIN_SNAPSHOT_ARRAY_SIZE defined in MS-SMB2 3.3.5.15.1, because 12 bytes
is exactly what copy_to_user() attempts to read.

Fixes: e02789a53d71 ("smb3: enumerating snapshots was leaving part of the data off end")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2422,8 +2422,14 @@ smb3_enum_snapshots(const unsigned int x
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by


