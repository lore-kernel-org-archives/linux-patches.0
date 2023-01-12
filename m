Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FDC79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C30DC433F0;
	Thu, 12 Jan 2023 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533768;
	bh=v0kGGHNNW8Opu5GPb0ENBLEfnSZTo+jwJLIuih8H7mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHEU0THZypLSf1mFsU5LZ+lqma/K1KjRWzghbSJlY2OexnfwspQERLjMclU3B3CYn
	 O1LOFwT0heBtMjjZbqtb/PivE1jspGIlAp2L/M6Zjm0zEsU3fGBCTguv/Nrhx/khTd
	 vuGq5F3zIseitFyhw2DoNnNt5G0GWEGoPkZ4nQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiujun Huang <hqjagain@gmail.com>,
	WeiXiong Liao <gmpy.liaowx@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 585/783] pstore/zone: Use GFP_ATOMIC to allocate zone buffer
Date: Thu, 12 Jan 2023 14:55:01 +0100
Message-Id: <20230112135551.386734582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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


