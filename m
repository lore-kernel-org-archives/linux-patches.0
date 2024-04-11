Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56166BB29;
	Thu, 11 Apr 2024 10:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832339; cv=none; b=uxquhXkUZ57PRunXM0uZF3zT4Z9tRT4+b4JZdkL4dUj59H9w5MqckqHOT8NhYQ2BlzoTQan5VS3BMW/nhDj8oLnIdprYW2JNv06TZ+zff2kqeudyUb1Fd6RwuwKrWBzu/atI7qlKg+CSoBTXlF95WLJboCZRBjFDC8xSd10OwPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832339; c=relaxed/simple;
	bh=B4GCfwbRznOKw4jbFK8H3zAHY6H/40s9bItlZRt1364=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qgn/MYyb31dEXc41/gYvTwkR1U+UyLH3LhNG+cd1gXbLIL84Mr/RRtsEaJRMcdGlc1KyZNe9AVmi0LrWpIDmwNCIIJ7R1Llg3KgnyKuoiTJpZmbTSrR0PJyjihGHn8EemT2gHFD0FV3Ld5DPb2dTsuou8P7OZmR1wBonpbGC/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGB+GSVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGB+GSVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356ABC433F1;
	Thu, 11 Apr 2024 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832339;
	bh=B4GCfwbRznOKw4jbFK8H3zAHY6H/40s9bItlZRt1364=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGB+GSVURxCUOLEcO0as2Q6YkWXyMg8o7lha8P/BQwoR8WVoO9ZGs1r5oFfdzFNjN
	 mR9K5Al91THH20FYACtk8lN2zxc6ggEJxZSfyGGMphea89MSWS2Xi9QR0nJ+MIvSVG
	 hvyLbvvzDpLGO5EwO1Pbis3wQBLxuv/xIKpjDOFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/83] pstore/zone: Add a null pointer check to the psz_kmsg_read
Date: Thu, 11 Apr 2024 11:56:48 +0200
Message-ID: <20240411095413.165854473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 98bc7e26e14fbb26a6abf97603d59532475e97f8 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118100206.213928-1-chentao@kylinos.cn
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/zone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index 2770746bb7aa1..abca117725c81 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -973,6 +973,8 @@ static ssize_t psz_kmsg_read(struct pstore_zone *zone,
 		char *buf = kasprintf(GFP_KERNEL, "%s: Total %d times\n",
 				      kmsg_dump_reason_str(record->reason),
 				      record->count);
+		if (!buf)
+			return -ENOMEM;
 		hlen = strlen(buf);
 		record->buf = krealloc(buf, hlen + size, GFP_KERNEL);
 		if (!record->buf) {
-- 
2.43.0



