Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1491C2AC;
	Wed,  3 Jan 2024 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsiBvFTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FEBC433C7;
	Wed,  3 Jan 2024 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301606;
	bh=gF40C3ZArQ3fEKzjmKH69t1CV36QWgaDKIT6+kOy4O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsiBvFTNpLzqd/cs2ZUPCdQSShUj5QnVPJpniKmCEn99oE8tLIbMtyYEweD4v+4op
	 od0cL+7VTVUvMQzeVHEL08bll+F7Qu3JC72Q6a4/3LVlptTsQrj9zA6z60v3+mE5ce
	 Iq3QIr549Fnq/l9A88wzKUpvEcQ3f5ZF/iKEhXpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 75/95] usb: fotg210-hcd: delete an incorrect bounds test
Date: Wed,  3 Jan 2024 17:55:23 +0100
Message-ID: <20240103164905.280009769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d9a3fd8af7a01..b0b6caaa29bd4 100644
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



