Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4349426D0B;
	Thu, 16 Jul 2026 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209634; cv=none; b=NOH72fMHxNcPX3HTaWpz+9LRjvS1ndJ3VO5qkL9Cla3PSRntLeJE4bM3v5u0nQcNJbYSHz/X8KGiWmCQ5y/04bEdCFZ1UvFN9R2TjdNMzikTfIIlmiuso2wwPh19upKCFvJ/ouGR7Epvcbnqhm66JstUFNdfIAC2toC4FUrMgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209634; c=relaxed/simple;
	bh=AiYHQn8yFVxNmchgNRzklcFAtoJ1UaHi/M0nGFqiLrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E39LtNk0/Rpot9GiWKUS8hsT89StTlNXe+THVQe03DJU8riR1QDBZ5hebfGO0W2DY4IOzrR8Y4ZefiXPIdOkBOklhtTB8+iqeB8ISgy0N/ByTm+VeDILR8DCGXGUIxsIiZDmz1isxY+m3vp69G1aOB2dObdjdBqDnWbrZgnLB4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExlRdhWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExlRdhWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A361F000E9;
	Thu, 16 Jul 2026 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209631;
	bh=OzhSw4a4q9jMSE5dpwmTWmlpVT8ElRkiBX2Sk8JPjCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExlRdhWO4FAFPg433WLeGQxH6sSK+1al44XN2K1j8JIx5JNDhFMM8+yIC6FeygJUJ
	 j4t9cydWx7KGGI5euhdysvVTdc+TdY7LQ/DZ/+dBHKEJk6GuZCMj09AGbpbmXBHlz+
	 uWgn0G+teiMoimvW4kn+Uf72CMJ9/Pmg/DHmZ+VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Y s65 <yu4ys@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 216/518] ksmbd: prevent path traversal bypass by restricting caseless retry
Date: Thu, 16 Jul 2026 15:28:04 +0200
Message-ID: <20260716133052.542389770@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 54bab9ba5a9f156ffa9324fcbe5a356fd0242f95 upstream.

ksmbd_vfs_path_lookup() enforces LOOKUP_BENEATH to restrict path
resolution within the share root. When a crafted path attempts to
escape the share boundary using parent-directory components ('..'),
vfs_path_parent_lookup() detects this and immediately fails,
returning -EXDEV.

However, a bug exists in __ksmbd_vfs_kern_path() under caseless mode.
The function fails to intercept the -EXDEV error and erroneously
falls through to the caseless retry logic, which is intended only
for genuinely missing files. During this retry process, the path
is reconstructed, leading to an unintended LOOKUP_BENEATH bypass
that allows write-capable users to create zero-length files or
directories outside the exported share.

Fix this by ensuring that the execution only proceeds to the caseless
lookup retry when the error is specifically -ENOENT. Any other errors,
such as -EXDEV from a path traversal attempt, must be returned immediately.

Cc: stable@vger.kernel.org
Reported-by: Y s65 <yu4ys@outlook.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1149,7 +1149,7 @@ int __ksmbd_vfs_kern_path(struct ksmbd_w
 
 retry:
 	err = ksmbd_vfs_path_lookup(share_conf, filepath, flags, path, for_remove);
-	if (!err || !caseless)
+	if (!err || err != -ENOENT || !caseless)
 		return err;
 
 	path_len = strlen(filepath);


