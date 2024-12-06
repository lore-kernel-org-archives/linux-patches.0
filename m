Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D08E207E1E;
	Fri,  6 Dec 2024 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497740; cv=none; b=tHhCG2bQBYm0Ghk8GvYC5fXkr5+Nx8aPwlyflTghKvWr1JlU3l/CGBnw+jPFqqBmEIWo/A06dH6MbnXUM2oaGfsCR3YlPfdvV4Dz2+ftKH9KUPT9WLbRqwsbhoiefXuJbogBVjzWlapJCXSs7Q2ZCApPzlgU8VrcyXq7OYlDTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497740; c=relaxed/simple;
	bh=9d+yBdnwxxVUdsRRZsFornXUJmjhClRw1LVddO3LLFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqwm2N7fk6FR6nVL7OdBLPfrzQ/jcyh2bhgoDSdHK6t8UbFcuDi3pzlSNRbezyTCXqpbHQJjf1EcZneRLau9LndhB6PBajYigA7aUS36gyPwTszsehDMkISfUkxDHNC1zge/a10dX1PWB2l0YaSMImMCMaTibwXs8GXoS8emd1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbiWm8GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbiWm8GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF329C4CED1;
	Fri,  6 Dec 2024 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497740;
	bh=9d+yBdnwxxVUdsRRZsFornXUJmjhClRw1LVddO3LLFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbiWm8GWPWoSXfoSPDJ5V8S6eon7BDhKRs2zORU5Etq6WSF/0pM55hIlBFY4pjFJD
	 bVHjdyuz/+L0ma9yieE9UgoxfLXzE13qYXtEkbhnfNXrUwe45dfIlxXOwlep3UuOCn
	 D6IwnmHipHBFO0PSGjEX+oLHnO9v7f96a98Qw3Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/676] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Fri,  6 Dec 2024 15:33:17 +0100
Message-ID: <20241206143708.110895850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 06c59d97f63c1b8af521fa5aef8a716fb988b285 ]

The name len field of the CMD_OPEN packet is only 16-bits and the upper
16-bits of "param2" are a different "prio" field, which can be nonzero in
certain situations, and CMD_OPEN packets can be unexpectedly dropped
because of this.

Fix this by masking out the upper 16 bits of param2.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007235935.6216-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index d877a1a1aeb4b..c7f91a82e634f 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1117,7 +1117,8 @@ void qcom_glink_native_rx(struct qcom_glink *glink)
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
 		case GLINK_CMD_OPEN:
-			ret = qcom_glink_rx_defer(glink, param2);
+			/* upper 16 bits of param2 are the "prio" field */
+			ret = qcom_glink_rx_defer(glink, param2 & 0xffff);
 			break;
 		case GLINK_CMD_TX_DATA:
 		case GLINK_CMD_TX_DATA_CONT:
-- 
2.43.0



