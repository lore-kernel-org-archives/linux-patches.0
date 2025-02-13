Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A6203719;
	Thu, 13 Feb 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458291; cv=none; b=oL9XHPzJcPWarpROVBmEbYVlK4P3KIfmvMvistlTHQ8Rq3bgQPRfAaZ496B+8ISMESjGdolR2nCEUEmTunav/GNuJr7RHKSd8pnE7ZZ0PYKXxIPIm72csdMf/PLQTyz56DyyF5IcIejP5JHe7Ac9/fl6nGDrsCgehVYDm6R/79E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458291; c=relaxed/simple;
	bh=le5Fh/+HE2kgN19uOc5Bxd9Ngjyg+rZQSgR0q8qx+8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtW8Fvj23ly04RWfhpE5h6/F+cxQwLV+5ly6t/9tguFti0w6AHJRcc1F64WwY6k+/ZZwYU2dX2aHusuSXfc9NJ+qq8bN8SeCakHOE1dcBKLdJRgsJkNy+fe3ASwNx4KcQBgWjAeiXVET30hCGh0ztqI/wU2xMu9XBcMrl2G3dmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpM6r0Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpM6r0Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D7C4CED1;
	Thu, 13 Feb 2025 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458291;
	bh=le5Fh/+HE2kgN19uOc5Bxd9Ngjyg+rZQSgR0q8qx+8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpM6r0VnxnkfIRDXW5pkg+y9n/r6ejpW5LoR+zwYve3n/sqSEIR3buBQT/CJLOxWZ
	 DfQ6u14PgL+tVOozXEAmmRrf4YHmoEVn/o/ekvkWu/+iO0cJ/3iihI3N1Okn7LHPL7
	 1926/ZVxzE25al4r3oQ7V8ngiapLO+CuSkLlFmao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 356/422] nvmem: imx-ocotp-ele: set word length to 1
Date: Thu, 13 Feb 2025 15:28:25 +0100
Message-ID: <20250213142450.291008005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 1b2cb4d0b5b6a9d9fe78470704309ec75f8a1c3a upstream.

The ELE hardware internally has a word length of 4. However, among other
things we store MAC addresses in the ELE OCOTP. With a length of 6 bytes
these are naturally unaligned to the word length. Therefore we must
support unaligned reads in reg_read() and indeed it works properly when
reg_read() is called via nvmem_reg_read(). Setting the word size to 4
has the only visible effect that doing unaligned reads from userspace
via bin_attr_nvmem_read() do not work because they are rejected by that
function.

Given that we have to abstract from word accesses to byte accesses in
the driver, set the word size to 1. This allows bytewise accesses from
userspace to be able to test what the driver has to support anyway.

Fixes: 22e9e6fcfb50 ("nvmem: imx: support i.MX93 OCOTP")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -153,7 +153,7 @@ static int imx_ele_ocotp_probe(struct pl
 	priv->config.owner = THIS_MODULE;
 	priv->config.size = priv->data->size;
 	priv->config.reg_read = priv->data->reg_read;
-	priv->config.word_size = 4;
+	priv->config.word_size = 1;
 	priv->config.stride = 1;
 	priv->config.priv = priv;
 	priv->config.read_only = true;


