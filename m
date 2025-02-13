Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004F26B087;
	Thu, 13 Feb 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460825; cv=none; b=JGYMIKxDi0ah/eWuZtzmySJSwod+tYcSXHTalRYgOGMerOBmLlBnY9kvTRSP1p5XuEwRNVnvNrskYbhfoHYxFE5YRVPypkkczh3AHKc9/l2LGHvrDPmboRtwKhpzhxF25HvHgDUEKF3zKUAHOhOFO4mbgwyfG/q4GbsvHD9W9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460825; c=relaxed/simple;
	bh=0s3EA4xrqhazVu1FFPlD8bXB3egO6iUdNFdb01kPbtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+8WVWro/hMeqbcJVBDo/Ijspj61f0ru2frlawyUYXn8QYk4w2a/MFylhaRNEkIdrEySC4mH2388acSFUYGyioydDjzYy8nmOrj4LEgVsXdoQqHAxVhzJDhea2jFqyMxOwLo8zHqhYxQgxg/PlQ23HCl7319qTFk7Man0byXAyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVf+r4rK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVf+r4rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3ACC4CED1;
	Thu, 13 Feb 2025 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460825;
	bh=0s3EA4xrqhazVu1FFPlD8bXB3egO6iUdNFdb01kPbtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVf+r4rKjQnaZmLJFgsG3IJzVrWiOqBAh24v9HedDkhVBkql3Hvx1pMVJhyTAnx9W
	 TxHXXwGM92kUYri21Jk/q0Z+s4srnY/ygmUmsCavK8hXkG2G2HCKoqbi4RkaxuF5wt
	 tUAfpXgtZvcx5pMzVa89rPzAqKL/5XGRBxkjmiXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 223/273] nvmem: imx-ocotp-ele: simplify read beyond device check
Date: Thu, 13 Feb 2025 15:29:55 +0100
Message-ID: <20250213142416.126604695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 343aa1e289e8e3dba5e3d054c4eb27da7b4e1ecc upstream.

Do the read beyond device check on function entry in bytes instead of
32bit words which is easier to follow.

Fixes: 22e9e6fcfb50 ("nvmem: imx: support i.MX93 OCOTP")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -71,13 +71,13 @@ static int imx_ocotp_reg_read(void *cont
 	void *p;
 	int i;
 
+	if (offset + bytes > priv->data->size)
+		bytes = priv->data->size - offset;
+
 	index = offset;
 	num_bytes = round_up(bytes, 4);
 	count = num_bytes >> 2;
 
-	if (count > ((priv->data->size >> 2) - index))
-		count = (priv->data->size >> 2) - index;
-
 	p = kzalloc(num_bytes, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;


