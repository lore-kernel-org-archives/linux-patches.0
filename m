Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECAD6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344DFC433EF;
	Mon,  3 Apr 2023 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533061;
	bh=2sqtOj+1ALMyYEPN/XCPWThb1VdY14/vc//Wws1RtxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bD0sy37awjUNFu3bUZJBBFCNdMYN+VLRk7F1nElk511rlLhLT2B1LyEfqwZ3p6uaM
	 I03LU4ZiWEm6iEMrvpvtoV2INv/fHR+gp6o+m2P2C3W174EgtRv2PIk9uHGTdhcKsM
	 Fk0Vmnf1YVy7t318jpi6k8kEUQ9Sng29xXo3DL5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 039/187] drm/amdkfd: fix a potential double free in pqm_create_queue
Date: Mon,  3 Apr 2023 16:08:04 +0200
Message-Id: <20230403140417.268381990@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit b2ca5c5d416b4e72d1e9d0293fc720e2d525fd42 ]

Set *q to NULL on errors, otherwise pqm_create_queue would free it
again.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 5137476ec18e6..4236539d9f932 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -218,8 +218,8 @@ static int init_user_queue(struct process_queue_manager *pqm,
 	return 0;
 
 cleanup:
-	if (dev->shared_resources.enable_mes)
-		uninit_queue(*q);
+	uninit_queue(*q);
+	*q = NULL;
 	return retval;
 }
 
-- 
2.39.2



