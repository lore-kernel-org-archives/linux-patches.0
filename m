Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756A513A26F;
	Tue, 27 Feb 2024 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042884; cv=none; b=jrSqSWdc6WO7wJ6NrwYwCKbGi05p7At+xtWbRonhGkKM3psDC4C+p0CCbKUtk4GiLTE898zU8XOA65QOclYzgjK43W1Gs+wsZ3XuAo68jadOIVWPzYD1oA0XWY+PXP8o6teHDnVjaoxMNtul4dzwRZAqwMLX90Q9ErhnIh7XJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042884; c=relaxed/simple;
	bh=A5Lc2xaSCWjcNKNH+s6VVRL/wLEATjZM8TYRM7QixVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIP/w99Go5jeoup6E177u1v9MH4YabRGWFwptAhYQwdOOveEZyaoqxTxB8E9odU7/+d3sop2kCc1gabo6X+1CcloZ48R5obxuMXJouQ0mO8LQCCQhug20EJcN0nzkrUsiZ/53o9FmglYfwQZMn0Fo48BRhRAiiAKsmONaNJcpY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sF7OgcZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sF7OgcZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D2AC433C7;
	Tue, 27 Feb 2024 14:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042884;
	bh=A5Lc2xaSCWjcNKNH+s6VVRL/wLEATjZM8TYRM7QixVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sF7OgcZHLcdCraPOhna/qkaLjOtvDd/2uacEVV99qeDChRX7rTBRZn7fUjFe0ztZ6
	 8abzx+1QFSWG9pebEh8beK5M+neTZejhxNh0ZZRCt6DLAFyhBAegtuOwVnoVWqQAkw
	 Gj2rA4zmQ7yOIouD6Se7RVXUR250/2WX2hM+HdAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eli Cohen <elic@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/245] vdpa/mlx5: Dont clear mr struct on destroy MR
Date: Tue, 27 Feb 2024 14:25:16 +0100
Message-ID: <20240227131619.381826130@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit aef24311bd2d8a6d39a80c34f278b0fd1692aed3 ]

Clearing the mr struct erases the lock owner and causes warnings to be
emitted. It is not required to clear the mr so remove the memset call.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20230206121956.1149356-1-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index ff010c6d0cd39..bdc7595fcb0e3 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -505,7 +505,6 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 	else
 		destroy_dma_mr(mvdev, mr);
 
-	memset(mr, 0, sizeof(*mr));
 	mr->initialized = false;
 out:
 	mutex_unlock(&mr->mkey_mtx);
-- 
2.43.0



