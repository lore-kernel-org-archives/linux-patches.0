Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924F50B42C;
	Wed, 30 Sep 2026 17:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791097; cv=none; b=U3nfSN50AWlJxoQMT0hpI3GtDCplkngUEfkF+9ew1t2fPa0eeNvW1DZJnWLFSP85okVE1vwc9UyF8uVobFBhetryW9CBj4bSMwfY3UlHZuI2V9JVI1hEg32cRBTjmOQNE7awwerKwdkrb4G+xNzpX4hWFcuTJc/9VK2F1q23FjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791097; c=relaxed/simple;
	bh=cnmeaUcy7LyXwe1AoirH9NxAYErODC/j8fNidizTjRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKYEW02xQxoQyvvnizs+bNDkD9jyCtrEbL+Js2AckVYDDPwYZs5jDxFZ6iXeVPYgcZOH8tDv1NQc36vnDZObSIBEVet+UCzSqitAF88yiea8fjlRFLMrO1pAogvR6IyheAKu+R9O8wtM13a0Pwfw0NEnspV+CrB6n5wtkRhfvDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+BcXsz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+BcXsz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE9E1F000FF;
	Wed, 30 Sep 2026 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791096;
	bh=OpPpQLvBPCFbnoWXZkixpaVFC/7uzYA8I2UK4cDtskM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+BcXsz4k7SuL+hz8wJ+cKWdifIkE0lpaHpmFUGOj+daGSq+NHiwNyvnUXBateNq2
	 dJVtqTfIL7bQXPt7paM1utHkOTil4VCLtU7g1J/91QnqNBnSnazeXMSudV73J5uXTA
	 7lJsSoscYk81Nlx0V8jgswiiCkBWDdfs4tGusR+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/752] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Wed, 30 Sep 2026 17:20:54 +0200
Message-ID: <20260930152402.188681725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit 7ac657bb9c5c1b0f7bdf1fa6d3ad532f969be5cf ]

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 8da562b11b6f6..e643cd1ee87fc 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1603,14 +1603,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct user_namespace *user_ns,
 
 	err = ndr_encode_dos_attr(&n, da);
 	if (err)
-		return err;
+		goto out;
 
 	err = ksmbd_vfs_setxattr(user_ns, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
-	kfree(n.data);
 
+out:
+	kfree(n.data);
 	return err;
 }
 
-- 
2.53.0



