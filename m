Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D791465A8;
	Tue, 25 Jun 2024 09:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308842; cv=none; b=Gni0AvT0Lm2lphPc2Shix+87E0gCnSRjv0T1kzv+fPk4HlwmAnbpuRUEX0WxFqkrAjxBi38Ra07I0Z53jG+HdtbB7GkYy9XM8HUBBc9fF5Z66hw/PmCFZnMQL1hOtiI/zCS+RrGLwqL/14AFw2xFEHq7Rvzji8cX/naDYVb7ees=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308842; c=relaxed/simple;
	bh=+GKT+vakkKofrflvUtVbugUqlU0sF+4KS7xEN30b92E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFWFTSwU2MGZOE0R6grqhNqW3kn6S3htc6w+ZHgKuYJEI2NAhKEeBEEfWwxg4oj8VQF8NAdeeymbwgaSb/WlXQlM/w4AtNMCNjVaXe1wUua0F4mN0cOtA4U4o9gspM+FWYx9I4YjtV2FfTrFZIDUf4aZxvGLhuZMuwShcI0sgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0tsWXSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0tsWXSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD3C32786;
	Tue, 25 Jun 2024 09:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308842;
	bh=+GKT+vakkKofrflvUtVbugUqlU0sF+4KS7xEN30b92E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0tsWXSqVDhDQXvvutAxaYqYX0+TAFA+2ZxtPsdUPg+myQ5MBAavOnlfLUwPAvn0W
	 aisF3oca2Norzg0yYQGU0uFrBrzQfF1G23PPa30p7QVMbkOSobI/CYGo/ojrAnTsnD
	 7YAHgIi62RSn96bnVHNVd+EH5WtNO5t43ruE3hrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.9 229/250] i2c: ocores: set IACK bit after core is enabled
Date: Tue, 25 Jun 2024 11:33:07 +0200
Message-ID: <20240625085556.844452416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Tertychnyi <grembeter@gmail.com>

commit 5a72477273066b5b357801ab2d315ef14949d402 upstream.

Setting IACK bit when core is disabled does not clear the "Interrupt Flag"
bit in the status register, and the interrupt remains pending.

Sometimes it causes failure for the very first message transfer, that is
usually a device probe.

Hence, set IACK bit after core is enabled to clear pending interrupt.

Fixes: 18f98b1e3147 ("[PATCH] i2c: New bus driver for the OpenCores I2C controller")
Signed-off-by: Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ocores.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -442,8 +442,8 @@ static int ocores_init(struct device *de
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }


