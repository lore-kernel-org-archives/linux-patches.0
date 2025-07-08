Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3418A2DEA94;
	Tue,  8 Jul 2025 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993679; cv=none; b=rMPEuo3yfQR2ZtfUk0BrgEo8DfF1L4358pemOl+RDFeeX6nDxZXHgphESzmjnBfwT2cWqsxJXuj7cz/tSwB25Ms07UwoVDE5wTlzT3cvPJT3tR5J5S8Pn52gV+n+My+3Sc+0r+4N2wkvOdNQtSt2ooMSTjKhNSqJsyIDv3eGraw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993679; c=relaxed/simple;
	bh=zlyO+6t9l74q0Uu/n4XKKcbNqKDMmY0HE3OY3VTKVTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrgosIORynX8zoFk+oXNtI64HDFZjJCG8ksPrw/aMRZYF68+Gt9+08tjrJ0QuHW0c296asik/nT8Xah2PeM6EYhWQ/DgOKC/nE69x5oOZ1ZSxEXXXwLxVYSQD6bV83RmdrfL77OhLnfRocN13kzSPqT/7D5Wu70y8+8ZBZLYbwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+cHcLJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+cHcLJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B069EC4CEED;
	Tue,  8 Jul 2025 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993679;
	bh=zlyO+6t9l74q0Uu/n4XKKcbNqKDMmY0HE3OY3VTKVTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+cHcLJnzaqM27s/iBPicd6flqQgTs4FZBLY9rZqeUrLlMVY5EV4KKdYG/WqDmXwH
	 YMb7lQGOuiuiXUMJ4J18tcHgb8xAQwUvksULFPwfCh7KOOYE30lRfvD+1+hSyHHtKS
	 Zkw8EhVlex+DEXY7CNgOg9BOkdzTzYyHeGg+Y2CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Kerling <pkerling@casix.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 156/178] smb: client: fix readdir returning wrong type with POSIX extensions
Date: Tue,  8 Jul 2025 18:23:13 +0200
Message-ID: <20250708162240.571607489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Kerling <pkerling@casix.org>

commit b8f89cb723b9e66f5dbd7199e4036fee34fb0de0 upstream.

When SMB 3.1.1 POSIX Extensions are negotiated, userspace applications
using readdir() or getdents() calls without stat() on each individual file
(such as a simple "ls" or "find") would misidentify file types and exhibit
strange behavior such as not descending into directories. The reason for
this behavior is an oversight in the cifs_posix_to_fattr conversion
function. Instead of extracting the entry type for cf_dtype from the
properly converted cf_mode field, it tries to extract the type from the
PDU. While the wire representation of the entry mode is similar in
structure to POSIX stat(), the assignments of the entry types are
different. Applying the S_DT macro to cf_mode instead yields the correct
result. This is also what the equivalent function
smb311_posix_info_to_fattr in inode.c already does for stat() etc.; which
is why "ls -l" would give the correct file type but "ls" would not (as
identified by the colors).

Cc: stable@vger.kernel.org
Signed-off-by: Philipp Kerling <pkerling@casix.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -263,7 +263,7 @@ cifs_posix_to_fattr(struct cifs_fattr *f
 	/* The Mode field in the response can now include the file type as well */
 	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
 					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
-	fattr->cf_dtype = S_DT(le32_to_cpu(info->Mode));
+	fattr->cf_dtype = S_DT(fattr->cf_mode);
 
 	switch (fattr->cf_mode & S_IFMT) {
 	case S_IFLNK:


