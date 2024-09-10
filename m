Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D2818C002;
	Tue, 10 Sep 2024 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964727; cv=none; b=h/3lOhV2UiqSuD2ZVl3lim46pVMW+wRec6LWofoZSjd3lxY3VBG5rDwirnyXaSceIzUeisMfOQuyb9ryuXaFALNI9+luXySV1xjugegC9o/MP4gZajN7zI1k5wrvg/0NEBu7VIM9cB7wxX30iK7WiMz4Io90mRCNroSirDX8kxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964727; c=relaxed/simple;
	bh=NvTHhqXI/e5w/omqR9skAYomFpi11zK5y7MNf22BCbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK9uRATjPsb8YuNYiXp3/4p7TLFyghEwqgjaLAckCoHa5+K4zsHN5PE5/GZqqfAme3VsDxHycV/0S9Nt59pMQao1zOMqcRho9gnDsd15zJsO8PF8AVOUsQ+oxQWoRocRNsCDguHrq5f9oA1YxgBDp/xGjTltfGsHPW9GGeVaT4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxQ0J6VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxQ0J6VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644E4C4CEC3;
	Tue, 10 Sep 2024 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964726;
	bh=NvTHhqXI/e5w/omqR9skAYomFpi11zK5y7MNf22BCbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxQ0J6VYOyylNn6pJKtUuu3bpXUWFx3aNQs0VbAG0ug5oC2mzs1KKXCJNUHt+uYve
	 V0GadulabIn7+XjJ3BV3a3DTK+1VexpL+ndYtNZ/OAbmM+xj1yUjBxrA5TOQJZze5W
	 G8+BO5GMHMczkyZ0n/u54lpbrCl4NfU5OF5ipuRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/186] drm/amd/pm: fix the Out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:46 +0200
Message-ID: <20240910092555.114715256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 12c6967428a099bbba9dfd247bb4322a984fcc0b ]

using index i - 1U may beyond element index
for mc_data[] when i = 0.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 01dc46dc9c8a..165af862d054 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -73,8 +73,9 @@ static int atomctrl_retrieve_ac_timing(
 					j++;
 				} else if ((table->mc_reg_address[i].uc_pre_reg_data &
 							LOW_NIBBLE_MASK) == DATA_EQU_PREV) {
-					table->mc_reg_table_entry[num_ranges].mc_data[i] =
-						table->mc_reg_table_entry[num_ranges].mc_data[i-1];
+					if (i)
+						table->mc_reg_table_entry[num_ranges].mc_data[i] =
+							table->mc_reg_table_entry[num_ranges].mc_data[i-1];
 				}
 			}
 			num_ranges++;
-- 
2.43.0



