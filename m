Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9513FD94;
	Thu, 11 Apr 2024 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830990; cv=none; b=gR5Vqxe6AYJPP4AZAyX39vlwAnLk1GxUKzGtZfGAOirz6JKgG8ZGHXsDm36pz83HIOc+KBMym9llzFQ0y9MNH2Msx0W3PD6D6jyiErrl/p+tF5G/ohSKNelYYEnid0574Q4tgxxzJy051GTcBxiaGGGPxBAv5nBviBwaQM04oac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830990; c=relaxed/simple;
	bh=DdYv7qyb9KwZMRfICVkwaF677qkOqBJ6rTz9NcXwMUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUJgW9buti3gRr2ZMDMTLi3fctCQ38rAzz3UhB73PX2RWLW+MiBhPmkdQrPWdj2oZUZzN4AkBQ9VTA2IgYwsHPjzvLuV3G3SD3QEGa5Iqz0xsIVzhV8RgM1djkxCXhbfqSuhDN4HGIMR2t8gqyFGWqt9nRkkTiM1BE/bYpiqlpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ydvyff+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydvyff+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFB7C433F1;
	Thu, 11 Apr 2024 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830990;
	bh=DdYv7qyb9KwZMRfICVkwaF677qkOqBJ6rTz9NcXwMUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ydvyff+6rrnksvjyFjSM2FXg27kIPHN2Relu8nRl+qy+k2ooyE3jUseNSgumTLr7O
	 7f0G0/RsQABlANMys4N7vuiZm0EFtJg7iOq2K/Wksx0Q8r2ui5vlnmliRNlfAFsVZW
	 eTgf1n4Mez3ran9R1ihTOoEbJwlUFh0ASl1WLZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/215] Input: synaptics-rmi4 - fail probing if memory allocation for "phys" fails
Date: Thu, 11 Apr 2024 11:56:34 +0200
Message-ID: <20240411095430.427400918@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



