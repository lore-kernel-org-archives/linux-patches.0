Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90BE2EAE5;
	Thu, 11 Apr 2024 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832189; cv=none; b=pE4fPTFfmzPIofC75HLOsHy0KnOCitfr5LhBD3gms1UuDKhg0JkZRk7OZoqsElxKoZQyOQyhS3zed2lX2i0m5g8bA2sXGq5g6XwPHjBSJ+zelCk0iwkTvTtO11UX6/NzUyBu1QKBNoDntdZw8JoSMo51MT1iV7iZLMIU0Nf+jKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832189; c=relaxed/simple;
	bh=KMUTfiKxC85lXeCSWJ+iMGBSkkOZ8FIjjkMjmt3/Pss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUPYH1wcMjUOA3Co+HBYNg+DSLwk7aaMwiQvXV3gzJtM31U/kf6dH/wBLc0J1Bf8PwAeuoPHQt3P0pQjnBDXlfoJLRr3j3nyItljRFslm2JMWVzsH6VXYR3PLUq2lJilMrzWMzKuSW6aZtfePG2s/M4n9fRmJPu8ChRSbzeV78s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHBPYm2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHBPYm2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01DEC433F1;
	Thu, 11 Apr 2024 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832189;
	bh=KMUTfiKxC85lXeCSWJ+iMGBSkkOZ8FIjjkMjmt3/Pss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHBPYm2peWDNDZS9ZvO6pNrOUGfUItkej5mYnZojX7TOac0g9NoLp05VhVhFp/MVz
	 3cRfR1EAOs4wjyttFtsZHxM4aq5+yD+1oJZouQPjy173/zIA5Hlmi9YDqGE7n7FglE
	 KzFA0VTAxdAO/z1d45ZEB01Zs7EwfTwl2aG2wRtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/294] Input: synaptics-rmi4 - fail probing if memory allocation for "phys" fails
Date: Thu, 11 Apr 2024 11:57:01 +0200
Message-ID: <20240411095443.331024277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit bc4996184d56cfaf56d3811ac2680c8a0e2af56e ]

While input core can work with input->phys set to NULL userspace might
depend on it, so better fail probing if allocation fails. The system must
be in a pretty bad shape for it to happen anyway.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240117073124.143636-1-chentao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_driver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 258d5fe3d395c..aa32371f04af6 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -1196,7 +1196,11 @@ static int rmi_driver_probe(struct device *dev)
 		}
 		rmi_driver_set_input_params(rmi_dev, data->input);
 		data->input->phys = devm_kasprintf(dev, GFP_KERNEL,
-						"%s/input0", dev_name(dev));
+						   "%s/input0", dev_name(dev));
+		if (!data->input->phys) {
+			retval = -ENOMEM;
+			goto err;
+		}
 	}
 
 	retval = rmi_init_functions(data);
-- 
2.43.0



