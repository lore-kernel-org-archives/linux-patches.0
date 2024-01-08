Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5A247791;
	Mon,  8 Jan 2024 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er5b2sW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B113C433C7;
	Mon,  8 Jan 2024 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726591;
	bh=16AiM4KTV7NaOSmKO4ntlCqrAzvPKnenBQd83g3+DKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er5b2sW8ox8qh+Dd/M3BWfj7r6+28AcvIhuhYhTkHqLUzxW45cULJ+IgBRUyBKEWB
	 eh8oc5bpRu4X4PZKQzuznV/FU7h7zmjJ6Nk1/xSF47gmRIDlD1MGHQO0Aj7YnGW7zU
	 5ccF4t6g+Lp4SZDyYLpjsLVTje0hA6QPqHispG0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/124] accel/qaic: Implement quirk for SOC_HW_VERSION
Date: Mon,  8 Jan 2024 16:07:22 +0100
Message-ID: <20240108150603.723616016@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

[ Upstream commit 4c8874c2a6512b9fe7285cab1a6910d9211a6cfb ]

The SOC_HW_VERSION register in the BHI space is not correctly initialized
by the device and in many cases contains uninitialized data. The register
could contain 0xFFFFFFFF which is a special value to indicate a link
error in PCIe, therefore if observed, we could incorrectly think the
device is down.

Intercept reads for this register, and provide the correct value - every
production instance would read 0x60110200 if the device was operating as
intended.

Fixes: a36bf7af868b ("accel/qaic: Add MHI controller")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231208163101.1295769-3-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/mhi_controller.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/mhi_controller.c b/drivers/accel/qaic/mhi_controller.c
index 5036e58e7235b..1405623b03e4e 100644
--- a/drivers/accel/qaic/mhi_controller.c
+++ b/drivers/accel/qaic/mhi_controller.c
@@ -404,8 +404,21 @@ static struct mhi_controller_config aic100_config = {
 
 static int mhi_read_reg(struct mhi_controller *mhi_cntrl, void __iomem *addr, u32 *out)
 {
-	u32 tmp = readl_relaxed(addr);
+	u32 tmp;
 
+	/*
+	 * SOC_HW_VERSION quirk
+	 * The SOC_HW_VERSION register (offset 0x224) is not reliable and
+	 * may contain uninitialized values, including 0xFFFFFFFF. This could
+	 * cause a false positive link down error.  Instead, intercept any
+	 * reads and provide the correct value of the register.
+	 */
+	if (addr - mhi_cntrl->regs == 0x224) {
+		*out = 0x60110200;
+		return 0;
+	}
+
+	tmp = readl_relaxed(addr);
 	if (tmp == U32_MAX)
 		return -EIO;
 
-- 
2.43.0



