Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1108423C368;
	Tue, 21 Jul 2026 20:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665240; cv=none; b=TBEFtyUH/rewAl+8gFKKpSrLJSLQV3WDIyoECYsix73qQPFpC+Z8ojTjMIdr1o7V1pprkhM4LcVeGpQ8CzsNOeqIvXzgAEOeotsY+KyDpFwy1hGzrw2TFnRMG+U9vMsnYyE84pO218WD5bxmWWtvyJzPl6I2TiVmqyRDpqJ6mSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665240; c=relaxed/simple;
	bh=zfwX9bnM4sA3xepMHVzGvdx4/mVZtA5ZJSEZnORiGcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dvu7NqqrcudMszgF8x6HQX/8GWXjd6W11oG0skJST3rfXDEtzmraq/FNg6vPOgxfI0tAU2xoNN//745/e/7TFniqXRRbk5pqRd0jMWI7V0gRaVo+kvHVoSfvl6gEKgzOYyVJfRIcru+qdB0FMUbDtIvN0jDK+4gUNKp7AQADKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOk/Tyfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOk/Tyfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EC81F000E9;
	Tue, 21 Jul 2026 20:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665239;
	bh=RBAKhLzXqknq0OhRC4hvCQYTC6bXRnPDlM96UanPNRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOk/TyfvJDes8ohsYO4eH+dk6Dp5DxG3HNP1kWAx3aVaJtgdr5mT/VtK4gNhr7jHQ
	 dLYn7ajMio0wNit/0f5kqjHiWoYtYBKXfiTcdVZergh9sHh2oLI87ox+V6Le4QDMXw
	 YY4oVR4oYc7nCUzPvXNNxyW8kqLtC748KmqVA94I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0185/1266] ksmbd: require source read access for duplicate extents
Date: Tue, 21 Jul 2026 17:10:22 +0200
Message-ID: <20260721152445.947426688@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit cedff600f1642aa982178503552f0d007bc829c8 upstream.

FSCTL_DUPLICATE_EXTENTS_TO_FILE passes the source file directly to
vfs_clone_file_range() or vfs_copy_file_range() without checking the SMB
access mask granted to the source handle. A handle opened with attribute
access can consequently be used to copy file contents into an
attacker-readable destination.

Require FILE_READ_DATA on the source handle before either VFS operation,
matching other ksmbd data-copy paths.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8500,6 +8500,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			ret = -EACCES;
 			goto dup_ext_out;
 		}
+		if (!(fp_in->daccess & FILE_READ_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
 
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);


