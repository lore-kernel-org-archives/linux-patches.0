Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F91835A957;
	Wed,  3 Dec 2025 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780091; cv=none; b=fkMPABzF3R7Cn2jwa2plZDZg+ILVnjDoqqTmuPwvICUvC1DQATM/YuS3PUUADwetbi0LrHy2WmI+jVA5pFNv/9b0ucWMZK19dXFPUMiJO+0pWH1NJyKNWV/X9htmnniYBELGHUhT0ctUmktrRuVP4T/zALYesHcnBs52ZFeLGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780091; c=relaxed/simple;
	bh=5vzVipyMYbbxByC1XE0vMkTQO7zx7cgCgqX6EnJAoXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCFUJAPEKVZg87lbJJK2UiAD2ciZfAG5BNbQ3jiUc9I+LhlC2D392P/sbLNvXIVXkzBbkGwDh1bejWIqoelPmRBnFrc1nqYyIyKS75Yf6QuKFa6fNUzRp6VGdVyp3lMk6m3rUNS3zk6g99alEeKj9DFHbIRFY1rYutcuiVwgOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eS7U8r4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eS7U8r4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B679C4CEF5;
	Wed,  3 Dec 2025 16:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780091;
	bh=5vzVipyMYbbxByC1XE0vMkTQO7zx7cgCgqX6EnJAoXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eS7U8r4WChct0GzjaKIS1+QMS95FdAI7MVKEl0QgJbvD0rSABw5RV6R/5LiKvv1ca
	 qUrVTiEZMSMrmQ/jZ51xrN5d4tgLHOzWNt7Le31teCwLFI48CrRm6Q8kcSOgBmlCC8
	 J0x1RhJBuQW7nUxDyQCKmlRumUtwYM35jcgUKV2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 425/568] net/mlx5e: Do not update SBCM when prio2buffer command is invalid
Date: Wed,  3 Dec 2025 16:27:07 +0100
Message-ID: <20251203152456.263159170@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

commit 623efc4cbd6115db36716e31037cb6d1f3ce6754 upstream.

The shared buffer pools configuration which are stored in the SBCM
register are updated when the user changes the prio2buffer mapping.

However, in case the user desired prio2buffer change is invalid,
which can occur due to mapping a lossless priority to a not large enough
buffer, the SBCM update should not be performed, as the user command is
failed.

Thus, Perform the SBCM update only after xoff threshold calculation is
performed and the user prio2buffer mapping is validated.

Fixes: a440030d8946 ("net/mlx5e: Update shared buffer along with device buffer changes")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -443,11 +443,11 @@ static int update_buffer_lossy(struct ml
 	}
 
 	if (changed) {
-		err = port_update_pool_cfg(mdev, port_buffer);
+		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 
-		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
+		err = port_update_pool_cfg(mdev, port_buffer);
 		if (err)
 			return err;
 


