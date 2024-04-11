Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37671145B26;
	Thu, 11 Apr 2024 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832387; cv=none; b=UZ5em7XDMGNBj1oUbVOah2NzTjLfcqr+O4lhino/vT2rGvdvCiKL61m7F9rG0KcqdmmAzag4Oz6aqlvGWPjmcHEFp0kOuOqPueYZpoA5cb17AX6zOMuHrUXWujfUv2+Z9I889xAbNziK35ULZhouF7uyryXXBTPCQ+S7QfR0le4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832387; c=relaxed/simple;
	bh=uWagEpRHIxGBWaZYE1yoRjegQbWG/gHONZFkXgDyAvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBpU9V+v2XTzj11U8sqoVM5/RX5sjWl9iU2+Ir9JZJZQDPOje5chrTnk+QPtOlxzEdbHaBIvfeOHWpgNWNG9Ltx6oI+3aYlf2IujH5Axt2phG4fDOIyAmmod/IyFg6uokR6rBN0EQ+bj2e19/kp+EVEfZ+QQD3V21HkF7Y3W46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWztghoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWztghoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477C5C43390;
	Thu, 11 Apr 2024 10:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832386;
	bh=uWagEpRHIxGBWaZYE1yoRjegQbWG/gHONZFkXgDyAvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWztghoyEo5G2cAg46FtWEX6noVIao9bx7fPtDi2fCGy2GKNtQUx7Bpp09DknhQQG
	 GfNT5/RRmUAPi6Y8gSAFZ49PvaetDFxR7kuB+MQYG0F3D32hwUkredMdFVfr4hnrO7
	 wCu6blP/7Gv3EB1eEqdS+TjIuFaOimXz5ZY7R0I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/83] Input: synaptics-rmi4 - fail probing if memory allocation for "phys" fails
Date: Thu, 11 Apr 2024 11:57:02 +0200
Message-ID: <20240411095413.585001437@linuxfoundation.org>
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



