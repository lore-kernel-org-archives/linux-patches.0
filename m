Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D043F4CF;
	Tue, 21 Jul 2026 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668349; cv=none; b=GsKZFPGkxQ+X0zt5v9gG0re9g6ohwnM1vruLk9KfaoYakcQFFE/cLNLUsFBpfdkTQ3eUP1SOuWyon7zMVvhVfliBOAMPCIc7WIdV8ODfNmLWVh9WEf5yUwTl2kqOLFfEco78Fk+bcFueiGgzwVQbQUOF54K5+3z3/xthDaewJmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668349; c=relaxed/simple;
	bh=o6AHj4/mNJDHI03BinCpKjxsuqhJ7KLIXsMJbicLjdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJveuHYb63LYC7XKlrq9+lV8MZ0zuLMGg9MkhkzZhXZGn2gm20Wqev/d0apbhZxPzTYSluldZ03DrSLyLPp1p+k7me2x3DLbAXsc8lVMwMaKhZZQYLN8/jfSJ6n2yaC1fhE78zQj4zV9w1qDLWDnhKDspQHenF00a0+WhVWHOfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvGkm6lL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvGkm6lL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E371F000E9;
	Tue, 21 Jul 2026 21:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668346;
	bh=hff62jA9EaxeuH1RT8IMVba5hK5QFDl3+WE6ROOlsgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvGkm6lLnZS6PYS5YGF1pzvtw/wlNbAaz8JsUQ813ZKe3IFP5gylXhKOkwTtmB3L8
	 p/gCwFVAI9qWpmDsgjIt5tFzRJGY++TiS8ohyqqd1v6JStcgOfVsaW6h5kc9qChFyO
	 u6I7lIqtmO6w36Dy0ewM3XAxRaXFDdy2qW8BLMVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0139/1067] ksmbd: require source read access for duplicate extents
Date: Tue, 21 Jul 2026 17:12:20 +0200
Message-ID: <20260721152427.703769498@linuxfoundation.org>
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
@@ -8051,6 +8051,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			ret = -EACCES;
 			goto dup_ext_out;
 		}
+		if (!(fp_in->daccess & FILE_READ_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
 
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);


