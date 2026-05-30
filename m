Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88131CA4E;
	Sat, 30 May 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159738; cv=none; b=s8JCdDoawGFH6oKWez/HfB7ZOoTGbhf6I95GpD+KzqfOYEdjeU6Zt1Zb+tWhjYypMG3CTIYYUEz9YtZYrbo7IAKxGb5zpRL8Emf/8K0IyW363qhC/aJ+1XaY3a8TS8BhbhPPVbaN28ZXnOQRf3pZ6vXgFWaNzyWdUaFOB/SPAAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159738; c=relaxed/simple;
	bh=dmLQABpSwoThTaWX56yEA8c/KhsYjZu5FaqepsmSN1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/IPMUZeP/eucL4mtVHzZtyk4tngE9t6a7p6DeWGxXE0yZyTX04mtujv0zZ8wHRoRSY19wX0avRCWhM9bfQwtLfVwHsB9q7GMHBjD7R+dS9wnonZi3CxL38ckIdAGV1vYRQHf0fSVxqKMsI8u8thQoSVj/GA/ZQUtm4SLZI0VJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2bRHJE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2bRHJE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76BD1F00893;
	Sat, 30 May 2026 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159737;
	bh=QraEt9EkUjQwzEEzYsvRo7JbAreF1kYq98L83pdJGY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2bRHJE2OGo2kSbB2xWQ57PyUZ5C5Del+TJUyWYeQO4jrXv+Vf5eGqZw8mJ29Zdry
	 o4G49TyCeNykBuI8ZpF6Cews6Ak4lA5XnkSruFYInLYPEKdEKF46IlquiBrcsNFgjp
	 Oaq5lAaV7obBxF8rqXyhcoHaA+Lpy6Qn2ndCnbZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 148/969] smb: client: require a full NFS mode SID before reading mode bits
Date: Sat, 30 May 2026 17:54:32 +0200
Message-ID: <20260530160304.641479819@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 2757ad3e4b6f9e0fed4c7739594e702abc5cab21 upstream.

parse_dacl() treats an ACE SID matching sid_unix_NFS_mode as an NFS
mode SID and reads sid.sub_auth[2] to recover the mode bits.

That assumes the ACE carries three subauthorities, but compare_sids()
only compares min(a, b) subauthorities.  A malicious server can return
an ACE with num_subauth = 2 and sub_auth[] = {88, 3}, which still
matches sid_unix_NFS_mode and then drives the sub_auth[2] read four
bytes past the end of the ACE.

Require num_subauth >= 3 before treating the ACE as an NFS mode SID.
This keeps the fix local to the special-SID mode path without changing
compare_sids() semantics for the rest of cifsacl.

Fixes: e2f8fbfb8d09 ("cifs: get mode bits from special sid on stat")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -807,6 +807,7 @@ static void parse_dacl(struct cifs_acl *
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*


