Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751F828EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2094C433D2;
	Mon,  2 Jan 2023 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658922;
	bh=v0kGGHNNW8Opu5GPb0ENBLEfnSZTo+jwJLIuih8H7mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJJr4s4xbx3I5gfUzMxAAIdPKIsZvX+6dleNh3RKiemJOQfrQtRqtArrtLvgrFVdb
	 1G+4T6wgS9T1DxUvgKEp9WDOl3QjyzTiUS/qD7JUUfg4zw1i3P/h9vfBrVTqzyrrzX
	 DuyDKu+wCzfvI0CkfU3V+RCN5GtRKBxa18DYo6vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiujun Huang <hqjagain@gmail.com>,
	WeiXiong Liao <gmpy.liaowx@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 51/74] pstore/zone: Use GFP_ATOMIC to allocate zone buffer
Date: Mon,  2 Jan 2023 12:22:24 +0100
Message-Id: <20230102110554.271478079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiujun Huang <hqjagain@gmail.com>

commit 99b3b837855b987563bcfb397cf9ddd88262814b upstream.

There is a case found when triggering a panic_on_oom, pstore fails to dump
kmsg. Because psz_kmsg_write_record can't get the new buffer.

Handle this by using GFP_ATOMIC to allocate a buffer at lower watermark.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Fixes: 335426c6dcdd ("pstore/zone: Provide way to skip "broken" zone for MTD devices")
Cc: WeiXiong Liao <gmpy.liaowx@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/CAJRQjofRCF7wjrYmw3D7zd5QZnwHQq+F8U-mJDJ6NZ4bddYdLA@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/zone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -761,7 +761,7 @@ static inline int notrace psz_kmsg_write
 		/* avoid destroying old data, allocate a new one */
 		len = zone->buffer_size + sizeof(*zone->buffer);
 		zone->oldbuf = zone->buffer;
-		zone->buffer = kzalloc(len, GFP_KERNEL);
+		zone->buffer = kzalloc(len, GFP_ATOMIC);
 		if (!zone->buffer) {
 			zone->buffer = zone->oldbuf;
 			return -ENOMEM;


