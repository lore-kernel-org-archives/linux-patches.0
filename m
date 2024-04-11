Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485056BB29;
	Thu, 11 Apr 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832328; cv=none; b=FuwV2VShnQdM/f2M4MqTEPWjH3N5Q9cfR5e2mRI8+5xq1a27Eixt0Ecb0GkNQUzxGGdCR2U6MgaoCPP+HCpVUZsNzoDQRzQIQxVsYqbiHqcOvp8nLk77qO8JD7ZlXK19yt1KJyGjW3taxccP5hPXkRG6ZK+eVFvBdxeXNR+B/Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832328; c=relaxed/simple;
	bh=W+JT74PLmwCkOXX545XBT2/AFroeXO0MCwlgZiifpPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcjzuxuCEfBneuzSnCCH97H4uEXT5eZnjEfy4GbJcMFOHKiQXGK9Sb4bcYltI1M8WovCG1U/vwfOXpcu1ZhUT28onT0Hk5+csExCBJgHkCCE67oRgi+n8pSZa83I8tyUIwdKGZsDBEg5kpPZllloZeBz0lo45r7KtEoKEySP8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcEoXMzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcEoXMzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596D9C433F1;
	Thu, 11 Apr 2024 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832327;
	bh=W+JT74PLmwCkOXX545XBT2/AFroeXO0MCwlgZiifpPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcEoXMzYWiKU5GJyrfFadTc3CEYhEiX2RpDNWLan4puq/ANL9igg84gmrw8LyZQSk
	 U5fu2pOfu2U20gdcCQmdbF+6HGoD15jPMBQNZM4Y/mV+2/h5kR3wyVMHxa+yNW6k9P
	 cZWbavvQIBbEifcaTm1+FfKDoPa1yfVFnGk48XfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/83] ionic: set adminq irq affinity
Date: Thu, 11 Apr 2024 11:56:44 +0200
Message-ID: <20240411095413.047495959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit c699f35d658f3c21b69ed24e64b2ea26381e941d ]

We claim to have the AdminQ on our irq0 and thus cpu id 0,
but we need to be sure we set the affinity hint to try to
keep it there.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index fcc3faecb0600..d33cf8ee7c336 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3216,9 +3216,12 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 
 	napi_enable(&qcq->napi);
 
-	if (qcq->flags & IONIC_QCQ_F_INTR)
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		irq_set_affinity_hint(qcq->intr.vector,
+				      &qcq->intr.affinity_mask);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_CLEAR);
+	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
-- 
2.43.0



