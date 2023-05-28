Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33D0611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E27C4339B;
	Sun, 28 May 2023 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301227;
	bh=ED7IjzAxUGMLvXXehsI2ODsAjynIgQI0BHZDdZbOvHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogmMolkIb7qgiQovtd0bJx0s6eyvmMEDSedZGO0Sbiv3Xj/2IQl/nDQCf72LnvN0u
	 jZSJoEP62TWb9qwXt2Evc6XRjnS4xhR/J+AvU0CrJQ6Mk+LcAuc+hrVrMXUZmdiIMD
	 m36U1tTD5dUGMutwJPZJ0mfoVSONshRgUyBT1JV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Zeng <zenghao@kylinos.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/86] recordmcount: Fix memory leaks in the uwrite function
Date: Sun, 28 May 2023 20:10:07 +0100
Message-Id: <20230528190829.812847465@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Zeng <zenghao@kylinos.cn>

[ Upstream commit fa359d068574d29e7d2f0fdd0ebe4c6a12b5cfb9 ]

Common realloc mistake: 'file_append' nulled but not freed upon failure

Link: https://lkml.kernel.org/r/20230426010527.703093-1-zenghao@kylinos.cn

Signed-off-by: Hao Zeng <zenghao@kylinos.cn>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 9012e33ae22f8..731600de03893 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -146,6 +146,7 @@ uwrite(int const fd, void const *const buf, size_t const count)
 {
 	size_t cnt = count;
 	off_t idx = 0;
+	void *p = NULL;
 
 	file_updated = 1;
 
@@ -153,7 +154,10 @@ uwrite(int const fd, void const *const buf, size_t const count)
 		off_t aoffset = (file_ptr + count) - file_end;
 
 		if (aoffset > file_append_size) {
-			file_append = realloc(file_append, aoffset);
+			p = realloc(file_append, aoffset);
+			if (!p)
+				free(file_append);
+			file_append = p;
 			file_append_size = aoffset;
 		}
 		if (!file_append) {
-- 
2.39.2



