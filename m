Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F67367B89;
	Thu, 30 Jul 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422854; cv=none; b=IupxbwRfb+uu15KPYvY6sM02HK4YUKm+EGkSvdRKr8E/0Obp0CEUo/pn20WHUKt1yQn17Nm4FAb0oTemolcLSv+qqKlHKtd24LYXxxzgwW6ii69xR6MNaGRZyIRZSdztGe8A3rmIWUoU54QWYhcq4KbXdCZQpFRb73tM0h0z8AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422854; c=relaxed/simple;
	bh=tYpUUoWwXZAlWo0S9VKU6EskNz/pE4KoAd4xlY3Wj08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVL+A/4JmX7SMGBnbER/FRy1+IWNrAlliJ10ZDGz/YdB9wE+b70uX9BkplL9pjyE+1uIJVbhNzhsDf42P1uKFcWJYicdkAEKeZUUmwULMuvpWRyMcfw8BQT4Diz2aGjy1kYVYEV20l0cQDYOnuFwj+DezEL3LDfkIgzDYVd0KpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILcJkIM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILcJkIM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE411F000E9;
	Thu, 30 Jul 2026 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422853;
	bh=29MC4bZIYsXwAX/RS+g6hL5yN03Bu4R+3cXt5tdQAd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILcJkIM9WwdvJkJANijtts/r7R0FoBzMc3rsD7hi5e4cSGD4SqzOm3vxPnGqkowT/
	 gnpjCYJhkeUhp8C1JMcYI4tCF3FpTY7dZ5PGraaGSoJkAYbRoTo5hdfAnLpW9Hvc9X
	 C/6oorQ1sSulCGS1liRJAVVCP5ZJHHlrUVlPIn10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.1 579/744] firmware: stratix10-svc: handle NO_RESPONSE in async poll
Date: Thu, 30 Jul 2026 16:14:12 +0200
Message-ID: <20260730141456.591943379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>

commit 9e1dc434ca708e1134332e45918935752f4410cd upstream.

Define INTEL_SIP_SMC_STATUS_NO_RESPONSE (0x3) and handle it in
stratix10_svc_async_poll() the same way as INTEL_SIP_SMC_STATUS_BUSY,
returning -EAGAIN so callers can retry instead of treating the poll as
a hard failure.

When the Secure Device Manager has not yet produced a response for an
asynchronous transaction, ATF is expected to return
INTEL_SIP_SMC_STATUS_NO_RESPONSE. Without this handling, the service
layer maps the status to -EINVAL and async clients cannot distinguish
"not ready yet" from a real error.

Fixes: bcb9f4f07061 ("firmware: stratix10-svc: Add support for async communication")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c             |    5 +++--
 include/linux/firmware/intel/stratix10-smc.h |    4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1487,8 +1487,9 @@ int stratix10_svc_async_poll(struct stra
 			WARN_ON_ONCE(1);
 		}
 		return 0;
-	} else if (handle->res.a0 == INTEL_SIP_SMC_STATUS_BUSY) {
-		dev_dbg(ctrl->dev, "async message is still in progress\n");
+	} else if (handle->res.a0 == INTEL_SIP_SMC_STATUS_BUSY ||
+		   handle->res.a0 == INTEL_SIP_SMC_STATUS_NO_RESPONSE) {
+		dev_dbg(ctrl->dev, "async message is not ready yet\n");
 		return -EAGAIN;
 	}
 
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -67,6 +67,9 @@
  * INTEL_SIP_SMC_STATUS_REJECTED:
  * Secure monitor software reject the service client's request.
  *
+ * INTEL_SIP_SMC_STATUS_NO_RESPONSE:
+ * Secure monitor software has no response for the request yet.
+ *
  * INTEL_SIP_SMC_STATUS_ERROR:
  * There is error during the process of service request.
  *
@@ -77,6 +80,7 @@
 #define INTEL_SIP_SMC_STATUS_OK				0x0
 #define INTEL_SIP_SMC_STATUS_BUSY			0x1
 #define INTEL_SIP_SMC_STATUS_REJECTED			0x2
+#define INTEL_SIP_SMC_STATUS_NO_RESPONSE		0x3
 #define INTEL_SIP_SMC_STATUS_ERROR			0x4
 #define INTEL_SIP_SMC_RSU_ERROR				0x7
 


