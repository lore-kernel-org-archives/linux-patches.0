Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC23D890F;
	Wed,  8 Apr 2026 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674523; cv=none; b=IGCL//6wRgytvbOMLefd5P5IDN2/N7wiUzwSvoSvjKhrEBpz75D7uCiDzw+PlZps7IE+e3qNAlMRjFJl0eMf79wGuhwE5yFTuX/iXNlMqi1Iz6DdUggk6o1HN0BqvXxatmAPChrNLF6/kgCy7LWU+3wvOqK+ZpnFUovedtOqGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674523; c=relaxed/simple;
	bh=vtYf55mbrMlDJiqW0N+QeI7OdHU58iJDLJJiy9x/PK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lT5oRty5xywMtVqCBcTlLOc7CramX8+3uuDoNQ9xT6wuOZl0DTO9V506wC69tExnyjghzE+P+ORyzMDNHz6MjgkjXwmjQkZUz6eh3L39V+f/ge/xBCY2yUcAGQHUenAJKXSv91sOOyqB/jaTi7hjDrz6X9FvrnESk2++otTnZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkY4eftl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkY4eftl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2C8C19421;
	Wed,  8 Apr 2026 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674523;
	bh=vtYf55mbrMlDJiqW0N+QeI7OdHU58iJDLJJiy9x/PK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkY4eftlzstToIESXTqauwluBnXUm7vk+FPI5N2WtPLW5kE+Ug3ZrnPU8/P6OnAuk
	 OBteKn4nPIRoB6dmrEsZrWWiuRqj61dMj2W9MPmxbL/ct7X6U0Ir+pH18WhVbtle4Y
	 XJTRtVwxgF3O5QqCAii7Nf9SuY1Kf6N3JHvvUBPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 130/311] interconnect: qcom: sm8450: Fix NULL pointer dereference in icc_link_nodes()
Date: Wed,  8 Apr 2026 20:02:10 +0200
Message-ID: <20260408175944.270452552@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit dbbd550d7c8d90d3af9fe8a12a9caff077ddb8e3 ]

The change to dynamic IDs for SM8450 platform interconnects left two links
unconverted, fix it to avoid the NULL pointer dereference in runtime,
when a pointer to a destination interconnect is not valid:

    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
    <...>
    Call trace:
      icc_link_nodes+0x3c/0x100 (P)
      qcom_icc_rpmh_probe+0x1b4/0x528
      platform_probe+0x64/0xc0
      really_probe+0xc4/0x2a8
      __driver_probe_device+0x80/0x140
      driver_probe_device+0x48/0x170
      __device_attach_driver+0xc0/0x148
      bus_for_each_drv+0x88/0xf0
      __device_attach+0xb0/0x1c0
      device_initial_probe+0x58/0x68
      bus_probe_device+0x40/0xb8
      deferred_probe_work_func+0x90/0xd0
      process_one_work+0x15c/0x3c0
      worker_thread+0x2e8/0x400
      kthread+0x150/0x208
      ret_from_fork+0x10/0x20
     Code: 900310f4 911d6294 91008280 94176078 (f94002a0)
     ---[ end trace 0000000000000000 ]---
     Kernel panic - not syncing: Oops: Fatal exception

Fixes: 51513bec806f ("interconnect: qcom: sm8450: convert to dynamic IDs")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://msgid.link/20260314012933.350644-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8450.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/sm8450.c b/drivers/interconnect/qcom/sm8450.c
index 669a638bf3efc..c88327d200acc 100644
--- a/drivers/interconnect/qcom/sm8450.c
+++ b/drivers/interconnect/qcom/sm8450.c
@@ -800,7 +800,7 @@ static struct qcom_icc_node qhs_compute_cfg = {
 	.channels = 1,
 	.buswidth = 4,
 	.num_links = 1,
-	.link_nodes = { MASTER_CDSP_NOC_CFG },
+	.link_nodes = { &qhm_nsp_noc_config },
 };
 
 static struct qcom_icc_node qhs_cpr_cx = {
@@ -874,7 +874,7 @@ static struct qcom_icc_node qhs_lpass_cfg = {
 	.channels = 1,
 	.buswidth = 4,
 	.num_links = 1,
-	.link_nodes = { MASTER_CNOC_LPASS_AG_NOC },
+	.link_nodes = { &qhm_config_noc },
 };
 
 static struct qcom_icc_node qhs_mss_cfg = {
-- 
2.53.0



