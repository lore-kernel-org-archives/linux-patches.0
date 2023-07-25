Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D215ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF60C433C9;
	Tue, 25 Jul 2023 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282873;
	bh=ETzuIC8ObwuLLILZNvn14f5dGys2rt/zxF6Qv8PATEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkKUE26pea9S2jU7Rd3W+HtgVSfPRhCbJ77RH2BjWlCGq8YqrqINsH41H7jooHFqz
	 g6KfsC37lT2UXb0Nv6/ZL47ozOjZo8sUSmOG5AxbfYTBYfq8IsF7YS2lvKkpD9o33L
	 VaHEZYuZAx5vYgNS5/3XE9DJ+EsLFgDkhsqi6SPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd311b1e43cc25f90d18@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/183] [PATCH AUTOSEL 4.19 07/11] udf: Fix uninitialized array access for some pathnames
Date: Tue, 25 Jul 2023 12:44:45 +0200
Message-ID: <20230725104510.029783345@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 028f6055c912588e6f72722d89c30b401bbcf013 ]

For filenames that begin with . and are between 2 and 5 characters long,
UDF charset conversion code would read uninitialized memory in the
output buffer. The only practical impact is that the name may be prepended a
"unification hash" when it is not actually needed but still it is good
to fix this.

Reported-by: syzbot+cd311b1e43cc25f90d18@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000e2638a05fe9dc8f9@google.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/unicode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 5fcfa96463ebb..85521d6b02370 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -247,7 +247,7 @@ static int udf_name_from_CS0(struct super_block *sb,
 	}
 
 	if (translate) {
-		if (str_o_len <= 2 && str_o[0] == '.' &&
+		if (str_o_len > 0 && str_o_len <= 2 && str_o[0] == '.' &&
 		    (str_o_len == 1 || str_o[1] == '.'))
 			needsCRC = 1;
 		if (needsCRC) {
-- 
2.39.2



