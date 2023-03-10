Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178DA882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA8CC433D2;
	Fri, 10 Mar 2023 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461124;
	bh=qREsFasx0S61F3MN9KA4rvgDMswWgbPeM14sdMTeMSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfyMEgr0G9+gIHl3EXqpALHuyFJ+pr99t3HBodB5V3cpk3oB8LFl+mngeB6D3oool
	 pDNIJOc9BJsSXN2DQf3h945taOovJPB9UvGG5GzYPyRjKvilpdUXi5gcooMUeMEMQZ
	 W46tUKJZ7PtRNgdQWEzwA1S8g2YqO+WiSDBZXFxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/136] um: virtio_uml: mark device as unregistered when breaking it
Date: Fri, 10 Mar 2023 14:42:36 +0100
Message-Id: <20230310133708.074396977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8e9cd85139a2149d5a7c121b05e0cdb8287311f9 ]

Mark the device as not registered anymore when scheduling the work to
remove it. Otherwise we could end up scheduling the work multiple times
in a row, including scheduling it while it is already running.

Fixes: af9fb41ed315 ("um: virtio_uml: Fix broken device handling in time-travel")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 82ff3785bf69f..c16ae3676ee08 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -168,6 +168,8 @@ static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
 	if (!vu_dev->registered)
 		return;
 
+	vu_dev->registered = 0;
+
 	virtio_break_device(&vu_dev->vdev);
 	schedule_work(&pdata->conn_broken_wk);
 }
-- 
2.39.2



