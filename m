Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6251EF08A;
	Tue,  3 Dec 2024 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236662; cv=none; b=drmMrVp391ZaMYguqpV4lJbcMTV5unmpAC6mZSqeYhNinyizlXGesqiUggxr7gSC9fldyD4ThVDaXRQ+pyOkMyQ7N1KJ/GUI2I4mlaIwAKMyCnFv/dtO8NuRr05g+Hy4JEZOArwXahjz1liU4REqnXbl4E/PudJypNVWZxcKtVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236662; c=relaxed/simple;
	bh=H/PL+a2rIw29rR2KlIwXt+s4JeYOnrjIT9xfKxiDAAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX8SfWvkJVxG1kpWhnklTOla4E6o3Qwqb5u54qclGxVDxuvbtja+NeuAFmlv1L+FO2wB4YmTrO8AlWEex54/ect9JU9zBnQ1k/uM2VFm5xPs745EwBJhkEr7Z0GYsYFWP/kLrMYUvmCoJFIT/1/9c024BMgeldmul75PT9kbpPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6ERelDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6ERelDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DEDC4CECF;
	Tue,  3 Dec 2024 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236662;
	bh=H/PL+a2rIw29rR2KlIwXt+s4JeYOnrjIT9xfKxiDAAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6ERelDQA4ucufaG6YmMwhU+x7zYUvFlOIhCaa7zfVw8wWqTkXf8n/0LP1V2P3BYb
	 97wfsFKLes2NtMjQpqRf+QGsgpiUlQoENAXHYybqDWzV+rHQCPXJwVhq5xgrepRFBv
	 iQUby5DvgvTw0azfBCjs9y1E37Ylz1bi6dDouEoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/138] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Tue,  3 Dec 2024 15:31:53 +0100
Message-ID: <20241203141926.782617253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d283d876d39ce..233975267f73c 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1045,7 +1045,8 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
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



