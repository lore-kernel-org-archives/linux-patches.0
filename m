Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C27386550;
	Wed,  8 Apr 2026 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672411; cv=none; b=eF8pqd1nwaOnxpy0hx6P26ICkjPZDYs3yFo9rAX/RjruZ61I2X+rU4W693FaZ50RpLy3Z/BBHPGsZwCXY/hZfWaGr846tMHPGQhTF2HuzJNE4PSicfTblbp1SvoRsd7hL0r8rajl7UyOxwr82O8K3JrT9EeTWqm8tv1DiAA6M7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672411; c=relaxed/simple;
	bh=DvXGfJ9Oo7ghRsfDGJnIh3sp02I9zCEZEJtSy4jMH7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6oqTReCn9/XJiCF4RcfCT7x5lQadupcrpvFDQLp6htVcV3gHY9SdY+8ueRYd+KNRYoEnKION6USBPqcKISO/wqXhY6yrfsYs+xuqNVpza2s4ovgrwPNzUlEjfLOBhuf6a/7N2scEUvwkZr9+QIvCkzKBNEHD6g5SorQOsD2/pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQ+hylml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQ+hylml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F92C19421;
	Wed,  8 Apr 2026 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672411;
	bh=DvXGfJ9Oo7ghRsfDGJnIh3sp02I9zCEZEJtSy4jMH7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQ+hylmlrE0De6hgy7r1U38U9DbxuuUJC+/kt4PXtuuPpmFTHCrCdBk7VnCBrfbNJ
	 LtJtRxiu1Plxox1xaP+asCvM2XnENxeMHUIsWVfcscJJGbpAQVIVH51jdJJMOKlNLI
	 nqgdM3eljGto3anQ9RtasoDsQIIqW3KmfHoKTYj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bbf0f9a213c94f283a5c@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 6.1 310/312] ext4: fix lost error code reporting in __ext4_fill_super()
Date: Wed,  8 Apr 2026 20:03:47 +0200
Message-ID: <20260408175945.352602900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit d5e72c4e3256335d6fb75c2e321144f93141f4f5 upstream.

When code was factored out of __ext4_fill_super() into
ext4_percpu_param_init() the error return was discarded.  This meant
that it was possible for __ext4_fill_super() to return zero,
indicating success, without the struct super getting completely filled
in, leading to a potential NULL pointer dereference.

Reported-by: syzbot+bbf0f9a213c94f283a5c@syzkaller.appspotmail.com
Fixes: 1f79467c8a6b ("ext4: factor out ext4_percpu_param_init() ...")
Link: https://syzkaller.appspot.com/bug?id=6dac47d5e58af770c0055f680369586ec32e144c
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5531,7 +5531,8 @@ static int __ext4_fill_super(struct fs_c
 		sbi->s_journal->j_commit_callback =
 			ext4_journal_commit_callback;
 
-	if (ext4_percpu_param_init(sbi))
+	err = ext4_percpu_param_init(sbi);
+	if (err)
 		goto failed_mount6;
 
 	if (ext4_has_feature_flex_bg(sb))


