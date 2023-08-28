Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF3D6FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6788CC433C8;
	Mon, 28 Aug 2023 10:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217714;
	bh=r55Hj/ejmPriEbiTbu7oXjdhVAoefAjFWdCIcbcqBBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8TIbI0LyjdByr+haEIp2+7GYWa5PvWL5Yiv/a/P9Q1wJG4Zhg/zhQjSt5XEDLjTQ
	 04IlgKoA99kUa/FQtApdBBtZYA1nnDMNDNXK9SUhelh7WcR8+JWAvbSGtgl/RBhm6J
	 b2leSJzhzxkLcjQc09hmdZtpqHmPGTnxjveEoa70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd311b1e43cc25f90d18@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/57] udf: Fix uninitialized array access for some pathnames
Date: Mon, 28 Aug 2023 12:12:26 +0200
Message-ID: <20230828101144.429038818@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
index 61a1738895b7a..ad04dc2278339 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -268,7 +268,7 @@ static int udf_name_from_CS0(uint8_t *str_o, int str_max_len,
 	}
 
 	if (translate) {
-		if (str_o_len <= 2 && str_o[0] == '.' &&
+		if (str_o_len > 0 && str_o_len <= 2 && str_o[0] == '.' &&
 		    (str_o_len == 1 || str_o[1] == '.'))
 			needsCRC = 1;
 		if (needsCRC) {
-- 
2.40.1



