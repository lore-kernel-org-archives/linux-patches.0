Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DD3337102;
	Fri, 17 Oct 2025 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712994; cv=none; b=rG0B5m9eTN2D2oM9er9lWPghG+Bo0OfMBYwIEYKJuNAAvUJM3C6RtJHvDH97tmPe3B86OO9srzIF6ehud7yjMaQN/azZErfEpDFGSrJ0JWNG5mWHgWliNln8GZ32X2mKvJRrqDUqXLcfVnjXaYdTLzuwwO71f1x0XHH7p9/pPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712994; c=relaxed/simple;
	bh=xrmuG3/euQ5s7ThyJI3vPqwDhYrg1lYjSDIjpQrOoD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVnRv9rGWhYRppaAfFC2yawQlNEHFbqHsEKJLR4N/s/VWskahfbn7ZRuhOz++xrg+oXfQvgmeNYYi6pRTJ4e2vyMKaKrLmItfDeZOUqfGc4TFJRCmTrDc9hlmA1g191sW80uuVQjh2KkyOeuK5oryzdqiuq+A+JjDRpS9uJO2Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+3vl8pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+3vl8pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D505C4CEE7;
	Fri, 17 Oct 2025 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760712993;
	bh=xrmuG3/euQ5s7ThyJI3vPqwDhYrg1lYjSDIjpQrOoD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+3vl8pMFilqpnVBUBc+X8NF6EQ4eWvAram0FnpqoygH0nHOTmEbzGNSxr9W3xnDD
	 5ts+wOQZC+VkHrIw4NXMVMGnE19tbFhQVY46BVl9VkYbTs+1kpOcJ9WfgNxZfmvzpF
	 8Xbt8eIHyjMUK0KHtRjMxDKB+FGhKxb1/+IzaSSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/168] rtc: optee: fix memory leak on driver removal
Date: Fri, 17 Oct 2025 16:51:30 +0200
Message-ID: <20251017145129.429682491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit a531350d2fe58f7fc4516e555f22391dee94efd9 ]

Fix a memory leak in case of driver removal.
Free the shared memory used for arguments exchanges between kernel and
OP-TEE RTC PTA.

Fixes: 81c2f059ab90 ("rtc: optee: add RTC driver for OP-TEE RTC PTA")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Link: https://lore.kernel.org/r/20250715-upstream-optee-rtc-v1-1-e0fdf8aae545@foss.st.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-optee.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
index 9f8b5d4a8f6b6..6b77c122fdc10 100644
--- a/drivers/rtc/rtc-optee.c
+++ b/drivers/rtc/rtc-optee.c
@@ -320,6 +320,7 @@ static int optee_rtc_remove(struct device *dev)
 {
 	struct optee_rtc *priv = dev_get_drvdata(dev);
 
+	tee_shm_free(priv->shm);
 	tee_client_close_session(priv->ctx, priv->session_id);
 	tee_client_close_context(priv->ctx);
 
-- 
2.51.0



