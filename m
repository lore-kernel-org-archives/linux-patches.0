Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397001BE22B;
	Tue,  2 Jul 2024 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940987; cv=none; b=u2fUr51LY/Slhb6hC/j0IIImsVCl3N5yIhKdETF2B/z4QUCBbzjHId9K0bboYPr7nx2aGPqt5SMRbfdqAzqEKrofTTXNGmozI2HyS4pW+iyWXEQCXnkGnjBB1NmnV7FVfGcVQy08822hHw7/JBpXL7vNCUsPLJ0SCr+WnA3bRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940987; c=relaxed/simple;
	bh=GXd/O8pMvX41qJeO3Trh/MiSOSIEKUY4O6+CDre+na8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3CVxjBLmsOO//EbkjioNl71aOiBV67Xw/BpGRyCZgxgZuXFWFNGv9AgNDOs+V6rS8MC70fnVrrJCnxsjEfrGYNiZZgD9rMUCCr/bptwLuu/ofT7MYy9Q5ZanvdfPO6cUKflX+LplkJDpQCp1Xxnf+xR47RFdczvUS26HXj4Dak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+wt2ROo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+wt2ROo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F8AC4AF0D;
	Tue,  2 Jul 2024 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940987;
	bh=GXd/O8pMvX41qJeO3Trh/MiSOSIEKUY4O6+CDre+na8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+wt2ROosX+/TcZuOyAmzcAXaRg/W3D37HuE8JXZvG1wnFPLuKVswuSO8jOfdPdZa
	 JTjZiF/rIi8sZSbmpgmw7x6OVmtFc2C9C9sWNriL7HOdNPY4hlBmBric1c9tbSumTF
	 g+a3fUJs3AUvC7aVn0iZXVH8vI2dqrlegteNvlMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/163] i2c: testunit: discard write requests while old command is running
Date: Tue,  2 Jul 2024 19:03:29 +0200
Message-ID: <20240702170236.659813167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c116deafd1a5cc1e9739099eb32114e90623209c ]

When clearing registers on new write requests was added, the protection
for currently running commands was missed leading to concurrent access
to the testunit registers. Check the flag beforehand.

Fixes: b39ab96aa894 ("i2c: testunit: add support for block process calls")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index a5dcbc3c2c141..ca43e98cae1b2 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -121,6 +121,9 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		break;
 
 	case I2C_SLAVE_WRITE_REQUESTED:
+		if (test_bit(TU_FLAG_IN_PROCESS, &tu->flags))
+			return -EBUSY;
+
 		memset(tu->regs, 0, TU_NUM_REGS);
 		tu->reg_idx = 0;
 		break;
-- 
2.43.0



