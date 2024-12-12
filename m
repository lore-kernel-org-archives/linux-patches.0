Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAB8222D45;
	Thu, 12 Dec 2024 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018075; cv=none; b=DG8xg3se/yk76ke1hVn3yvujn4EeVIWAjTqTFqS8nIY033fN+BT+kGDI7fIMpSN3a0BxEs+xXwpN/UIkgdAV0dGgexFZu8lgG0+wnOTB0axobiKPPrCU803YlWenHjY3PX1CGdey0fN+c98ki5N2Lbhxc6rHdGrhZ3zyqU5zhjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018075; c=relaxed/simple;
	bh=R6DI5m/0b8rssdWgHMXiEVw4LSHNKuhho+YYh682Lyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f02FI75Esj8kjwBYmN2Vcfbu76hjGIH8ganzFqGUUsQNrsyjEW3td/+tI0cJlCNqTdz4gdyn6hR8iJQqFXgn0WfmsnlrZg15so1Y2EnOOZTZVRs6HER7NTGwGgHpYP2Rd4M2KKv5ViMOTWzQiDL0xD93J2ifF2Enr5/JkMgBC6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuabOYn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuabOYn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CCCC4CECE;
	Thu, 12 Dec 2024 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018075;
	bh=R6DI5m/0b8rssdWgHMXiEVw4LSHNKuhho+YYh682Lyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuabOYn1FQCWx4aQIbyzOL27xAt/aWT/Dp5O3L2VTmggEL338QTF4eKz5y59EP9Wj
	 RDdymGg1G2Bh9LehQlkl9tdTkcFfk6o1hXx+G0B7ulKklZ7H1k1cohJUOkiBbLIHzB
	 Lq1x2MneTUSu48w0nl3tIt3RZREPYmFFW6e+5zAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 160/356] fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for SMB3 POSIX
Date: Thu, 12 Dec 2024 15:57:59 +0100
Message-ID: <20241212144250.960670739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ralph Boehme <slow@samba.org>

commit ca4b2c4607433033e9c4f4659f809af4261d8992 upstream.

Avoid extra roundtrip

Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -943,7 +943,8 @@ int smb2_query_path_info(const unsigned
 		if (rc || !data->reparse_point)
 			goto out;
 
-		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+		if (!tcon->posix_extensions)
+			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
 		/*
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
 		 * response.


