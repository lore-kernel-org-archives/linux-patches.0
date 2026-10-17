Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3DB3CC7D8;
	Sat, 17 Oct 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260698; cv=none; b=RqGdupKQG1U1nAfgvY01zakg+VpGobH9WLobnJ8UzZbKtCGXQ848fneG/5kl0EZb9qEH/BAEA1XRtszTLEGAkk3Oi+Vay9l0tnrCHLP1LwJ+6M/EJfucxVmxc8nl4jUHNoQyv96MQp1pWNpW0367qylQoLb+GYACaAQeMSZuOmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260698; c=relaxed/simple;
	bh=A5Mr2hzAwkGxl+ZhDwzdFGJffC7T9rtOZtStwRaBTv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG9jbHfUrtJ3sIWbWymEovzzvKPWs9N11U/L6TSkpobFfT6wLARr+IFskD36A0z7y5WpunBmFGJ+U0CgZnAlL5qMY445rTkVb7v2iphBcQfidPNbXZfP+x3usZUS8vEDqoOWs6hbtJt0nujH5EIE27n43+moTSp3iRdkPCQTsNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYU270BQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYU270BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23FE1F000C4;
	Sat, 17 Oct 2026 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260695;
	bh=ZCzmwQNzzUQ/ZV1/KgBGIUxY4cS7GBOT/HgOIrzDBJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYU270BQQYSrWMMfBXX1Hle0QU1oHfH2P+zMz3S+HQTt5r+lDLq1rwtSIWCiuawP4
	 D4n/WbyfARz4gB0Iyp3kCowfz+6mzeJABE9YFjvo8+co5teuoKcBlr5NeBUa+Bkwd8
	 sWdJTsQ80QI/4nZgWRyWrgh+EFMIl2Q5wpZQbkgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1589/1674] smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()
Date: Sat, 17 Oct 2026 18:04:21 +0200
Message-ID: <20261017160511.875749641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit da6e25842431982d5a53cf00d925b98c690f4467 ]

cifs_posix_to_fattr() ignores the return value of posix_info_parse().
When a malformed POSIX directory entry is encountered (e.g. invalid
SID lengths from an untrusted server), posix_info_parse() returns -1
without populating the 'parsed' struct.  The uninitialized stack
memory in parsed.owner and parsed.group is then passed to
sid_to_id(), which processes the garbage bytes and passes them to
request_key() to construct a SID string, potentially leaking kernel
stack contents to the userspace idmap daemon.

Fix this by checking the return value and skipping the SID-to-id
mapping when parsing fails.  The remaining fattr fields (timestamps,
mode, etc.) are populated directly from the 'info' pointer so they
are unaffected.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index d6f3f9a3c5730..434d5f74b2ef7 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -242,8 +242,9 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
 	struct smb2_posix_info_parsed parsed;
+	int rc;
 
-	posix_info_parse(info, NULL, &parsed);
+	rc = posix_info_parse(info, NULL, &parsed);
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
@@ -280,8 +281,15 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		 le32_to_cpu(info->ReparseTag),
 		 le32_to_cpu(info->Mode));
 
-	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	if (rc < 0) {
+		cifs_dbg(VFS, "%s: failed to parse SIDs: %d\n",
+			 __func__, rc);
+		fattr->cf_uid = cifs_sb->ctx->linux_uid;
+		fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	} else {
+		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	}
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.53.0



