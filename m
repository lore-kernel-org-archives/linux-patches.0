Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D8A8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E64C43444;
	Fri, 10 Mar 2023 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460210;
	bh=g/rdjhnRrSasFbgcOXN98gpq9SuEQXpxiPhSI3OW0WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0beull/0gUGcgc+kBB34pda7b/0pP7oGlnbfropqUW1L4Mk/dY2usmN98H9uRrnu1
	 naffx6xAwg1H+i13984YrCXGFw8NlACZm4W5lCLdY+TiFcqO0MyDW6W6YOXMW8oVvZ
	 w+pxv7D4eLIWpWG1fzydvHsWtUpAqCe30Cy6D4n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eli Cohen <elic@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/529] vdpa/mlx5: Dont clear mr struct on destroy MR
Date: Fri, 10 Mar 2023 14:36:43 +0100
Message-Id: <20230310133817.005627470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 32c9925de4736..1f94ea46c01a5 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -448,7 +448,6 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
 	}
-	memset(mr, 0, sizeof(*mr));
 	mr->initialized = false;
 out:
 	mutex_unlock(&mr->mkey_mtx);
-- 
2.39.2



