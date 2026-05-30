Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B6A137750;
	Sat, 30 May 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166949; cv=none; b=Y6t4emE6et3dYpQ8eNANjA5M9kHw1cAg/0sLuhzPYCj82RCReaBqmE6VHRmzdlspn6G9evsiqIgJ7i2zOraR3qzvn2kmMId8Q4D6GFDhNbEDh1kx2m0ciKObBiUX8Rb0Xxjfat7Ctt6/Jy6t18msZLtwZ9LTcsmpntZxMaPwc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166949; c=relaxed/simple;
	bh=ZhFRo4HjPmorB1vLVak0Yj2CEo0pMrg5rj5bBXtZChE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtU/r9DZ0l4ej7SwV+hSdvI0UVfRlopRZDL2uncCgMdwAzNT+4m6oGWxjrm1YWz90aNvW8eQGSU/wPofP3VPwlToD61zDsmQZRmVdMHl/etzxXUZrEvi2xDpd7ryUuDWqq67B1xWMFDP1WVEmM8FgaDUb7ZwqHPTBskYVonDxMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1bddLX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1bddLX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AA51F00893;
	Sat, 30 May 2026 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166948;
	bh=TYBPkkIq+4fiNAXZQlF+0utg9qqp7vB+24BgbvJPTpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1bddLX6eOBHh7yvC8JXBwhi8L9fZC6pkc59EraFdsPsz22i48lUcN5l9Guw9zign
	 ISfYsnszVaoFdAlcQsJufcFvz1qhMHYDuw/xCUzY44w1oPd39Z6qTgferYybCbATE2
	 LCI8avrN0SAJJ/dBfAeYl8aW1EamCanNYo+wATfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 520/589] net/rds: reset op_nents when zerocopy page pin fails
Date: Sat, 30 May 2026 18:06:41 +0200
Message-ID: <20260530160238.286570069@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

commit e174929793195e0cd6a4adb0cad731b39f9019b4 upstream.

When iov_iter_get_pages2() fails in rds_message_zcopy_from_user(),
the pinned pages are released with put_page(), and
rm->data.op_mmp_znotifier is cleared.  But we fail to properly
clear rm->data.op_nents.

Later when rds_message_purge() is called from rds_sendmsg() the
cleanup loop iterates over the incorrectly non zero number of
op_nents and frees them again.

Fix this by properly resetting op_nents when it should be in
rds_message_zcopy_from_user().

Fixes: 0cebaccef3ac ("rds: zerocopy Tx support.")
Signed-off-by: Allison Henderson <achender@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260505234336.2132721-1-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/message.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -409,6 +409,7 @@ static int rds_message_zcopy_from_user(s
 
 			for (i = 0; i < rm->data.op_nents; i++)
 				put_page(sg_page(&rm->data.op_sg[i]));
+			rm->data.op_nents = 0;
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
 			mm_unaccount_pinned_pages(mmp);
 			ret = -EFAULT;


