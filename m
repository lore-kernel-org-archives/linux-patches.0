Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EC19413B;
	Thu,  5 Sep 2024 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530367; cv=none; b=AYaRProeufcXZgWm1NdcGEWHufHp5EqTdEfEFiUmjt4VnA4WXfTsmv43hRtENF4uNfBU8yBn7+mS0C+lxmnwsruU6xCYq17R01hU61t3hwulEc/cQxbBieO/o3Mtiv/f2mxfnNeD4N4oxUPV091IXdyj1mnbSCADWjJtPq5dw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530367; c=relaxed/simple;
	bh=Z/ZIRusNI8gGMBdD1SbcA7UKTBqq4Hoy3KN0OxaSOJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU01DwvAmqXWJCq78lBIPzFo+rXsokSRKc4ZFMClbt6VRohRtiw6kyVrrM5p29E7yITBm+5mMX4/uHgru39sl7yJ9V1D5+Ar3MZHrSOVrgYWz25h3LJzjimPHpTn3oKwb6bXlYEkGFhfeFlKdIUAyGY9JxCCTmUa2cLwbyLU74w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtaewKJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtaewKJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207BBC4CEC3;
	Thu,  5 Sep 2024 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530366;
	bh=Z/ZIRusNI8gGMBdD1SbcA7UKTBqq4Hoy3KN0OxaSOJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtaewKJuREg4HRpZuXAbNlUXEPndJgIGJYHr4Q1ePwymxOgfQ5QT3sUrohi0IvfRr
	 IggW/yWby9g6AAujPit0r8CSER9DvNY6TIONAPcG3o5ey3aftPInuHVk57aGghybB+
	 1+1x3b5Vpq1VUBc8O61h6RQ1UJJjUvqvitCzA+mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/132] soc: qcom: smem: Add qcom_smem_bust_hwspin_lock_by_host()
Date: Thu,  5 Sep 2024 11:41:21 +0200
Message-ID: <20240905093725.900546578@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Chris Lew <quic_clew@quicinc.com>

[ Upstream commit 2e3f0d693875db698891ffe89a18121bda5b95b8 ]

Add qcom_smem_bust_hwspin_lock_by_host to enable remoteproc to bust the
hwspin_lock owned by smem. In the event the remoteproc crashes
unexpectedly, the remoteproc driver can invoke this API to try and bust
the hwspin_lock and release the lock if still held by the remoteproc
device.

Signed-off-by: Chris Lew <quic_clew@quicinc.com>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20240529-hwspinlock-bust-v3-3-c8b924ffa5a2@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c       | 26 ++++++++++++++++++++++++++
 include/linux/soc/qcom/smem.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index d4a89d2bb43b..2e8568d6cde9 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -359,6 +359,32 @@ static struct qcom_smem *__smem;
 /* Timeout (ms) for the trylock of remote spinlocks */
 #define HWSPINLOCK_TIMEOUT	1000
 
+/* The qcom hwspinlock id is always plus one from the smem host id */
+#define SMEM_HOST_ID_TO_HWSPINLOCK_ID(__x) ((__x) + 1)
+
+/**
+ * qcom_smem_bust_hwspin_lock_by_host() - bust the smem hwspinlock for a host
+ * @host:	remote processor id
+ *
+ * Busts the hwspin_lock for the given smem host id. This helper is intended
+ * for remoteproc drivers that manage remoteprocs with an equivalent smem
+ * driver instance in the remote firmware. Drivers can force a release of the
+ * smem hwspin_lock if the rproc unexpectedly goes into a bad state.
+ *
+ * Context: Process context.
+ *
+ * Returns: 0 on success, otherwise negative errno.
+ */
+int qcom_smem_bust_hwspin_lock_by_host(unsigned int host)
+{
+	/* This function is for remote procs, so ignore SMEM_HOST_APPS */
+	if (host == SMEM_HOST_APPS || host >= SMEM_HOST_COUNT)
+		return -EINVAL;
+
+	return hwspin_lock_bust(__smem->hwlock, SMEM_HOST_ID_TO_HWSPINLOCK_ID(host));
+}
+EXPORT_SYMBOL_GPL(qcom_smem_bust_hwspin_lock_by_host);
+
 /**
  * qcom_smem_is_available() - Check if SMEM is available
  *
diff --git a/include/linux/soc/qcom/smem.h b/include/linux/soc/qcom/smem.h
index a36a3b9d4929..03187bc95851 100644
--- a/include/linux/soc/qcom/smem.h
+++ b/include/linux/soc/qcom/smem.h
@@ -14,4 +14,6 @@ phys_addr_t qcom_smem_virt_to_phys(void *p);
 
 int qcom_smem_get_soc_id(u32 *id);
 
+int qcom_smem_bust_hwspin_lock_by_host(unsigned int host);
+
 #endif
-- 
2.43.0



