Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CFF1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E106CC433D2;
	Wed, 28 Dec 2022 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241751;
	bh=j63kxRJw3hF1ULdmPYa1KQ/4pfa/wnh2PWXETgS8TdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7Tr5pe2x0pf53dQQbt57MrtPEWE0dA7muAM7KAheTWpUlhW5nrMQ70ZzwlLiFIV1
	 RJjEQKK77DJf/+/N4tTZFB4du73mDymS0OxzmP0zD3IOlizF+vuh99D11cUxMCZHTU
	 KRwH8HYZmKsC6zz10IIXKo0szoJKDe1QIEYlJ3tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0323/1073] amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
Date: Wed, 28 Dec 2022 15:31:51 +0100
Message-Id: <20221228144336.781205363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit d27252b5706e51188aed7647126e44dcf9e940c1 ]

In the PP_OD_EDIT_VDDC_CURVE case the "input_index" variable is capped at
2 but not checked for negative values so it results in an out of bounds
read.  This value comes from the user via sysfs.

Fixes: d5bf26539494 ("drm/amd/powerplay: added vega20 overdrive support V3")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index 97b3ad369046..b30684c84e20 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -2961,7 +2961,8 @@ static int vega20_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 			data->od8_settings.od8_settings_array;
 	OverDriveTable_t *od_table =
 			&(data->smc_state_table.overdrive_table);
-	int32_t input_index, input_clk, input_vol, i;
+	int32_t input_clk, input_vol, i;
+	uint32_t input_index;
 	int od8_id;
 	int ret;
 
-- 
2.35.1



