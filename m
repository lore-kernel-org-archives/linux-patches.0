Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216748;
	b=cKnMKg3gOYpxxmurtv1RFvvWqU5uJEAXgGzmrBd2ZHTYOGrYTZ7H+Q5fe1u0rxY845St
	 tEPw0OHZBiu3H+ogcARHAJb4wfJLm2I0ySJqhINmGOkOSUua/AytKyHkMLO3Aklwt1IxU
	 i6a7178dLGDJ/DpMWdWrSpuVKbXVbLN9kAR1dP/lBCMqBoLE9/d3J5NmaXWmQCyp/aSl0
	 DcsTu5GYT4rIyUsd5FJkWNP6lXvJHZ+PONDdIGSOkWf5Fgy3SCKt8CfVlB2miOOrCOfO5
	 UcQFld1kiaNrzIU80bn/6fMmnWWCYQ7gNo03COvQS0+UfniiSNM8IgVIQz46fK5sODA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/VW5nx+hgizstCr2i14s8afkeMop8UDlheerDqL1UmU=;
	b=KOwWUSXamw/BBkR5VxiPeGTz++OlT0UENeanzsU+26CPGOeoOWJgaKJjM3FmLgIlPlut
	 IQ1D8B6NtB4wrHZtItEpom0f/D2//GbqRLuxRV9PVwGKRhgccjr+oLvmJ6FtBOQSrnwbH
	 kLkmwinzuqqIQ4l83/wkHCWFcfEExbeFMlRgFh+Jl1pvBDarkUh+eh+w7mG3//UbJPc35
	 7LAchWDBftpieZPB7FTAfVyPeNz6IP/PRtCjscW4gwI7GrUridl9XgpicbOVMvxmr+Lgd
	 Yg1D3EZ+k8xrOyednOu8AzRjuYKfy8Qyf5LS/2km8/56W1Hwaq5KueR3UEx/CyL4o7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U86/W2f8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522A6606A31E;
	Wed, 28 Oct 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U86/W2f8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28581F01825;
	Wed, 28 Oct 2026 19:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216748;
	bh=/VW5nx+hgizstCr2i14s8afkeMop8UDlheerDqL1UmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U86/W2f8y8ADNZuwXI7P+tVmDz7AW72oa71DiyHAZyM+KFSxTNU3UxQIsw3IhTy3r
	 KapefYfyuz/Y6INPnnecGBN15YKbCIijwZgCI2aijbFiFRdo1XlJoQWvl0Y+JTbQvy
	 ySozI6NVt3iw2W+dzPfsX1aIGHTBHMHjNbPyz+VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com,
	Daniel Yang <danielyangkang@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1665/1887] exfat: resolve memory leak from exfat_create_upcase_table()
Date: Wed, 28 Oct 2026 18:02:41 +0100
Message-ID: <20261028170537.347277913@linuxfoundation.org>
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

From: Daniel Yang <danielyangkang@gmail.com>

[ Upstream commit c290fe508eee36df1640c3cb35dc8f89e073c8a8 ]

If exfat_load_upcase_table reaches end and returns -EINVAL,
allocated memory doesn't get freed and while
exfat_load_default_upcase_table allocates more memory, leading to a
memory leak.

Here's link to syzkaller crash report illustrating this issue:
https://syzkaller.appspot.com/text?tag=CrashReport&x=1406c201980000

Reported-by: syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com
Fixes: a13d1a4de3b0 ("exfat: move freeing sbi, upcase table and dropping nls into rcu-delayed helper")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 20dd3185d138 ("exfat: fix handling of damaged volume in exfat_create_upcase_table()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 0e05c6b5a2864..e027b34356969 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -785,8 +785,11 @@ int exfat_create_upcase_table(struct super_block *sb)
 				le32_to_cpu(ep->dentry.upcase.checksum));
 
 			brelse(bh);
-			if (ret && ret != -EIO)
+			if (ret && ret != -EIO) {
+				/* free memory from exfat_load_upcase_table call */
+				exfat_free_upcase_table(sbi);
 				goto load_default;
+			}
 
 			/* load successfully */
 			return ret;
-- 
2.53.0



