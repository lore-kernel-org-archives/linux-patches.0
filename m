Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4813191BA;
	Tue, 16 Jun 2026 19:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636509; cv=none; b=rL4bbSRXnJPCGzRZ/U+qrgtFcHfQnZrZvNbBRSopzVMEnK85zsf55V2+qHkSxF0WLwgBhvIQ7O4M4sGMvrfUpylLCU0WAEMjzAnRtU981pKzZ4C+2sE9ESSsd3l1ksnvcf6cF2xWGcdh5ylpy+KG3nAVTdgAhlLW824Dre090IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636509; c=relaxed/simple;
	bh=UK+sO2UenRy/AqgzZJ9PkhX5QgXSIgkpx94TI7PwUpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtDFyIFfa+hm9emL+3PnhyX1RdC4i9K5BY/cR4HYoDqaISnNUsHx5pbloP1ZANB0JPQTmmc0P4E6FpYJCc6iLwRt9bwZFVukRy6CaWSgCWtO5bZQh3ESGQTJb8DNFFemyeVpdZNodKoba241YStj6erI9O9u8XXF33CIKdfi6Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI9Myq7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI9Myq7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7F81F000E9;
	Tue, 16 Jun 2026 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636508;
	bh=HRrPVDv5iuQi9z/0f/V2OurH6Bkxrk2QkSRgLaKD25Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jI9Myq7Goi/MBdjri2Kb7oYSkefOmyFfKRPQhAdXp+S50+eKk9nN7Me9Pyw2jqU2y
	 px5IXq/Bq+4qaO2MLUT6DrEDPWIy5hs2ipmI1hUbsK9Xd54SdN/84taueI5vkJo45I
	 I4Jtsfi/mjMb+lCgK8yjkfj1gtjHxGVgNByLfVX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/342] smb: client: require a full NFS mode SID before reading mode bits
Date: Tue, 16 Jun 2026 20:28:35 +0530
Message-ID: <20260616145058.398305289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -757,6 +757,7 @@ static void parse_dacl(struct cifs_acl *
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*


