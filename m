Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FFD1BDFF;
	Wed,  3 Jan 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFtuZZp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490FFC433C7;
	Wed,  3 Jan 2024 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301949;
	bh=amxlM//yk3V75Dk33MiFlqeWwVOiEKnCg/Z2tcBKfOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFtuZZp7xn3dMMB4DFBWxswz8eSQIvR3HwDfRO3RdDmBZOd6k94ghPHol151lNye7
	 9cNZPqTZKZGB+f2QcDTdxzta+Fwn4qJlYkqW3bl7PzCra4VXnoPf5bpHiODxYDiwMt
	 Hljov0iusvSTeVULiUqoVDi2OcHoXOGfZAFyAa0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/75] usb: fotg210-hcd: delete an incorrect bounds test
Date: Wed,  3 Jan 2024 17:55:37 +0100
Message-ID: <20240103164851.586757876@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7fbcd195e2b8cc952e4aeaeb50867b798040314c ]

Here "temp" is the number of characters that we have written and "size"
is the size of the buffer.  The intent was clearly to say that if we have
written to the end of the buffer then stop.

However, for that to work the comparison should have been done on the
original "size" value instead of the "size -= temp" value.  Not only
will that not trigger when we want to, but there is a small chance that
it will trigger incorrectly before we want it to and we break from the
loop slightly earlier than intended.

This code was recently changed from using snprintf() to scnprintf().  With
snprintf() we likely would have continued looping and passed a negative
size parameter to snprintf().  This would have triggered an annoying
WARN().  Now that we have converted to scnprintf() "size" will never
drop below 1 and there is no real need for this test.  We could change
the condition to "if (temp <= 1) goto done;" but just deleting the test
is cleanest.

Fixes: 7d50195f6c50 ("usb: host: Faraday fotg210-hcd driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/ZXmwIwHe35wGfgzu@suswa
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index ff0b3457fd342..de925433d4c5f 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -429,8 +429,6 @@ static void qh_lines(struct fotg210_hcd *fotg210, struct fotg210_qh *qh,
 			temp = size;
 		size -= temp;
 		next += temp;
-		if (temp == size)
-			goto done;
 	}
 
 	temp = snprintf(next, size, "\n");
@@ -440,7 +438,6 @@ static void qh_lines(struct fotg210_hcd *fotg210, struct fotg210_qh *qh,
 	size -= temp;
 	next += temp;
 
-done:
 	*sizep = size;
 	*nextp = next;
 }
-- 
2.43.0



