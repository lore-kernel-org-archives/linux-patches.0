Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A125145336;
	Thu, 13 Jun 2024 11:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279735; cv=none; b=S+9Ri6qZWsZeSxubHdxEC6Jje9ULE6L3xyBS1+ynWcRaGwmcp3413mCLzb0jgGPRnxA3aGz0bOxiTTzzzjlP3K4dViQZg8zz9A3pt8M833ICEEKv9IQWBtMc2mWlDaBCLE4VKNfxxh7yO7DJ7tGMQdlHI3hb480UWgdvmdbGRjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279735; c=relaxed/simple;
	bh=ir1q+pBPWmSlMpEq8lbMBPzFcVE9dE7IAmofz1wDvHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PixQLyk7u255AXQNmw2PNNLSH0gQA43nnnAK+KHxzD/MHhk3G5LgxFZSsKImZSw8TpVrEW9HERbIxsdNZfBEutUWQ7Um9FQ3VmVpkqZDPPCG1eoqtfD0KoeIsX9C1R8S1Aknfr5jL4zmzlgPq2N6YaDN3ni1f/RE/ryoFslsT2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeSvwc4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeSvwc4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8350C2BBFC;
	Thu, 13 Jun 2024 11:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279735;
	bh=ir1q+pBPWmSlMpEq8lbMBPzFcVE9dE7IAmofz1wDvHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeSvwc4Th3V6ebDxKDwz4nB8X/6ZbN13MCcl4qLUMCLQ/IIMCCaK0HWT396CmEOqw
	 ezKsZtbV77hxfLtqD184BPW4DD8dmLQGjA2EjEjRKfif7y17xCkqCd7bKxO1oi27VK
	 uJ50LzKTJtuCsu++7aMxhgsZF7Du3i5fXuYD27wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.4 003/202] speakup: Fix sizeof() vs ARRAY_SIZE() bug
Date: Thu, 13 Jun 2024 13:31:41 +0200
Message-ID: <20240613113227.894288428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 008ab3c53bc4f0b2f20013c8f6c204a3203d0b8b upstream.

The "buf" pointer is an array of u16 values.  This code should be
using ARRAY_SIZE() (which is 256) instead of sizeof() (which is 512),
otherwise it can the still got out of bounds.

Fixes: c8d2f34ea96e ("speakup: Avoid crash on very long word")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/d16f67d2-fd0a-4d45-adac-75ddd11001aa@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -577,7 +577,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < ARRAY_SIZE(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


