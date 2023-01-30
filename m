Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561CE33CE
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C67C433EF;
	Mon, 30 Jan 2023 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088418;
	bh=JWV/LZ4M/HhUsHtYVWN7lXThWaXbYb+kb5ffyuLctmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYCdNgy2lH2kRh8V6ndlIN1w8/aZ9d/Q1sFcqhFgADIIa2mUNlf//xsf1dtX1WBVa
	 EgOslSUtHsQms6Hn6aXAaJ801a10zoJXA+OZGf4Q8hwZ/J/9h93RIeU78hD1wHCkuA
	 u7dlMxU9wWk/r6Lpf+cIN/VjkmAlOaIN7dk2M4Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/143] firmware: arm_scmi: Harden shared memory access in fetch_notification
Date: Mon, 30 Jan 2023 14:51:10 +0100
Message-Id: <20230130134307.424171008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 9bae076cd4e3e3c3dc185cae829d80b2dddec86e ]

A misbheaving SCMI platform firmware could reply with out-of-spec
notifications, shorter than the mimimum size comprising a header.

Fixes: d5141f37c42e ("firmware: arm_scmi: Add notifications support in transport layer")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 415ef7df8fc3..56a1f61aa3ff 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -71,8 +71,10 @@ void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 void shmem_fetch_notification(struct scmi_shared_mem __iomem *shmem,
 			      size_t max_len, struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	/* Skip only the length of header in shmem area i.e 4 bytes */
-	xfer->rx.len = min_t(size_t, max_len, ioread32(&shmem->length) - 4);
+	xfer->rx.len = min_t(size_t, max_len, len > 4 ? len - 4 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload, xfer->rx.len);
-- 
2.39.0



