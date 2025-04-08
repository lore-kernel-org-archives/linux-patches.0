Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7DA26A1A7;
	Tue,  8 Apr 2025 12:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116891; cv=none; b=M/DiAZJv6crbX+4l9ZKzh6BYWzdBK0j8HD5XEFIbl4xp/Dwfu415zmgZKpQU5ecYQbcVGeTC31U8mXFNq55XIocdomb/jDYFkuwIKFE6WAS+d39LbI4kg0wK1c7fx0RF3y3nc29PjOnfdBIQibb+2mjsV00LboxF3ebKg8pjh1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116891; c=relaxed/simple;
	bh=atHY5jlwUd64cVBrkA4z5dUbAL3LqtIoa8cYEuBeKk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVdpjUWoxa1EIGWKH8oht3yN1vvv9ueOysQYL8gTE5eLTJbBbLkEcC136wkU2cyMYCVjC0iN6pXAFE7/O/Ni9VSjGPwhUTq60Wd200uVJ55gvfU45K2TXIlHyxcnzbaCa+BVMwHhya/FiN8ybeKhhlVlchoPH/cvTR9cLPYd5Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7vFRLys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7vFRLys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5232FC4CEE5;
	Tue,  8 Apr 2025 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116891;
	bh=atHY5jlwUd64cVBrkA4z5dUbAL3LqtIoa8cYEuBeKk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7vFRLysVlcmi1B6yzh7m6NB4EY7WPzZ7Dh2eYhALvEtIhBlBdFdV5dbnmeQ4KYD7
	 Tt/J14th2svDrtVLgc6L5hk6CU8xciRyaYBb0i38GLqN3/ttp+JHjxqX/s45GyceQd
	 pl+EmBhUS20jMov8MW2RjJ4k/Iab2cIU6jyKTqC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/423] cifs: fix incorrect validation for num_aces field of smb_acl
Date: Tue,  8 Apr 2025 12:49:54 +0200
Message-ID: <20250408104851.997702782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit aa2a739a75ab6f24ef72fb3fdb9192c081eacf06 ]

parse_dcal() validate num_aces to allocate ace array.

f (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in response buffer
size. Use this to check invalid num_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 1f036169fb582..e36f0e2d7d21e 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -778,7 +778,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	}
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
+	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		cifs_dbg(VFS, "ACL too small to parse DACL\n");
 		return;
 	}
@@ -799,8 +800,11 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
-		if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+		if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+				(offsetof(struct smb_ace, sid) +
+				 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 			return;
+
 		ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *),
 				      GFP_KERNEL);
 		if (!ppace)
-- 
2.39.5



