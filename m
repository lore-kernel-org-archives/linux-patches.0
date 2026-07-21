Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E725436BC6;
	Tue, 21 Jul 2026 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663997; cv=none; b=QyHq2G+rwiBspPGkqsUPPHid0AmwaCtR3/iV9YmterpldNd79L1qDYusaAfY+kQjnYoUpFZCgR3wOZLxnPpDYj3pqCY2Ak2lfU27FpAARN9I1q8Uxk2R9Min1sLtmZN6kQgS/9Rml8tbRz2xZe0Em2INrj5w1CL4KqWf9Ra3pUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663997; c=relaxed/simple;
	bh=4aCZsgKjI37B4UlJU9DhghrPl4Mnemf6+ni6fmsNUvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTmF4TI+84YLJoRQxXqq+GpJt6rFw6k1UULUoC2QSkCcLkFX+qzc2d9hI66MnsO9akU3Og4Nrxuc8UfF1JjANl3jL/IH600qjPUQ9iwGiDuLspz8aM9fr3mzH8OKSKj2IPMS0oSDWTpH2ePoHJk10tUWOI3LOUvJjl5m2wFv1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML0cg9Jd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML0cg9Jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111B51F000E9;
	Tue, 21 Jul 2026 19:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663996;
	bh=DoP/V8fJnuMDGcn5Ms1LLQOzDFZb+lBQ1r6/W9zoNKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML0cg9JdofC+FeUmOEN41oiyq58LLyBXj7eudRKYkeBpbVQ7DcWU4Gx3+m8y8pLkn
	 AhHy1V6L9EFBTdOQy7dsw91p55EY4ZYwTy1IAn18TRuf9gCk5uPd+WNmhL4Iq0Iydh
	 5bougoHiwOz9mHYatuUELmgsqvfROL1Cnie5/vE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1034/1276] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Tue, 21 Jul 2026 17:24:37 +0200
Message-ID: <20260721152509.128943261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 411b8c4b274737c3bf08e1e025801161603cfffc upstream.

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1166,6 +1166,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


