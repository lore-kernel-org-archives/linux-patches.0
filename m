Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C4E3E0091;
	Thu, 30 Jul 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425208; cv=none; b=qZXaJh6vPGCt78Ak9JmFo+UmBCOgXcfrGKySyYdla9phrqnudny94na42Gm45LdF0S3como9QKl3MaJMbACHVwZISEXOCKTiQVQ/ilfZm1UnYh9T+SqAit62f1Mqqk+MRxhW6XqrH+ZO2OJCFQs3L85IOMRpSzjkSTdsQBE5QxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425208; c=relaxed/simple;
	bh=nMaLwKJVnq2qY32T2v1GgSql/YSjUGdpR5goZUYi/yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEU4l6d9iOburIut+bf/W5wLZorLAHVd63KB8S97mCWbbpQcp/4K5YGL6nQg6S48jm/vxaBe2rW6j2AxEe0wZQ1wfsRXaVDNjLzJ+VtK5oV07wAWFjGZs3PhOa6RQ2f5SKMI5Exn1oMBv7dqpcEbT1Wu8/hKtltLDVCwhOpXTJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPqp7Rfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPqp7Rfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE4E1F00A3D;
	Thu, 30 Jul 2026 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425207;
	bh=RxRbJUnORBWAGKNrEvgG2zCCTg+9o+NJ3uWq1R8E8iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPqp7RfbvayldCWxaIrjEYXwTvMwXQWxj4mMa1iU4vnif6PT/IXNbBNIwKRVee4KL
	 +cr7POgdmtHzvPqQi7dk75KEnKdHj67cNwvfKdWAprxTSwOEmTvPp+/BIvgKbe2J8e
	 AxMjtRuB5oAhHZsKnQViWO8tqVibebNwEM0lgUyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 662/675] net: ipa: fix SMEM state handle leaks in SMP2P init
Date: Thu, 30 Jul 2026 16:16:32 +0200
Message-ID: <20260730141459.221926888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 96ca1e658ae459276292bd6d971ab5d8c7e0379a ]

ipa_smp2p_init() acquires two Qualcomm SMEM state handles with
qcom_smem_state_get(). However, neither the init error paths
nor ipa_smp2p_exit() release them.

Release both handles with qcom_smem_state_put() in the init
error paths and in ipa_smp2p_exit().

Fixes: 530f9216a953 ("soc: qcom: ipa: AP/modem communications")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260624065955.2822765-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ kzalloc_obj() context line kept as kzalloc(sizeof(*smp2p), GFP_KERNEL) since ipa_smp2p.c was not yet converted in this tree ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_smp2p.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -234,19 +234,27 @@ ipa_smp2p_init(struct ipa *ipa, struct p
 					  &valid_bit);
 	if (IS_ERR(valid_state))
 		return PTR_ERR(valid_state);
-	if (valid_bit >= 32)		/* BITS_PER_U32 */
-		return -EINVAL;
+	if (valid_bit >= 32) {		/* BITS_PER_U32 */
+		ret = -EINVAL;
+		goto err_valid_state_put;
+	}
 
 	enabled_state = qcom_smem_state_get(dev, "ipa-clock-enabled",
 					    &enabled_bit);
-	if (IS_ERR(enabled_state))
-		return PTR_ERR(enabled_state);
-	if (enabled_bit >= 32)		/* BITS_PER_U32 */
-		return -EINVAL;
+	if (IS_ERR(enabled_state)) {
+		ret = PTR_ERR(enabled_state);
+		goto err_valid_state_put;
+	}
+	if (enabled_bit >= 32) {		/* BITS_PER_U32 */
+		ret = -EINVAL;
+		goto err_enabled_state_put;
+	}
 
 	smp2p = kzalloc(sizeof(*smp2p), GFP_KERNEL);
-	if (!smp2p)
-		return -ENOMEM;
+	if (!smp2p) {
+		ret = -ENOMEM;
+		goto err_enabled_state_put;
+	}
 
 	smp2p->ipa = ipa;
 
@@ -291,6 +299,10 @@ err_null_smp2p:
 	ipa->smp2p = NULL;
 	mutex_destroy(&smp2p->mutex);
 	kfree(smp2p);
+err_enabled_state_put:
+	qcom_smem_state_put(enabled_state);
+err_valid_state_put:
+	qcom_smem_state_put(valid_state);
 
 	return ret;
 }
@@ -307,6 +319,8 @@ void ipa_smp2p_exit(struct ipa *ipa)
 	ipa_smp2p_power_release(ipa);
 	ipa->smp2p = NULL;
 	mutex_destroy(&smp2p->mutex);
+	qcom_smem_state_put(smp2p->enabled_state);
+	qcom_smem_state_put(smp2p->valid_state);
 	kfree(smp2p);
 }
 


