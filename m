Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601979CD;
	Sat, 30 Dec 2023 12:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+bKXxIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8231EC433C8;
	Sat, 30 Dec 2023 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938274;
	bh=0c5oREFeTedWJeRJVQ+PtB6DrnPEjoCCDjkb4EzNNbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+bKXxIWVK/UallKAcwBCV7NR8zmAKcPWxY5Kc28Fo5HU1I+JAGRTiqEHkUDRTFL/
	 t+E3PlqIJjwuU3Q0E37FZsdsOi6xV9B8OGjnNp/E7d5X4OGJXSXBy5PibPysT+3IxU
	 mc2X5Jed8rDWu1CNwytdCmuUfzlcbHRp7NMNm2Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.1 093/112] ubifs: fix possible dereference after free
Date: Sat, 30 Dec 2023 12:00:06 +0000
Message-ID: <20231230115809.797986161@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit d81efd66106c03771ffc8637855a6ec24caa6350 ]

'old_idx' could be dereferenced after free via 'rb_link_node' function
call.

Fixes: b5fda08ef213 ("ubifs: Fix memleak when insert_old_idx() failed")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 6b7d95b65f4b6..f4728e65d1bda 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -65,6 +65,7 @@ static void do_insert_old_idx(struct ubifs_info *c,
 		else {
 			ubifs_err(c, "old idx added twice!");
 			kfree(old_idx);
+			return;
 		}
 	}
 	rb_link_node(&old_idx->rb, parent, p);
-- 
2.43.0



