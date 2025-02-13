Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68CE145348;
	Thu, 13 Feb 2025 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458280; cv=none; b=hcDZI/k9/afh7vYNzuGE3+8gPnIldJhgkSy6jFu7IzpvLNvn1BAvXEtjKtkooK+AaBjKs2gVS9My9NpjEqM8tPhXJZQkPo8EIARcKhkdOTieX7ef18K1IbSGl8NxDNV5bQoSQWri1fPh8/zb3kKt9kRb4ZVAhlAW+JK2MQPbPGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458280; c=relaxed/simple;
	bh=z21vstcQ5rhZs7S/OJKwhjqt+z/6pKBCFNf8lG+150Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYhFiQjAubrpX01wLvs5oVF+4XLOM9fDhsP7xEtHbwEjqPgvuqbIEjgjYoTIjdrQM1slkdTf23ITgF37ERRIdQWoIi0K1v5EOTMXI1qTVk87dP50Mfqt3pgXhPI/nl/iMC7wmAOkZJbN2Rj3NE639fVanQv6HirnqUAXVQGQrQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqfScEf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqfScEf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A34C4CEE5;
	Thu, 13 Feb 2025 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458280;
	bh=z21vstcQ5rhZs7S/OJKwhjqt+z/6pKBCFNf8lG+150Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqfScEf/kzEH5oObh/pe8De2Xxbou2bssKAR3v3eObhBX7CrIzjyw0FWiDcj2vIzi
	 i5g4WThidHsYsF7OUvvADd0Br9jA6ePmGCp1EkEyRPBcERx+QLiF1bvbbaGrrHkrTt
	 UqTuQjvl6lxm43XXczLh355e52N9MVJGnlGdhYJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 353/422] nvmem: imx-ocotp-ele: simplify read beyond device check
Date: Thu, 13 Feb 2025 15:28:22 +0100
Message-ID: <20250213142450.176340058@linuxfoundation.org>
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
@@ -72,13 +72,13 @@ static int imx_ocotp_reg_read(void *cont
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


