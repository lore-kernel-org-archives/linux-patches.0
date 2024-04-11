Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93068145B04;
	Thu, 11 Apr 2024 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829932; cv=none; b=uURbkfkAgrj/wuWcWf3tuUcd1kZT1O42uKQazCd6Ornc3LcDWTl2990/vG98tyrYjcLUE/fx8EMZrVk3etR12GZoyOLtfuUX9Lk2MKctd0hgcxuvPue1av1E4uDo+rMz1IGWe90ONM6VjGWmWiCAE4iaZlvOChMoGgFv9NXPiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829932; c=relaxed/simple;
	bh=DFqoL5wUg7CwfRLKrG1WiqThy9aKxvyIUd53kC21k5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8L9iyrdwHoRNkBRpPABKgRa2aGMVCBG4yE6j6rfrw73RJuW5Fd7WrG2AEfZwv9Ds04pMUSIcCRr182JI2Mm129BppRMYTAt8garuRMhlKE6phL8Sr+Mn4/ztvF36w8la/wN4QQhXJTHJOnFuGUluVyLQAfSWtNARdxnUrXfm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA/ScPO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA/ScPO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1849EC433C7;
	Thu, 11 Apr 2024 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829932;
	bh=DFqoL5wUg7CwfRLKrG1WiqThy9aKxvyIUd53kC21k5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA/ScPO3dUY/O3QbyfyLC6G/WNd/tdm/Fh6OMhiHai0CReXesHdbq2a5TLe4Vob3W
	 FJwbMMSTo4bcN7Nto04XjQUyXIOepxPtlYewDJ9OOP6NGuDIA0y2RTxwRskdQl+i0J
	 QKF9QI3RP7RwtSfAjrNxv1EWgo30OC4qAc3IQ+Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/175] Input: synaptics-rmi4 - fail probing if memory allocation for "phys" fails
Date: Thu, 11 Apr 2024 11:56:16 +0200
Message-ID: <20240411095424.168201548@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ac6a20f7afdfa..0da814b41e72b 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -1199,7 +1199,11 @@ static int rmi_driver_probe(struct device *dev)
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



