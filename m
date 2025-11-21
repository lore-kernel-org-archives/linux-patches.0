Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D782D73A9;
	Fri, 21 Nov 2025 13:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733466; cv=none; b=Buzj57Dd6YiiQxR02fWKcI3p/xHK23CK24jd13CQvXNicyivw979MRuxJk1ShnGAdDSypzLV8NWxsT4dkzPFxUuVEblHx4nsmdTP+KhljEO688cWy7/p6k07B/KIJZjhPgTMvQ8pvmh0w/9bHpYRhalsv3TVbZg6xCExQthEI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733466; c=relaxed/simple;
	bh=rlv9aRYphEgJnTHaenV8aWOsUZ2LmcjwGunwWAueOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvBeIxcoHtPKdqatFh/RHWqm87fhk5Su+R32r5HkWd6WKe16i806/X4X2LvB3o9dMdTNiWUxbKFvxBF/DffsnEpHcrtXC/SENSPOQ/Gg0eGvTOK2STjC/EozBmOvw3KTdUHoFmGYgs1AakADrC2R0X9mawj1mnhtkZhlIQfGcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2u+exdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2u+exdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BB9C4CEF1;
	Fri, 21 Nov 2025 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733465;
	bh=rlv9aRYphEgJnTHaenV8aWOsUZ2LmcjwGunwWAueOpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2u+exdtqe5OjqJSfAbVzT7IKbKGEVD7NuykUeftqnKc2Zfhgbf1Zaili/8UxOUPh
	 5GHbKamyaGtA16DbYNi8s3RQzMvdRi5wRCUJAhts5aF9ze4LYlTUKKIqDvbERI5Tt1
	 LYU07tqZVIRIW+die0L9MlEYsb9olUYkfSpcFAR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 477/529] cifs: client: fix memory leak in smb3_fs_context_parse_param
Date: Fri, 21 Nov 2025 14:12:56 +0100
Message-ID: <20251121130247.981794795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -1361,12 +1361,14 @@ static int smb3_fs_context_parse_param(s
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


