Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66EF21E086;
	Thu, 12 Dec 2024 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017520; cv=none; b=kjNR1mn0HnI0VLX6igPrTlRvzeMowG+UdeF0Q07vcamKW4LNBvrYqc8zOIAl+61k0h6cki7umHv4foSRAoZuA4y23w05dv0qijRowqbkyOjK2fTTpKZZ5PqL6x/FkzNhfN+EKpt4TX78MnaVrFbZozYZvv9WH8hKAbMRlrv869k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017520; c=relaxed/simple;
	bh=il3BTeSmUWEGYD8ILBu8cVXC58gaRMyDY3RZz26HIxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL7RnTPi46U8/SMzTHsHE0Impq6RJG7CDO9B5H8YPjL80KyGMCkFk773H+dfNBnU5r6yKbawd/u0frEKteNPByRtARA4deD3BEUyEVXTPsebnox7BZKjiJv+nl1OP11sSXGfBOzAP2RKXd3e8R4GmFyF5i3jqlNYls2edGtTvwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlJQ9PxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlJQ9PxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3482AC4CED4;
	Thu, 12 Dec 2024 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017520;
	bh=il3BTeSmUWEGYD8ILBu8cVXC58gaRMyDY3RZz26HIxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlJQ9PxUeXo5m2GiGK9wW5s+8SFbRQwReEeq585ogu6nU9hpmHDmTAqSxd8jcmdng
	 ALBnAXFp+wAFBbb/0DONrYNPKeOcAChKRSoPGMpgohNhMgnWAAcIOahU5aonhGj+sU
	 hyAzOzZ/vJK8fgGHBUX5d1UTt6hdvHExgj1ElC9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH 6.6 037/356] net/smc: define a reserved CHID range for virtual ISM devices
Date: Thu, 12 Dec 2024 15:55:56 +0100
Message-ID: <20241212144246.092807870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 8dd512df3c98ce8081e3541990bf849157675723 ]

According to virtual ISM support feature defined by SMCv2.1, CHIDs in
the range 0xFF00 to 0xFFFF are reserved for use by virtual ISM devices.

And two helpers are introduced to distinguish virtual ISM devices from
the existing platform firmware ISM devices.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-and-tested-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0541db8ee32c ("net/smc: initialize close_work early to avoid warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ism.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 832b2f42d79f3..d1228a615f23c 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -15,6 +15,8 @@
 
 #include "smc.h"
 
+#define SMC_VIRTUAL_ISM_CHID_MASK	0xFF00
+
 struct smcd_dev_list {	/* List of SMCD devices */
 	struct list_head list;
 	struct mutex mutex;	/* Protects list of devices */
@@ -56,4 +58,22 @@ static inline int smc_ism_write(struct smcd_dev *smcd, u64 dmb_tok,
 	return rc < 0 ? rc : 0;
 }
 
+static inline bool __smc_ism_is_virtual(u16 chid)
+{
+	/* CHIDs in range of 0xFF00 to 0xFFFF are reserved
+	 * for virtual ISM device.
+	 *
+	 * loopback-ism:	0xFFFF
+	 * virtio-ism:		0xFF00 ~ 0xFFFE
+	 */
+	return ((chid & 0xFF00) == 0xFF00);
+}
+
+static inline bool smc_ism_is_virtual(struct smcd_dev *smcd)
+{
+	u16 chid = smcd->ops->get_chid(smcd);
+
+	return __smc_ism_is_virtual(chid);
+}
+
 #endif
-- 
2.43.0



