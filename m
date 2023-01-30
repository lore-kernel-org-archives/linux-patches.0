Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C9F28F3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AB1C433D2;
	Mon, 30 Jan 2023 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086897;
	bh=RCu4RJBGgWcZMQnuJaEiuE7asbaPiXO+CRPI8qCzY9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+UK3gjOIVdILI4FceMx/IcAftFQCWqDPEfH8DAQdD6DTzaSFG14Zmmx3ikZlyJqX
	 o1Np4Je1EHQ413mKHMM1oGLKaCoEeRyC4pQpQg0nY9kBLDHS3ScNn/r1oejOCYTrkz
	 v+tbYhqY27cPiL8UkFXg66hOre9wjk50hgTIx63U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/313] HID: amd_sfh: Fix warning unwind goto
Date: Mon, 30 Jan 2023 14:47:47 +0100
Message-Id: <20230130134338.178341093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 2a33ad4a0ba5a527b92aeef9a313aefec197fe28 ]

Return directly instead of using existing goto will not cleanup
previously allocated resources. Hence replace return with goto
to fix warning unwind goto which cleanups previously allocated
resources.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c      | 2 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index ab125f79408f..1fb0f7105fb2 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -282,7 +282,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		}
 		rc = mp2_ops->get_rep_desc(cl_idx, cl_data->report_descr[i]);
 		if (rc)
-			return rc;
+			goto cleanup;
 		mp2_ops->start(privdata, info);
 		status = amd_sfh_wait_for_response
 				(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index 4da2f9f62aba..a1d6e08fab7d 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -160,7 +160,7 @@ static int amd_sfh1_1_hid_client_init(struct amd_mp2_dev *privdata)
 		}
 		rc = mp2_ops->get_rep_desc(cl_idx, cl_data->report_descr[i]);
 		if (rc)
-			return rc;
+			goto cleanup;
 
 		writel(0, privdata->mmio + AMD_P2C_MSG(0));
 		mp2_ops->start(privdata, info);
-- 
2.39.0



