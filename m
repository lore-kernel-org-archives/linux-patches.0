Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620863AC00;
	Fri, 24 Apr 2026 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037559; cv=none; b=SPXkGscC8ibxGXmQzrZFiUBRyaJpdO7H621PlB9cFdmnWJMuPJlP6fAxj+m6v1BtftNygYSiMcO05BfcVH/zYgoSC62FF0UjKhvWCzvmIBulg3i99oLyI3/M0CFO6wvzVRZuSVEH56MsCGEYH6i9+0ygvuj7TS8GUYF2P6+7xlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037559; c=relaxed/simple;
	bh=qGxRQ5cdByIfQFa2xfpKvP5t5ULfECZFDavwu8oFnzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZly5OrS3Rs7MGgfaV8e00QriJbUYZnmLp+hO9VU/cita4EnuVRaJutK7ZP84DBdm3ep7hx4yKh+WuF4xIwlNkrbd5VhgWJwkfsRQ6JKvSrZVWD8APV+SquIZSCGzypakPw9Ob/1u984TysNvfLJx5UALDCj3dUxWDnnjmZY3cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoyjyTks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoyjyTks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED22DC19425;
	Fri, 24 Apr 2026 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037559;
	bh=qGxRQ5cdByIfQFa2xfpKvP5t5ULfECZFDavwu8oFnzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoyjyTksgI7u1c/dxgH4E/Lqux70JxrCHDWw+2ikf5ZFNYOwXybelL0wj8BiYl83p
	 MAsg1m2DOeGZ6pY2uktef+pvFmSRTqS53C7qw3LuTNIxCKTCs/Afki4VR0LtPhhx9W
	 fTH2VlBltGrSn5qaoE3mQHp/9z488vCyx04mosfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 24/42] smb: client: require a full NFS mode SID before reading mode bits
Date: Fri, 24 Apr 2026 15:30:49 +0200
Message-ID: <20260424132425.455671886@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -831,6 +831,7 @@ static void parse_dacl(struct smb_acl *p
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*


