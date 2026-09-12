Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD88F421EFB;
	Sat, 12 Sep 2026 09:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206584; cv=none; b=HhYTvz+sKwNbnGS2LvAf25UeCcVnfk64Z4f0e9nBis+s4fzAsN3rljXWA8vsWL7uJM8YcolgvoqNoo6s0KBkBAcRjLw+MqXNQ5Xe4vjhQynh+wzU+WuVrEzlDus8VB0OkGhB/SP95v0y8URivs3hZvTQJxX8/aUMvcBG70PB+is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206584; c=relaxed/simple;
	bh=kks7R9GAvLMd3nbUNM3N2Bip71BV82Y9Klm9iBLkVRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMLHwrT/hCEKnquAzjnInR2Sj5WZBw9ESP39UaOQkHR7f27gIeargQiUbwFmR4OCBBE8aZXc/APYX41j7CBnE9cKCNh6v2kWXi2TtqVe3Uh6bt27fR0MPmJpJbnHEFrPwXyK+9zwklk+MlYoOzwEkXIZlWqqq8qqdHrRYM4eO0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHHDCYEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHHDCYEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0D1F000FF;
	Sat, 12 Sep 2026 09:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206582;
	bh=FZ4cfQbZ7ATETA7u3XnTlWSPhgLkE1WnOXElN9KQBNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHHDCYEHN87U1AfJog0oD6dHGNO4YFm6Ygm/JMPkzqRJsQHeMfXCUHBt6Fc5FaKi9
	 fOlxcOnkMSl/MwnSlHosktmWdccyYnWJ43ui3oKIkn9kVbZtvZxptr1rDrKK/37m5g
	 A23Bsmnihdh03gCQ/SfT3nF0lWBlV9DMyRDaS1f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0238/1518] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 08:40:07 +0200
Message-ID: <20260912065628.867100961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 602701718649936eb287bf6c7ecf870ec54c6f71 ]

In the msg_alloc_iov function, the iov pointer is only assigned to
msg->msg_iov after all memory allocations complete successfully.
Therefore, when a calloc failure triggers the unwind_iov cleanup branch,
we should use the local variable iov instead of msg->msg_iov.

Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20260707081434.539327-1-yangfeng59949@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 6879918a8cafb..f8b57f3c3f236 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -514,7 +514,7 @@ static int msg_alloc_iov(struct msghdr *msg,
 	return 0;
 unwind_iov:
 	for (i--; i >= 0 ; i--)
-		free(msg->msg_iov[i].iov_base);
+		free(iov[i].iov_base);
 	free(iov);
 	return -ENOMEM;
 }
-- 
2.53.0



