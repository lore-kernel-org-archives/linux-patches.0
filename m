Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6542902F;
	Thu, 16 Jul 2026 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212018; cv=none; b=DWWGrlctRDoyoncHeLKCy6DWuBQ8sl3rs/Yi5sMWPqglK7kp4CeiyRbMTsN8yX3XZB5RvWHDDBn08H0SbydltRL62xBex/aDFv2tnG8txrA/ujGlqRO0s864EmZDTuV9/VfWzDstTIk651QhFOW7oJZi0IkDtXf+aXbUVGTBi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212018; c=relaxed/simple;
	bh=fVcBG2fz5BgDdpM4dgOnCvLLvxSpM9lcNCP+WUoLQh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTtU3Di5XDad9Ua85gpnra4TQBw/X+GSFbxzOqGIbUbWYojTrMKD33nVs/kNQTnwKZQyYYskL8VKQNMvWBf10XaCNEcQPmFxAe8RuYAaVLGgaMrboNQXE1kojNgPP+TBKY8TYpwR+0ecMVYXgQ/yx6f0ukEthKMFYQTdaYx5Gus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOI3XB6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOI3XB6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7364D1F01561;
	Thu, 16 Jul 2026 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212015;
	bh=dkalC8uoz0g02AnRNr0FONJejKB/zWaTm+0z5MSPBEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOI3XB6lMOQ0VcKuiqh13FaPO1RgrmzHz8utf/2/DDWlbbiomAkjyhdvtTzctol7i
	 GSS6WOnxV8hiRU4mAFNdYw8ebJMw1SIyDsknfKsvjlArSQdYQfFVL7rVtjiHGAI21e
	 dQ/8Rxcv/EZl8sc+l4DysuNHhsmtW9XC6kTgORMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 167/349] ksmbd: require source read access for duplicate extents
Date: Thu, 16 Jul 2026 15:31:41 +0200
Message-ID: <20260716133037.119774802@linuxfoundation.org>
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
@@ -8510,6 +8510,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			ret = -EACCES;
 			goto dup_ext_out;
 		}
+		if (!(fp_in->daccess & FILE_READ_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
 
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);


