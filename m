Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156CE1D88D7;
	Tue, 27 May 2025 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366447; cv=none; b=fcojp7MUJUc2EFF5s9KA8i9GiL8eI56ShUlqMQH2z6N0ZemYwd0z4jn1r69l++nK9ZiK20Guuo45H966CVKo22fLxS8X96TBW2wJSwfQfYOpHb/ltUoYZ/rL8KteFvr1BVBfRMsY3+fHDDgj3b9XPFACorf5tnMuKmlj9S258M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366447; c=relaxed/simple;
	bh=apNb1PgpF/gjVfdlOimcNzrH4gA09rU1H6LPk3MwR7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWaAD8URyWibTZ3O1uUVqIeNC7EFitNzoMKzVFAgpEnoBVxMkB2Li+CXxNkya5SR3jUIXNZD69HxE3YTiieuPkM5qop0ilX5qryRkHFUTm/A4IpqwvXvi+bY6/ea2+Tj4p95ZGnR56iXjbATh4LcQVZZ4hs0mkf9BYJDZdOsOrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/Vd9FZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/Vd9FZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86297C4CEE9;
	Tue, 27 May 2025 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366447;
	bh=apNb1PgpF/gjVfdlOimcNzrH4gA09rU1H6LPk3MwR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/Vd9FZy2nI7pIC+hOlgq9H79w6+mN57GrrgERfdNEZbNPh40Icje4EGfD143Jwv5
	 cLPxtvmH7j54BN4NZV+02Izb37am6R7C3Rhzvl0UczP8yo4wVXap/Ef0X1gNQApML6
	 /KjMCcDOj74G1G97O94gZdSWp8yLZhg4SnLxs380=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 070/783] cifs: Set default Netbios RFC1001 server name to hostname in UNC
Date: Tue, 27 May 2025 18:17:47 +0200
Message-ID: <20250527162515.978508160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit be786e509c1af9b2dcf25c3d601f05c8c251f482 ]

Windows SMB servers (including SMB2+) which are working over RFC1001
require that Netbios server name specified in RFC1001 Session Request
packet is same as the UNC host name. Netbios server name can be already
specified manually via -o servern= option.

With this change the RFC1001 server name is set automatically by extracting
the hostname from the mount source.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 00af8dd5aa689..b877def5a3664 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1118,6 +1118,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	char *hostname;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1450,6 +1451,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
+		hostname = extract_hostname(ctx->UNC);
+		if (IS_ERR(hostname)) {
+			cifs_errorf(fc, "Cannot extract hostname from UNC string\n");
+			goto cifs_parse_mount_err;
+		}
+		/* last byte, type, is 0x20 for servr type */
+		memset(ctx->target_rfc1001_name, 0x20, RFC1001_NAME_LEN_WITH_NULL);
+		for (i = 0; i < RFC1001_NAME_LEN && hostname[i] != 0; i++)
+			ctx->target_rfc1001_name[i] = toupper(hostname[i]);
+		kfree(hostname);
 		break;
 	case Opt_user:
 		kfree(ctx->username);
-- 
2.39.5



