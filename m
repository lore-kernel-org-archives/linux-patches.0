Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7409194A67;
	Tue, 27 May 2025 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365183; cv=none; b=PzPZ8d8cgAbsylqWfF6504Rm+DSSu0AkBpb1STH7OHzPPQfw9S8HmgvlVlS2yBC5lOI/pdCToJeTnEnd0Xr3p1mvWLji1QlvJItkozU5rmrw4R0RUgX2of0eKLq3IR23vGE1lXNOz5utqpSqK08HNeac9cASd/04e3tCT6zHymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365183; c=relaxed/simple;
	bh=XqNb6cOhkudhMqGfOwZcv8yP3XPojJEzuFtlLcej5do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QO5us3hPRz1LJ0ijVJj9h24g4QfRyIqm/zfwsjQwz9OIBrCs1ZYtE8AD3tfV47q4zNEduEkeckXW3Cvf0Edi3uB685uY/SLEPQwj+u2h/WOcp4iv4lrxXrV6Fz+fFegQgwvAoYhSzDNlmmy3eaYFKXRQo/gvYpkqZ3rnbDnZ0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIqjSxae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIqjSxae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DE8C4CEE9;
	Tue, 27 May 2025 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365183;
	bh=XqNb6cOhkudhMqGfOwZcv8yP3XPojJEzuFtlLcej5do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIqjSxaeyxHhpFyddl50hlqtjwIMmbde9bBh2dPNdFgLu7bcw1RP+eWLI2taC3pnW
	 PddbdK30EFOUOkd5uBP6gyBURFnNH0oAchRR9NQrbR7n0vzG2uHOMu4kJM1wvjHb5R
	 5um8krbDZAMcxdn7PFBZEr5CWYmN1cGGONHu1Lzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/626] vdpa/mlx5: Fix mlx5_vdpa_get_config() endianness on big-endian machines
Date: Tue, 27 May 2025 18:23:07 +0200
Message-ID: <20250527162456.979815490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Shkolnyy <kshk@linux.ibm.com>

[ Upstream commit 439252e167ac45a5d46f573aac1da7d8f3e051ad ]

mlx5_vdpa_dev_add() doesn’t initialize mvdev->actual_features. It’s
initialized later by mlx5_vdpa_set_driver_features(). However,
mlx5_vdpa_get_config() depends on the VIRTIO_F_VERSION_1 flag in
actual_features, to return data with correct endianness. When it’s called
before mlx5_vdpa_set_driver_features(), the data are incorrectly returned
as big-endian on big-endian machines, while QEMU then interprets them as
little-endian.

The fix is to initialize this VIRTIO_F_VERSION_1 as early as possible,
especially considering that mlx5_vdpa_dev_add() insists on this flag to
always be set anyway.

Signed-off-by: Konstantin Shkolnyy <kshk@linux.ibm.com>
Message-Id: <20250204173127.166673-1-kshk@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 5f581e71e2010..76aedac37a788 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3884,6 +3884,9 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	ndev->mvdev.max_vqs = max_vqs;
 	mvdev = &ndev->mvdev;
 	mvdev->mdev = mdev;
+	/* cpu_to_mlx5vdpa16() below depends on this flag */
+	mvdev->actual_features =
+			(device_features & BIT_ULL(VIRTIO_F_VERSION_1));
 
 	ndev->vqs = kcalloc(max_vqs, sizeof(*ndev->vqs), GFP_KERNEL);
 	ndev->event_cbs = kcalloc(max_vqs + 1, sizeof(*ndev->event_cbs), GFP_KERNEL);
-- 
2.39.5



