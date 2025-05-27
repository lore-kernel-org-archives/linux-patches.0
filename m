Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B14C27A929;
	Tue, 27 May 2025 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364475; cv=none; b=eMCm4yyB/Wc7MP1D4TeRfxZYXlLOr9ws82K52x/kUYeKBz0Ar8P8lVIZngRz2cstBm8+55sb4qm9WmQJIFxro1RVLuwKwFuAakYE+n9FCn6yBK07GB07Kc0TtaI1f7e8InzKn7VYL9NKfxBJkYpULNYgEcbIr/QqXR1HhPvnOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364475; c=relaxed/simple;
	bh=/aplVIve/B32xpYyhA0GkBsd3FND1RxphGU/UYBxgjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LXhnwGqyi/e2GAeTLztpI1YlM3NBnRYUKQCoErQbe9zcOXZ0p03c0iqETMUZkDX0cKEyKULW0GFVPR28MPZFl5z1ArUKUbVX0ZceHgWcC2xF3gHBcpIu15VB3L3ogZbXC/MbG7RhRNZKHQAKGSa2NycgqdrTmEhiNbUsgv8/GwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqYKYLDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqYKYLDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28823C4CEE9;
	Tue, 27 May 2025 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364475;
	bh=/aplVIve/B32xpYyhA0GkBsd3FND1RxphGU/UYBxgjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqYKYLDuq9nvZuQ8c3Pn57tGwe4sXNVAYJbx4Xc7qabhb5W1eiQ54/mnK94vmz5ig
	 yEYVWd+PClsb6PaKY9efXxTTsaJt7sNwjqo9NkMi22R73XH8w1Kf8SU5KMvoRmUpiH
	 hlt3t2YcUF7r03Co73LKvHQ4HaYYpOHTdgO0zf4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/626] cifs: Set default Netbios RFC1001 server name to hostname in UNC
Date: Tue, 27 May 2025 18:19:21 +0200
Message-ID: <20250527162447.815351285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b015a4f997cb6..8b70d92f48458 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1058,6 +1058,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	char *hostname;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1390,6 +1391,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



