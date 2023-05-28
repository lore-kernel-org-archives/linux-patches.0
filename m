Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0505A569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8801DC433D2;
	Sun, 28 May 2023 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302116;
	bh=x/t6kxFrk9c+yKlNWGjQh4NjV3nAae/I54aV7FCNWIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igOKqAydOrqvTY9l9h7lx346AHtMW8RpLAABYIWUf/aMYV+5RFOTc9MLMXb7xdfgU
	 nuDxrJx20gTsW48zgdv7qIHMY/mJeRDtgNzJy3b2kUB7MV6vr4fK46TbNJKN0gcC3D
	 AqLcyPrJwWYmx1ldKKqww7H82QZGhNdwgODptCAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 160/161] net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
Date: Sun, 28 May 2023 20:11:24 +0100
Message-Id: <20230528190841.896367531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

commit af87194352cad882d787d06fb7efa714acd95427 upstream.

In case devcom allocation is failed, mlx5 is always freeing the priv.
However, this priv might have been allocated by a different thread,
and freeing it might lead to use-after-free bugs.
Fix it by freeing the priv only in case it was allocated by the
running thread.

Fixes: fadd59fc50d0 ("net/mlx5: Introduce inter-device communication mechanism")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -110,7 +110,8 @@ struct mlx5_devcom *mlx5_devcom_register
 	priv->devs[idx] = dev;
 	devcom = mlx5_devcom_alloc(priv, idx);
 	if (!devcom) {
-		kfree(priv);
+		if (new_priv)
+			kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
 


