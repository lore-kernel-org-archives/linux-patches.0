Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626013FD94;
	Thu, 11 Apr 2024 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831190; cv=none; b=KKSYjwz8ajnc0vnXFHdZ5r5nz5Z1G7r/ZoeD/2a95BfA3G8ORTrcmBQBgOO1NLoB6ZNLRUOqvQATijsXzQJ/ama5aqF9cE2Y92YhxzVNNMW7I2MedEqUU4rHb8ciyZpaiYk+KR6TeexeAAR0GXO3Zl05RIgWOUMK/L9wDFEvbbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831190; c=relaxed/simple;
	bh=dc7Ii/NEqsqNS8O3DMcEw34zeALAg2bumrEjymaIm04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEw4eXsrJM/YazeI9mlpo66YKIdT1K2WY31se9yRGphYhDcOClp5fHH4ON67lfErN9UFNYLpJOGiiWn2a/uPXYIGrL8FoRkmoOFl77uVGeZMtnaKPn1mK4UYiKcwiHC/Eb1yeHth/KA5N6JFAHmnw4pLJplwm9UAuNRMMpjo2Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTpa7FT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTpa7FT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECDBC433F1;
	Thu, 11 Apr 2024 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831190;
	bh=dc7Ii/NEqsqNS8O3DMcEw34zeALAg2bumrEjymaIm04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTpa7FT0rsm8UYmbT+Sc04IdzzOdibYLuNkNURp1mzB+Vu3mKmTvgK5bqnpKPFR1P
	 ps5aqdFgKV4noF2hWwJfz+GPOTsp04fsqew7Alc6O/QEKb0r9MZEM9wUZxYCoPlksz
	 JdKiKLlt/vIUE6DOOVdUuKJ6+gdA5UjEP52Dz9FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/114] ionic: set adminq irq affinity
Date: Thu, 11 Apr 2024 11:55:48 +0200
Message-ID: <20240411095417.508920247@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index adb0f9b01bb1e..4f05cddc65cb4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3468,9 +3468,12 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 
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



