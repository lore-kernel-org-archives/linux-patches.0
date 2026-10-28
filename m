Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216975;
	b=qCyw7djk28FxePO1JmEWA48k07Nc3gWfEm6LNqzPow4zpH78TOF/Ew0QzgnXzgpnFf6F
	 BUW2o7crHGukP6DdP293/8eLuQt9X4PtaAAygGFxbJf40xjzBmxcB3/qTaMYGmlaguXb+
	 DGBRuRXzJIdTBnFtGP1QyS5/WbvOqseNz70SebM4+Ie8NCcsL72pAFTuRcEmXId771mVF
	 0VVL1mcociZJ4JF0ue0jCurjFlgrtyCNuiZdj/qn58ZbRatYH3ZpmH1f/BCVTj8AAi9Ch
	 PJ0iIs3k6MDOlgPqJzPLUd0l2YTVlvnKwuwcKxWmO5w9RyRuZ0UCzNkaUUTa7EQbJ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q8QaE9ZEkg+epzj5SG1eS+4YXmATLdY6q232HdohMY=;
	b=M5jZ0g6VVjQKfn8CZyJFZs/P/si6DElU686Q3uGmi6d4Zb6959+HUVKdtAB2j+EmlhWk
	 g7X9/bqxuIckKyiPeNKfzwhGPAatX6g+ukKD0MNi+5tbWsksQmPmuKjFRAiexusvs4rcu
	 MtBXACoWuELcMayAbQRwY46PvGmYfN5h/vD5fOHxtmx/RFFnXFpDdXKcZHPs/bNVjtBnG
	 df0gyiv4RGG3nV1a0caQ4wK0bP2dMzOxxF6I05BeMAJ9UFvUn5xxg/eUmsudhrRLqwnXv
	 JViL8fydUNGpNSQLcp8WpuLgVrPXyX3eJBiZ1Zo9yqwOk8W3rroLvSCv5Eo5CCw1vmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1MLIfFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC168606A31E;
	Wed, 28 Oct 2026 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1MLIfFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D7C1F01825;
	Wed, 28 Oct 2026 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216974;
	bh=8q8QaE9ZEkg+epzj5SG1eS+4YXmATLdY6q232HdohMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1MLIfFF/sx59f+QcYd9q9MLHqtmdbI663SsBhKjo0Cml28D4GP3/SW2Wexosxxsm
	 c2bjb7t9m3mKNimYaZD4I9f7pDetHpxwcnZHsZahl9qLFNBULKvvuyTXOmVLFgArTJ
	 MEOjC51mJm/el+Y3Pi6aZL4cbeohj8tP8qr3G49E=
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
Subject: [PATCH 6.1 1690/1887] smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()
Date: Wed, 28 Oct 2026 18:03:06 +0100
Message-ID: <20261028170537.914448589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7564927e2c427..ded9cf784c22d 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -234,8 +234,9 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
 	struct smb2_posix_info_parsed parsed;
+	int rc;
 
-	posix_info_parse(info, NULL, &parsed);
+	rc = posix_info_parse(info, NULL, &parsed);
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
@@ -277,8 +278,15 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	if (reparse_file_needs_reval(fattr))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	if (rc < 0) {
+		cifs_dbg(VFS, "%s: failed to parse SIDs: %d\n",
+			 __func__, rc);
+	} else {
+		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	}
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.53.0



