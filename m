Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E33FF1BC;
	Thu, 16 Jul 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210901; cv=none; b=IlltCzWNxUPte5g/qwnagOhnD6aKU0tkujOMxejl4hMfPomPNrcRfLBxQr1uPLkHUsnZhf6e0StHXwLntHI7i98SE03AVsgkQ0C65kO4aPAm73gHEIQYxN0nqLe6d8JJqqIwLiqShB8TrcWr4x71888UqCkow9V4j+MP35jK8jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210901; c=relaxed/simple;
	bh=Vci/Ov/zJy4SeulftmWm1ZjjhjPBdulizX5M4YV5jc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suf1DLVdWERt4qcVM6vv3bhUXTDsibzH1SztjvmueIBGPD4YvM7u2lgDNc9Kp4Vl1TwxaHGOYeicPPNbUVlNYCBVCuJ7+FtLfcNeDcGX88vsQN+EEEZnR0woXgGyAmp+I1Xt84Dpfi6WoM7vnwpqO8tTnnp721Rz+K3/lCAW0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsNAvgEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsNAvgEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ACF1F00A3E;
	Thu, 16 Jul 2026 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210896;
	bh=jluDtZxgT9IhUXzum7yvwXqDXHd8ADF02Sf18PaQWtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsNAvgEPBRNZnCdBA88DD+EllUs960jtFyFJZwq9IMz2krh8Yz4RWuqxs5RNHZm+C
	 wqPZ60dnSNiqpAlCYSVpJOWcUEEKh9IWPt7v4Yhp67huKRnMOEv2KwLQq3H2o5sPyY
	 JswYVFYFiffwNuq0PKU7PgTCIKSPItSKP9D+yZhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 221/480] ksmbd: require source read access for duplicate extents
Date: Thu, 16 Jul 2026 15:29:28 +0200
Message-ID: <20260716133049.516428546@linuxfoundation.org>
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
@@ -8581,6 +8581,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			ret = -EACCES;
 			goto dup_ext_out;
 		}
+		if (!(fp_in->daccess & FILE_READ_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
 
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);


