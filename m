Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB235292A;
	Tue, 16 Jun 2026 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634392; cv=none; b=m1KjqXTldXWFV7nhPqBMtQCURfrM/IAK7iHt5m36YjGgMRa8A4/VM3/0VL5PeOnZ0cJwn79Sq9i6EHBJN1dj6p3OWoaEFt3iWeg8dVtnQYA9iHQi2otXGVIv5hgNBia2T5hgPGiFBouJMppeSUAVHM8wl4O3m20LUpppz8dXE0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634392; c=relaxed/simple;
	bh=Cf/M6ZNJJZtfYMRVwjbDcoFYA0N/8ethrsSI5sjw03s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJxmOCm3v6jUcNB28CfRSVC98WnfSDKGtQdWQRVnVxE9WR3ix3OS0qCH4v9rU1ziAXqx7V/0CEowaaQIvTNN6CEFvViQ5J4jSvkZbus/gAzLuqdU7Ra3bGZIgp0GDb1aUypaFOmF1FuX4fYguiwk8rMovWgLmfUMwXVQaW9evG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcD5NTlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcD5NTlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7741F000E9;
	Tue, 16 Jun 2026 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634391;
	bh=qYMiwVRmMTsO4g6wxjSl/WxEyV6z7oDwi8ts1y17krE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcD5NTlwG65/99005XuVcKBqbFLm+nTohjbitH4xE2qOvADRpeaIS5QnKM+HVbSui
	 pHDtwhRNSWEcN9MOgrbGGMPQ/LykQZ5ra1HyvYXar9tmQ0dpuWLqRqhupoZJDLZliO
	 h+Tf9qhP2vkIaBT84iVCSX7Yry2ySfSSH+5UjiTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/411] smb: client: require a full NFS mode SID before reading mode bits
Date: Tue, 16 Jun 2026 20:28:13 +0530
Message-ID: <20260616145114.553689700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 2757ad3e4b6f9e0fed4c7739594e702abc5cab21 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsacl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -807,6 +807,7 @@ static void parse_dacl(struct cifs_acl *
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*


