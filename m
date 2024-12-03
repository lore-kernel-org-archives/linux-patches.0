Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6F01F890E;
	Tue,  3 Dec 2024 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242316; cv=none; b=N3Ti29F/Hpc8IdpWYQLFSpnUvHeHtHLANdgRJjDegqxSwOwjCGHZQyBVogOs+utldvsL52AdNk4vn2WRaybGJEDNByPRGDfQq6ZebGqKQv4/UMVGpu7CpOB4TJMMLoxHro34byXabSamCYspaHU72pYxtFfz0SRvSbidoz+TY/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242316; c=relaxed/simple;
	bh=5+099S8TDIjcF9jIyupR4KeFkMvSmktKQdaMnFCMAfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJETeFtGNWAJ+8biYvPo6FjeZT7A1yqluKu1PRsqKanLI8mZHSB9yWbxd2MjTfPwcQ+I3AsZr/8kweWhchtYEf1uwHxbBCIfNOezliuuyDyU4FUCebbw2D139mDrf5RliMJLu14a9ZwF2DFxR6YPlMQlpdRnhfjECJPgpd+NSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZTG+lon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZTG+lon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12DDC4CED8;
	Tue,  3 Dec 2024 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242316;
	bh=5+099S8TDIjcF9jIyupR4KeFkMvSmktKQdaMnFCMAfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZTG+lonQBE8v7bhOnRZ3uV7lqoDJ8fVVFwYX+I46knxEUxTSS+LjS6Mxxw/1BBXK
	 wRujEC5oP59ZC1NOlVY5l66nkceUXZVxg4y8NykCmLBjP8GqedpveObxMPqJ0Fyaua
	 r6QbIF50hcSrZN/mb+q43a2wEPcvYP3puI+PeNkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 670/826] exfat: fix uninit-value in __exfat_get_dentry_set
Date: Tue,  3 Dec 2024 15:46:37 +0100
Message-ID: <20241203144809.889651143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 02dffe9ab092fc4c8800aee68cb7eafd37a980c4 upstream.

There is no check if stream size and start_clu are invalid.
If start_clu is EOF cluster and stream size is 4096, It will
cause uninit value access. because ei->hint_femp.eidx could
be 128(if cluster size is 4K) and wrong hint will allocate
next cluster. and this cluster will be same with the cluster
that is allocated by exfat_extend_valid_size(). The previous
patch will check invalid start_clu, but for clarity, initialize
hint_femp.eidx to zero.

Cc: stable@vger.kernel.org
Reported-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Tested-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -345,6 +345,7 @@ static int exfat_find_empty_entry(struct
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
 			ei->start_clu = clu.dir;
 			p_dir->dir = clu.dir;
+			hint_femp.eidx = 0;
 		}
 
 		/* append to the FAT chain */


