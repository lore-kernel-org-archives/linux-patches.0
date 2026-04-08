Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963BE347503;
	Wed,  8 Apr 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671902; cv=none; b=PzZ7H5n7ivgseV6k0Zvf4uYDuQOfctrpBvUL4oxrrCiu94tEZPuu/a30CCCPrp0TAD5gQCvp1miOjovz8e0S2LVHAzJgGcI96g1wnISAo16IT4q64drtnDeG3rHpGW8d9ibt2yx442Cy7lQCkswyvvHXKcvYjxDlFXi6LmOTPJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671902; c=relaxed/simple;
	bh=6eVQyAxEY9oiRdZBm5Fqu6vBjTUlDT/RK0Ydnk9KSl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFnJEWKfw8Nt2Iv89ghrwrlCQi/8ogXhWLFFKpFZJiW/yd1ECpjSQvpcLYxNwBrcA87RJCtNN0/DCIONM3MKwtjl8Y8fkcVZqQe9506Z3LhX7FR4CHvig1YtBSgGFurPXbiXoP9pbvgwqmt2m7/ulEi7vWs0wvLMq/8619HcfUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQl1LExC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQl1LExC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25682C19421;
	Wed,  8 Apr 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671902;
	bh=6eVQyAxEY9oiRdZBm5Fqu6vBjTUlDT/RK0Ydnk9KSl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQl1LExCGgDASmGmdBOb7MHDUB6DJXUVvjLaZwKxMtYd78G+0gSlzadgO1AoQD4KW
	 TajUBUDPk8Keh2JUcR0BmUbJWgGO/nEeoSD3ezOe+Dz+eyD1N0FDLIWfnKP0wvY2QF
	 Vw3AIZKkz2QxEQAY0oC7HG3Q6Uzoz3T1CaZmU64s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Durrer <anthonydev@fastmail.com>,
	Simon Weber <simon.weber.39@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 112/312] ext4: fix journal credit check when setting fscrypt context
Date: Wed,  8 Apr 2026 20:00:29 +0200
Message-ID: <20260408175937.951735061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Simon Weber <simon.weber.39@gmail.com>

commit b1d682f1990c19fb1d5b97d13266210457092bcd upstream.

Fix an issue arising when ext4 features has_journal, ea_inode, and encrypt
are activated simultaneously, leading to ENOSPC when creating an encrypted
file.

Fix by passing XATTR_CREATE flag to xattr_set_handle function if a handle
is specified, i.e., when the function is called in the control flow of
creating a new inode. This aligns the number of jbd2 credits set_handle
checks for with the number allocated for creating a new inode.

ext4_set_context must not be called with a non-null handle (fs_data) if
fscrypt context xattr is not guaranteed to not exist yet. The only other
usage of this function currently is when handling the ioctl
FS_IOC_SET_ENCRYPTION_POLICY, which calls it with fs_data=NULL.

Fixes: c1a5d5f6ab21eb7e ("ext4: improve journal credit handling in set xattr paths")

Co-developed-by: Anthony Durrer <anthonydev@fastmail.com>
Signed-off-by: Anthony Durrer <anthonydev@fastmail.com>
Signed-off-by: Simon Weber <simon.weber.39@gmail.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20260207100148.724275-4-simon.weber.39@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/crypto.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -169,10 +169,17 @@ static int ext4_set_context(struct inode
 	 */
 
 	if (handle) {
+		/*
+		 * Since the inode is new it is ok to pass the
+		 * XATTR_CREATE flag. This is necessary to match the
+		 * remaining journal credits check in the set_handle
+		 * function with the credits allocated for the new
+		 * inode.
+		 */
 		res = ext4_xattr_set_handle(handle, inode,
 					    EXT4_XATTR_INDEX_ENCRYPTION,
 					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-					    ctx, len, 0);
+					    ctx, len, XATTR_CREATE);
 		if (!res) {
 			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 			ext4_clear_inode_state(inode,


