Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA91171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C49C433C8;
	Mon, 21 Aug 2023 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648525;
	bh=hVo8r1J1bmzh7XurJYBE4Ckc8A413nsLSwryrhcX2EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3S5q+z9AWd49CA3l8ncrLRF0oUg45LwbV/K5Zi2IdRf9cr90TwTUWWcpqMLcEJBq
	 ht1qjV+FeMbZcE3+jlvIehVWsFRZQG6HHngxArp+2Q30M0WfXrOfc62EKLoLJuz6Ex
	 LRiyy/IeHHb1DRCklG5Ry6eNTIZqXfETmtH0e3mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.4 206/234] smb: client: fix null auth
Date: Mon, 21 Aug 2023 21:42:49 +0200
Message-ID: <20230821194137.964383468@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Scott Mayhew <smayhew@redhat.com>

commit 270d73e6507f9c7fff43844d74f86365df000b36 upstream.

Commit abdb1742a312 removed code that clears ctx->username when sec=none, so attempting
to mount with '-o sec=none' now fails with -EACCES.  Fix it by adding that logic to the
parsing of the 'sec' option, as well as checking if the mount is using null auth before
setting the username when parsing the 'user' option.

Fixes: abdb1742a312 ("cifs: get rid of mount options string parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4946a0c59600..67e16c2ac90e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -231,6 +231,8 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 		break;
 	case Opt_sec_none:
 		ctx->nullauth = 1;
+		kfree(ctx->username);
+		ctx->username = NULL;
 		break;
 	default:
 		cifs_errorf(fc, "bad security option: %s\n", value);
@@ -1201,6 +1203,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_user:
 		kfree(ctx->username);
 		ctx->username = NULL;
+		if (ctx->nullauth)
+			break;
 		if (strlen(param->string) == 0) {
 			/* null user, ie. anonymous authentication */
 			ctx->nullauth = 1;
-- 
2.41.0



