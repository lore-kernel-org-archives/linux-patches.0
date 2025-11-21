Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24321F09B3;
	Fri, 21 Nov 2025 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731926; cv=none; b=QU/3ohHQVi6YFGNOIezpFBtLlmZZQxdyB4Y9FxzyZSSdBdzZdMLrUpTMxOBd318DWvOtGqqOkfvfJ39056VHffWDw+Qmb+8Ft6VKEAgpB/+wm3Q1y9yOJqiYNPlsKocOwmbb/Cxjc9FkmwlLWokhZY7s5jqNqDO6fB+j3dTlR2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731926; c=relaxed/simple;
	bh=4V0hz3DPILaisVDF34C0bZDf08RbH9c0ZeBBRHjRRNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjJ0/cKcfS8t2xQNrh0J8FLU5Y3h4EEmOSPkYefDxDXnXJs26/Cv2z1BslNI7L5rNtH0RMz/HIzEPsQCzA4ShQsbNzx7S52/o2/Nz2dRgCH4sDOMl3umajztLEhjKab638khwgJkYRO+FnD3fkpcK20zXFbMV5bwdRxR/A+gAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzNe5r2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzNe5r2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D424C4CEF1;
	Fri, 21 Nov 2025 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731926;
	bh=4V0hz3DPILaisVDF34C0bZDf08RbH9c0ZeBBRHjRRNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzNe5r2N+OxydDM9k1TyhjxM1jYsYrVl7SOfpaSCo6KcVLTTzY/ezupBx0xUgL7cH
	 SoN9hKl+mjUpnk410iFtEYGHkYnldwUr8rxlfczR5lKU8U3FaNugnIU0E3j187RhXc
	 QJAK188tYw4A7aYw3Jgzd9OfUPRkTiULApkVhOeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 130/185] cifs: client: fix memory leak in smb3_fs_context_parse_param
Date: Fri, 21 Nov 2025 14:12:37 +0100
Message-ID: <20251121130148.567196001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit e8c73eb7db0a498cd4b22d2819e6ab1a6f506bd6 upstream.

The user calls fsconfig twice, but when the program exits, free() only
frees ctx->source for the second fsconfig, not the first.
Regarding fc->source, there is no code in the fs context related to its
memory reclamation.

To fix this memory leak, release the source memory corresponding to ctx
or fc before each parsing.

syzbot reported:
BUG: memory leak
unreferenced object 0xffff888128afa360 (size 96):
  backtrace (crc 79c9c7ba):
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444

BUG: memory leak
unreferenced object 0xffff888112c7d900 (size 96):
  backtrace (crc 79c9c7ba):
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438

Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72afd4c236e6bc3f4bac
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1380,12 +1380,14 @@ static int smb3_fs_context_parse_param(s
 			cifs_errorf(fc, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(ctx->source);
 		ctx->source = smb3_fs_context_fullpath(ctx, '/');
 		if (IS_ERR(ctx->source)) {
 			ctx->source = NULL;
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(fc->source);
 		fc->source = kstrdup(ctx->source, GFP_KERNEL);
 		if (fc->source == NULL) {
 			cifs_errorf(fc, "OOM when copying UNC string\n");


