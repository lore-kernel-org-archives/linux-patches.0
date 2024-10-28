Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7318E743;
	Mon, 28 Oct 2024 06:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097851; cv=none; b=Kzkv7/mfKD/i1yhNtXquoGlTZtufMhDsvCnwnERTXnTDE83TEKLfmm0Lzh0LOoVf2a6Qu1AMxqCU7Ybxro0NkQlY4JglerM1gbqq2KWm4wsPfAxJSCMTUbrefuhnYwoBbiy1Go0zR8FPRhzaV9SdbEJaXC4kdWaOwJ19TgrCaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097851; c=relaxed/simple;
	bh=Gq6uneiOL8AnpEeFeBGX6+JhVSPuTQDjTCXRrB7azyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzc1LIXkkO37B2Dv+I1sAhGDc3ihEWuWrVzpIG4ctKulciUKjfZc3KB7yVnb6VbgUOJdtCWRsJ3Q0aasPVCnm/MvCQvP9bIxXj+sq14dw+o3jh8q8Tz/4+Ey6nh2z40vuG6WxiBOu6lnU7DO21sJc8z7HKcBrZhdUj2dOY1waP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf5u9EYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf5u9EYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2671C4CEC3;
	Mon, 28 Oct 2024 06:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097851;
	bh=Gq6uneiOL8AnpEeFeBGX6+JhVSPuTQDjTCXRrB7azyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf5u9EYHSvNY4pg+JltoeUAEy4zHU6RNbrQJANPLWpqf/vpUyZmvFQ1IZ5/5COoSs
	 I/rb6Das9C2KBsIVa+WVTfglSngKHLvCFFX29PD3ALGJJ0+Hle0JttKA2WemBFOsRX
	 50xRWf9FlIUlkJpmnvFjYSKelcOZWGHkiIlFyU9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <make24@iscas.ac.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/208] smb: client: Handle kstrdup failures for passwords
Date: Mon, 28 Oct 2024 07:25:54 +0100
Message-ID: <20241028062310.917099455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 9a5dd61151399ad5a5d69aad28ab164734c1e3bc ]

In smb3_reconfigure(), after duplicating ctx->password and
ctx->password2 with kstrdup(), we need to check for allocation
failures.

If ses->password allocation fails, return -ENOMEM.
If ses->password2 allocation fails, free ses->password, set it
to NULL, and return -ENOMEM.

Fixes: c1eb537bf456 ("cifs: allow changing password during remount")
Reviewed-by: David Howells <dhowells@redhat.com
Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3bbac925d0766..8d7484400fe8e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -918,8 +918,15 @@ static int smb3_reconfigure(struct fs_context *fc)
 	else  {
 		kfree_sensitive(ses->password);
 		ses->password = kstrdup(ctx->password, GFP_KERNEL);
+		if (!ses->password)
+			return -ENOMEM;
 		kfree_sensitive(ses->password2);
 		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!ses->password2) {
+			kfree_sensitive(ses->password);
+			ses->password = NULL;
+			return -ENOMEM;
+		}
 	}
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
-- 
2.43.0



