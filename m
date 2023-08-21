Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562B71171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79B7C433C9;
	Mon, 21 Aug 2023 20:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648402;
	bh=TWFrmGMlpDWBrYLXPGRI6uIDsq3StWAjjugvTAKJn28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyZfgx7PYfPXTesJ6wI0afeyeatyjHCR4sagC1X3p+YdbILHd9Kc1fc2KGtvG2nUU
	 7Dnw0Phwe5BE3tP/Exhq6wBpGyv/Ywgcy+tMqHzYMiqRNEy5MkiS4usGalG3Qnbwkr
	 k09TdIbefyiqRRtQRnMTXwdarb6lQoYtCQehl56Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Carl Vanderlip <quic_carlv@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 155/234] accel/qaic: Fix slicing memory leak
Date: Mon, 21 Aug 2023 21:41:58 +0200
Message-ID: <20230821194135.671692722@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>

[ Upstream commit 2d956177b7c96e62fac762a3b7da4318cde27a73 ]

The temporary buffer storing slicing configuration data from user is only
freed on error.  This is a memory leak.  Free the buffer unconditionally.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230802145937.14827-1-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index e9a1cb779b305..6b6d981a71be7 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -1021,6 +1021,7 @@ int qaic_attach_slice_bo_ioctl(struct drm_device *dev, void *data, struct drm_fi
 	bo->dbc = dbc;
 	srcu_read_unlock(&dbc->ch_lock, rcu_id);
 	drm_gem_object_put(obj);
+	kfree(slice_ent);
 	srcu_read_unlock(&qdev->dev_lock, qdev_rcu_id);
 	srcu_read_unlock(&usr->qddev_lock, usr_rcu_id);
 
-- 
2.40.1



