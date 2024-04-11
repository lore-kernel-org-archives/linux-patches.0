Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44722EAE5;
	Thu, 11 Apr 2024 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832717; cv=none; b=mDGDg8m8m/gVUtn8OPwIXP+B7GBAAG56zD/e4Rxm8H7lQqm1dxwbVAalsqzbo6AhXEaLoLSUXUvyIpSPX7vTh1bBuT0BYlFn4m/VLVs5iGN8PJ+ATAIYzVzhneUsg97QT6rx2m1iygcP900RFeZ88HcVWEAkyZ0JSemhtSsilDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832717; c=relaxed/simple;
	bh=NEDVHkUMy/4DasMakWdnxzNRgLAk7QBkFCRSqQUYu/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIA/HsUv7j63Oog3qJkgLEkLk9LLlTNsUW7GqpNY0qjtuihXnLo2nA0Lz1kH8kff/BhhaNNFjC4Zf8t1JJx0ihwt4SVUTIgsR19j6iEY1B10VPjvx3flc3qiuaxMGZ+yfymY5FRcrhBUnv4dSgv0Tra6dNnOiIGGtbdd6Rp2DcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrfDEDRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrfDEDRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F14C433C7;
	Thu, 11 Apr 2024 10:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832717;
	bh=NEDVHkUMy/4DasMakWdnxzNRgLAk7QBkFCRSqQUYu/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrfDEDRy7RvK4N+Lo6eD4n3Kwhj49l9WsW3KTY3MKzE3VZrLtd+AGCzmvJ7YwNPvE
	 fkcrdDTCqaOl34Q5KnNnJ7Y8U/2C1cImtByDO1iLbOe6ibPWkWiGKkfI8QobmwnmMP
	 karZNVODnNwWfwxL+Y1N420qvuBxpQMvHy8KBKhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/57] Input: synaptics-rmi4 - fail probing if memory allocation for "phys" fails
Date: Thu, 11 Apr 2024 11:57:28 +0200
Message-ID: <20240411095408.606866530@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



