Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C828DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6bipm9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A7C433C7;
	Mon, 16 Oct 2023 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468116;
	bh=nxupJ6cgNl4jpoaayktBN5gTryxujA0Jkw1mRRy/XI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6bipm9bh+um3vzNc+VdV3PETSHTb9yxbsKLgldT9uVqlVmtk2sQtpCfGWqJl3W+j
	 zI1O7CXO5DIGIaw+RkxCYTjiNJ+SUzsrzA62IkvLL6AfcXDLyd+JvHW+5pRBZndPRo
	 zxGEjLZAPkHXsgMqB8/thVj8oSirksaDQ/6mJI1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.5 161/191] power: supply: qcom_battmgr: fix enable request endianness
Date: Mon, 16 Oct 2023 10:42:26 +0200
Message-ID: <20231016084019.133345271@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8894b432548851f705f72ff135d3dcbd442a18d1 upstream.

Add the missing endianness conversion when sending the enable request so
that the driver will work also on a hypothetical big-endian machine.

This issue was reported by sparse.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Cc: stable@vger.kernel.org	# 6.3
Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20230929101649.20206-1-johan+linaro@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index a05fd00711f6..ec163d1bcd18 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1282,9 +1282,9 @@ static void qcom_battmgr_enable_worker(struct work_struct *work)
 {
 	struct qcom_battmgr *battmgr = container_of(work, struct qcom_battmgr, enable_work);
 	struct qcom_battmgr_enable_request req = {
-		.hdr.owner = PMIC_GLINK_OWNER_BATTMGR,
-		.hdr.type = PMIC_GLINK_NOTIFY,
-		.hdr.opcode = BATTMGR_REQUEST_NOTIFICATION,
+		.hdr.owner = cpu_to_le32(PMIC_GLINK_OWNER_BATTMGR),
+		.hdr.type = cpu_to_le32(PMIC_GLINK_NOTIFY),
+		.hdr.opcode = cpu_to_le32(BATTMGR_REQUEST_NOTIFICATION),
 	};
 	int ret;
 
-- 
2.42.0



