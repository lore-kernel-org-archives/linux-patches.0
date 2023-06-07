Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976163AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142E3C433EF;
	Wed,  7 Jun 2023 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169789;
	bh=+GYjT6NVH5CvFWzQZxXjeaEFx7QIGUI3NKsnc9Vmau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDYEA8tZkz9Z+mfTlFhZRyoDtxxihkCGjqhuSMvcTcGvaemm24zIbUeigkuG3oG/8
	 ZpZ/464XVBRALhHb2Lzc6JpgwfiQ3ReuHUEqvYYVukA+tW+6E6m2qluUddEofC1vwA
	 ed5Wrt6DFowm4LH1hfl4JJ2GU2c3gFweTGUpmaPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.3 214/286] misc: fastrpc: return -EPIPE to invocations on device removal
Date: Wed,  7 Jun 2023 22:15:13 +0200
Message-ID: <20230607200930.241137666@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Acayan <mailingradian@gmail.com>

commit b6a062853ddf6b4f653af2d8b75ba45bb9a036ad upstream.

The return value is initialized as -1, or -EPERM. The completion of an
invocation implies that the return value is set appropriately, but
"Permission denied" does not accurately describe the outcome of the
invocation. Set the invocation's return value to a more appropriate
"Broken pipe", as the cleanup breaks the driver's connection with rpmsg.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable <stable@kernel.org>
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230523152550.438363-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2337,8 +2337,10 @@ static void fastrpc_notify_users(struct
 	struct fastrpc_invoke_ctx *ctx;
 
 	spin_lock(&user->lock);
-	list_for_each_entry(ctx, &user->pending, node)
+	list_for_each_entry(ctx, &user->pending, node) {
+		ctx->retval = -EPIPE;
 		complete(&ctx->work);
+	}
 	spin_unlock(&user->lock);
 }
 


