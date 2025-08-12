Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5718FC91;
	Tue, 12 Aug 2025 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022128; cv=none; b=TToVcnENonOXm7VAYvNXdjuk7vg69vnrIYHYqbh2r2cnTa4URQsQ0ZN/UD/bloN6mxFW1Wsz8QYzYXkv1jH/Xsw5MZjmK81Zjl1qWbW1Gx0u3z0t0Yx7Ydm+2bcTCY8Ve7kuxn1tARvDovL5g4guClHuow7satHT+m0JnOIbM/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022128; c=relaxed/simple;
	bh=7VaMh0ye6W/oZ7jJRCRppNJKB9tm8Kk0PKJG4CX+kCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5gNhbI7h5M4GZzTfR8zTWhiNEtqEozoKUB+PhYnR/Xl6Qt9vPwCK7AymeX91Ty5eTdJ00Dkze5bICVdWDuRC1YPxuTcPRfZYdMWQtGkmqsSQ6LrMh6O2ZHsc/HK99+9uH4e96FVvtc/s3M17Ox2ZrcfaU442soZLWGHp1Rui9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXq2uECq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXq2uECq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73331C4CEF6;
	Tue, 12 Aug 2025 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022127;
	bh=7VaMh0ye6W/oZ7jJRCRppNJKB9tm8Kk0PKJG4CX+kCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXq2uECq+V99QKriyjdusq6nHByO5nx4Km059BTo23IXV0t2GuJ8+zmO8XxNAyhS0
	 1/Al1wGrBmS68JY5KUZqtPgu8bA1W/XKkd1CKRVDs/uo4OhV5ht7i1lxFsLB05EJBo
	 eCTJnkb0R7BEFN3TjR8LyqwFKz7p3ykybwNxuV1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/369] soc: qcom: pmic_glink: fix OF node leak
Date: Tue, 12 Aug 2025 19:25:59 +0200
Message-ID: <20250812173017.099262156@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 65702c3d293e45d3cac5e4e175296a9c90404326 ]

Make sure to drop the OF node reference taken when registering the
auxiliary devices when the devices are later released.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Cc: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250708085717.15922-1-johan@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index baa4ac6704a9..5963f49f6e6e 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -169,7 +169,10 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 	return 0;
 }
 
-static void pmic_glink_aux_release(struct device *dev) {}
+static void pmic_glink_aux_release(struct device *dev)
+{
+	of_node_put(dev->of_node);
+}
 
 static int pmic_glink_add_aux_device(struct pmic_glink *pg,
 				     struct auxiliary_device *aux,
@@ -183,8 +186,10 @@ static int pmic_glink_add_aux_device(struct pmic_glink *pg,
 	aux->dev.release = pmic_glink_aux_release;
 	device_set_of_node_from_dev(&aux->dev, parent);
 	ret = auxiliary_device_init(aux);
-	if (ret)
+	if (ret) {
+		of_node_put(aux->dev.of_node);
 		return ret;
+	}
 
 	ret = auxiliary_device_add(aux);
 	if (ret)
-- 
2.39.5



