Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E834D4E4;
	Tue, 16 Dec 2025 11:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885580; cv=none; b=oyXUcbPUG+cBZrR/D/qHzhPR794Z5v6H4HH93az/11XGrsUlpTwoVZUOfCckQJKYSQOfU8IIIFcuVnZRHDPjuV+aTPF+s/7MfiCsOn1mR+FSla9r5LSkGBq/tAAIagrsJdyQrEiNBzVmMOvdvIflfM+plxncuovzqnNMDKViQ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885580; c=relaxed/simple;
	bh=cJCBAu4Xsd7YHC3MdAhW40lmf8oOS+ely9pbpFVahLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC8OZ+U6z/iHgakiACrR5EXiRU21FvFy50Dp7/DNAwbOG1ApL0HmN3vggJc2ihCyzZpNY4aobynU45/QaJzDwl458ZBQTG7xUlxJMuDe5vhvPTCFAL4n7uAf5aZlr/5Ej3I07B+MS+7T7K5eEUq8WjbqOvmgwbXKJtAS02hsFsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLEg2Dj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLEg2Dj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F25C4CEF1;
	Tue, 16 Dec 2025 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885579;
	bh=cJCBAu4Xsd7YHC3MdAhW40lmf8oOS+ely9pbpFVahLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLEg2Dj/OY8ZE1DmTS7LoZLLcAThhcgHG8DV70uknHulfABpcBi1mHJ1TGvCur2Fe
	 6UejrWOaBa1XYJvkyqNG+U928hSfucOfRSYbz8cQ7eVUDhpnFdkGklfbOtRbWhtf7E
	 K2OglUcY+eYqk11HQafoshTk9c6foOZIIrEnfdOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 182/507] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Tue, 16 Dec 2025 12:10:23 +0100
Message-ID: <20251216111352.109505105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 1f727ef60d638..8c989b74f924e 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -388,6 +388,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0



