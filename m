Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC8D223338;
	Tue, 26 Aug 2025 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218596; cv=none; b=uDnwmGTSSa7lSlGeu8wWtuxvpA7xdzIp6Gj3DTFfbf+cNx8lTtmO/OLpyjgzuFowqvkdaKg/5z4TTo5hy1C/tQVxXK0BVpY9aGldiclXrVFkzB7y4XNBmZmMGE0bG8eLIycja6vNLmMvLG1DNVcUWmHkiLxAQuSm6mpeLAUzlW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218596; c=relaxed/simple;
	bh=smsbEMSMg9O8xl5Qg2wiuofZj0TPLGrZobyGHpYL9LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkRheVF2cUikdb7ttWf1kzdIcgueB+rgcbAIfoITD0WOkT+aG2W3RtbZV4Q1QCbUpTrVh3AaeNbfv/EjZSk3XRyGQWEDO9m+bMUDL55Gabb4csWASkCfP/KLpP4dGXEXFj58NRiz5an4ssy54Zv1nQMg6AJ9McVWgUxqJdrT5Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZZE9ZB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZZE9ZB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC15C4CEF1;
	Tue, 26 Aug 2025 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218596;
	bh=smsbEMSMg9O8xl5Qg2wiuofZj0TPLGrZobyGHpYL9LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZZE9ZB3rtQ4FAaBziJgb/HcPCMu5vXJxhJOcZZThgweXZD8/Fc1M7fNw3uHlv4jN
	 oGlZSBI5YVwcB8WL1z54BsYMVS3OiZ/8BjGyU7X+AOvlcv2XiVeXIgG6TIprpx06o1
	 FCYe6RfZ5cUuT8EAlENEpzkdWyHIqu4HHYCvAY5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 061/403] i2c: qup: jump out of the loop in case of timeout
Date: Tue, 26 Aug 2025 13:06:27 +0200
Message-ID: <20250826110907.551078643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yang Xiwen <forbidden405@outlook.com>

commit a7982a14b3012527a9583d12525cd0dc9f8d8934 upstream.

Original logic only sets the return value but doesn't jump out of the
loop if the bus is kept active by a client. This is not expected. A
malicious or buggy i2c client can hang the kernel in this case and
should be avoided. This is observed during a long time test with a
PCA953x GPIO extender.

Fix it by changing the logic to not only sets the return value, but also
jumps out of the loop and return to the caller with -ETIMEDOUT.

Fixes: fbfab1ab0658 ("i2c: qup: reorganization of driver code to remove polling for qup v1")
Signed-off-by: Yang Xiwen <forbidden405@outlook.com>
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250616-qca-i2c-v1-1-2a8d37ee0a30@outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -449,8 +449,10 @@ static int qup_i2c_bus_active(struct qup
 		if (!(status & I2C_STATUS_BUS_ACTIVE))
 			break;
 
-		if (time_after(jiffies, timeout))
+		if (time_after(jiffies, timeout)) {
 			ret = -ETIMEDOUT;
+			break;
+		}
 
 		usleep_range(len, len * 2);
 	}


