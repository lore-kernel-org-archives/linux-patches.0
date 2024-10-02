Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631791D2234;
	Wed,  2 Oct 2024 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879042; cv=none; b=clF4glKGg745/qIXADDUSz/q4nkos9tbgMyeXtrVt8xmRedTGQL7oN5NYwGHK5JSuB82wxa7/tsPmNaYylG/q8S7qL496vMjgotAYsSX3hGtBCO5JBaXygCAZ23NuENivE7/qQ3JgHdALGagiGff2MoGkjyrbBB7VojMKvy8ess=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879042; c=relaxed/simple;
	bh=zlyhEvFma7U5uTCU06O3lJzMGVhmB4j4g1YdTMqL80A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbJZNBdhUk3n2CKbsOMNkSsIUQIWENQEDRzWIKkz5DZFdDwjsYBfFqXQcxGCGGPEseCYq2589dL8UBoU5oZJC4RHQuiBEfkgkhSv0JukSzzmte0mF9YYqUPD4iivC0S+3l236rOSWnj/luw7vliAHJzGan+vJbL1ggavi+dFLBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABjKwwP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABjKwwP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C9CC4CEC2;
	Wed,  2 Oct 2024 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879042;
	bh=zlyhEvFma7U5uTCU06O3lJzMGVhmB4j4g1YdTMqL80A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABjKwwP2GWXJtcLDkHpW4zFkfHHNylqay5lLYmDqOQ8Pk/VjSRz6SpoZZ6SaKhGsS
	 HxZkjiOMmPis2+fza7ErpyQhrbHdqzlwXRFrssRd2out+TxC4WqOK3brD034zSoCLW
	 L9jvViwS1HnxLSwuIQP+P1IlbdBHnQnRC99ZbAQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com,
	Daniel Yang <danielyangkang@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.10 619/634] exfat: resolve memory leak from exfat_create_upcase_table()
Date: Wed,  2 Oct 2024 15:01:59 +0200
Message-ID: <20241002125835.551323331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Yang <danielyangkang@gmail.com>

commit c290fe508eee36df1640c3cb35dc8f89e073c8a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/nls.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index afdf13c34ff5..1ac011088ce7 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -779,8 +779,11 @@ int exfat_create_upcase_table(struct super_block *sb)
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
2.46.2



