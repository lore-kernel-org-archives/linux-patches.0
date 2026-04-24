Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0713537DF;
	Fri, 24 Apr 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038238; cv=none; b=UX2YmobytEpGk58jAIIhbOvTGM0mhv1gKQaiPBq4Wqi+yhnyvEXqIDIhL1ABJ+UMhr+wMS6N+3MpKTYOVM4O4W4d2A4OUR3id4U93j9xrv6oWmS4HeoNoFel4138ov/rtCXRRH1eypyjjT4c4h/8kU04PbPKgMc2y9bG5RwbA50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038238; c=relaxed/simple;
	bh=XntzSczywZ/e+PuBGF+AKSPsMgVy9lhodx/gNvGtPBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHFPGT0ORzMmI8JJQQ4eAeZwuKsZoHk+iKmls8EsV+bDPy2czKQGqPjfukWwL3Hue5NzFzn/rriGY1QXRPHkI4jzi0iuvW+uV+26vJwGAcskcozl4yrLDanElkX7dvnpkyGFdcpw5U6xMTwF/rzyOULrwOW+u9ZajjaZghwAp/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzv/5ShI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzv/5ShI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09110C19425;
	Fri, 24 Apr 2026 13:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038238;
	bh=XntzSczywZ/e+PuBGF+AKSPsMgVy9lhodx/gNvGtPBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzv/5ShI5AsS4FNsB5fAkIlaNnZp6ie8DAND7/nL45sOVAUkfd6wWa3uHhDArNbVd
	 bPWNj/6PZaOmS2FpzBGWXPntMCF657aKM3YW497+SAnhxjcDr3+Qe85Wip3fzbC6KC
	 rU59J+Oz3uF9PZw/L8syTxicbkqM3y/c3DGtZ7ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 22/35] smb: client: require a full NFS mode SID before reading mode bits
Date: Fri, 24 Apr 2026 15:31:29 +0200
Message-ID: <20260424132416.346544351@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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
@@ -832,6 +832,7 @@ static void parse_dacl(struct smb_acl *p
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*


