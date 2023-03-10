Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD7A8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED97C433D2;
	Fri, 10 Mar 2023 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457188;
	bh=nptuSFR5rvt714xXu1z8V49GSSGOAgPCPPKXYPnBRck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF23U+MvngTCYYduJRrRbvdrhX5zVr8aMZIjbAkT+Iz7ZFpU5Vjq9QvGfTdOTM1xu
	 /BqIhZ8YcrF62gE8xo/K5sUJWwAPLbe2pwJu7EFBntvoTR8Hb/CNXEdFMC7LHGiDAp
	 OxbwjbO02vQWx/J62roy975DbhawOW8vM9RyuHwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/200] um: virtio_uml: mark device as unregistered when breaking it
Date: Fri, 10 Mar 2023 14:37:37 +0100
Message-Id: <20230310133718.642391516@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index 588930a0ced17..dcfd0ca534eef 100644
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



