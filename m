Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF8338F25;
	Tue, 16 Dec 2025 11:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884717; cv=none; b=sp86zxzZN8tiN+CMXzqNyUK3urnHi8YZdL3TBaM6pdaxgEFcD8fy1Dk0P8yY4U+PnlsCqeAX1UC2U0E1eQGRD6RdWYs9/M3A8wt80rt/tDDuk53w7Gnwjl/raOUesRIg2fmwYmAt60Uy2sujqhg1iKSg/ZVOVqvuT1ef5uj59ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884717; c=relaxed/simple;
	bh=8Pbgt+VOOFEAUniPS+AtJL/JHLSMBwFbAjwXAHcgqh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY4+Zw6fnqQLaRiXm3MEqMhkKiO9Y3ipNhgdJrujEDsk+suwKaZRwVKYN6Jm90bo4BwfA+OSlMpoUBpF1LjspopUHl+47UXqTJDtIdEENG7aYnaNPpL3uDWVJvapEcwebNHJiICDhrSt4dzTH4s5IotPu8Hd9rzRCWYKU1Sx2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rj2MX96Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rj2MX96Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E6C4CEF1;
	Tue, 16 Dec 2025 11:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884717;
	bh=8Pbgt+VOOFEAUniPS+AtJL/JHLSMBwFbAjwXAHcgqh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj2MX96Qkk/lVnooZz4HtM/x2/LLZCrMlBfEAAejswyql33Fqw4uy9XqsLPQQ3AjZ
	 YvQPkXgMotIhPbPcvMmAGLO5520EZJy1Z2meVGz08+Je0snOu69p3C4hEkpNDwMBSe
	 mZAuAoZNjmvO70GfBb5CdSxBok2ovDDtUOgKKb4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Gagniuc <mr.nuke.me@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/354] remoteproc: qcom_q6v5_wcss: fix parsing of qcom,halt-regs
Date: Tue, 16 Dec 2025 12:14:03 +0100
Message-ID: <20251216111330.914126114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

[ Upstream commit 7e81fa8d809ed1e67ae9ecd52d20a20c2c65d877 ]

The "qcom,halt-regs" consists of a phandle reference followed by the
three offsets within syscon for halt registers. Thus, we need to
request 4 integers from of_property_read_variable_u32_array(), with
the halt_reg ofsets at indexes 1, 2, and 3. Offset 0 is the phandle.

With MAX_HALT_REG at 3, of_property_read_variable_u32_array() returns
-EOVERFLOW, causing .probe() to fail.

Increase MAX_HALT_REG to 4, and update the indexes accordingly.

Fixes: 0af65b9b915e ("remoteproc: qcom: wcss: Add non pas wcss Q6 support for QCS404")
Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Link: https://lore.kernel.org/r/20251129013207.3981517-1-mr.nuke.me@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_wcss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_wcss.c b/drivers/remoteproc/qcom_q6v5_wcss.c
index e913dabae9924..c560b81b72631 100644
--- a/drivers/remoteproc/qcom_q6v5_wcss.c
+++ b/drivers/remoteproc/qcom_q6v5_wcss.c
@@ -85,7 +85,7 @@
 #define TCSR_WCSS_CLK_MASK	0x1F
 #define TCSR_WCSS_CLK_ENABLE	0x14
 
-#define MAX_HALT_REG		3
+#define MAX_HALT_REG		4
 enum {
 	WCSS_IPQ8074,
 	WCSS_QCS404,
@@ -864,9 +864,9 @@ static int q6v5_wcss_init_mmio(struct q6v5_wcss *wcss,
 		return -EINVAL;
 	}
 
-	wcss->halt_q6 = halt_reg[0];
-	wcss->halt_wcss = halt_reg[1];
-	wcss->halt_nc = halt_reg[2];
+	wcss->halt_q6 = halt_reg[1];
+	wcss->halt_wcss = halt_reg[2];
+	wcss->halt_nc = halt_reg[3];
 
 	return 0;
 }
-- 
2.51.0



