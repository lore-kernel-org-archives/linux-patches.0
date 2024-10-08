Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF616FF26;
	Tue,  8 Oct 2024 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390610; cv=none; b=QVCN1yrKnigxAXrmCJN71/ycwdkwD0RDqvubBnJf4OlOBtoOkPE9d12fN2O9/AreS3Emfx/Gav9f38/PZSoCkFdRMfYibk9rb47/7PZDhhhBHW+H7+W3huw/17Ri5urZ5uPY5EdBf0YLSXC2OPgGkN+N12ApjIGkC0ob48wfWFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390610; c=relaxed/simple;
	bh=jf8Lovz9RuWrLAhsSUmOhga/MGu3uhXLrDhHgcuYFIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgsQwrCOKPGT4kM6C9GA8twJAE8nYb31HTm9gmejb0vYlwv0Ys/7kjgf2ZzgtVUQjczor5l8Sbk+g377Zv45vvohM4eYqkp8Y/48ik356GFgVX06fz/uD/hqSmym/OnaiSN1LqXnH1t9AFtHH+gfqPZGRc1op0Oiuz6Te9dSclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9vFnHTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9vFnHTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4645C4CEC7;
	Tue,  8 Oct 2024 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390610;
	bh=jf8Lovz9RuWrLAhsSUmOhga/MGu3uhXLrDhHgcuYFIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9vFnHTEyxwkrWNTTyZW4goM1zHWN4KEU9O/s2epLEBaCKscvXW3G+MfrxRvGvgAT
	 6s8Kxz+9+HQJkQdyy7B3TDKm12FW8Tyh1Tf6TUCDEQ/agFMwK1hGJ9/9EjKW0/g3IB
	 9AZMu7p3tRmdU3vmhsFFGlbgbSr4nX7/Y8MrijUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.10 339/482] ext4: mark fc as ineligible using an handle in ext4_xattr_set()
Date: Tue,  8 Oct 2024 14:06:42 +0200
Message-ID: <20241008115701.765736694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 04e6ce8f06d161399e5afde3df5dcfa9455b4952 upstream.

Calling ext4_fc_mark_ineligible() with a NULL handle is racy and may result
in a fast-commit being done before the filesystem is effectively marked as
ineligible.  This patch moves the call to this function so that an handle
can be used.  If a transaction fails to start, then there's not point in
trying to mark the filesystem as ineligible, and an error will eventually be
returned to user-space.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240923104909.18342-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2559,6 +2559,8 @@ retry:
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
 					      value, value_len, flags);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
+					handle);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
 		    ext4_should_retry_alloc(sb, &retries))
@@ -2566,7 +2568,6 @@ retry:
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }


