Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23F821773D;
	Tue,  8 Jul 2025 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992579; cv=none; b=IaOBfazQjlvDcih9NS9A1ODpFcNU0VTD40Ha63H1tgg9QHo87ihcbP3SGLSjlaPp0k+va76JgJhAcCT5/BNxtxCNoCYrT4sJkdpH4FUVWkfMu3gf4Jyw3VtENnbRAWfi3AqnP0VieQdkzaKUbApbLcfIpTqYA9aYVsqyTPji74w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992579; c=relaxed/simple;
	bh=wd9o4dN2WeLEm7A9I+OQnfLMkPa1tyJGxYQWmWMFTBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjvZSJG5NZNchYfgzHTBSLN3ShtAG+P+U12iYtP9Ps5z5o9HYCZJwCjLRnVg+1DuBh5afTTJ6IurDyAvfkWQ+MRL1DqjTb2aEnDjVEaQ6avytLRrpY10fhokoQjGNciIfuhrH14J5fNKz1ickYGQ3mg78a92abetIiwHlYLmrdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKVWMn9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKVWMn9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9ABC4CEED;
	Tue,  8 Jul 2025 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992578;
	bh=wd9o4dN2WeLEm7A9I+OQnfLMkPa1tyJGxYQWmWMFTBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKVWMn9A3tSsMUBvUxU+kxI5GqeaQKHDIn9YjsWaIT7ILN8iZHbEoTjs2OTeSrfsL
	 2l/cFKQIuWUFr3wunBuhoZZaOx3g035SpLrofCtQ6OJbiKbN9OWCgDwJGm8y2fxpOy
	 ecoEzGWQziNv0XUn+8tkqX+okNh/qAx6oe8CdEMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Kerling <pkerling@casix.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 117/132] smb: client: fix readdir returning wrong type with POSIX extensions
Date: Tue,  8 Jul 2025 18:23:48 +0200
Message-ID: <20250708162233.978771844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


