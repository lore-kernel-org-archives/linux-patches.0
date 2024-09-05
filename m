Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C597154BFF;
	Thu,  5 Sep 2024 09:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530081; cv=none; b=UG6SXXn5fXwTHvZZefx3bBADYzAA+D1VOaDeKxkt1NFB7v56xh9p3QwJYkF32QPBJBZFJtJbd0TLwdfEa3lZzjANytm2XT7vzWIyOtrP9wA4yb0WlbCvyATIoU7PjBX+Vogo00iIV1Un2wR7LFe+CZqjef1DdIFOvI2mhdmjiH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530081; c=relaxed/simple;
	bh=CtEUU8y9Ny4sPSHNaHlMLcw8JWw4JCFIq4jC6uZLCZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxtmcx8xrVYnIUOaTeB/yybeZyEOE3sdvgg+sn6hjnnCZce5mS/jbcC0UDqEMyEx08/FA/0WH3oPPdL7Ow6mEGzlpWFsVBSlOCj3TsB6n+1Qdv9peGHYxcKc/xurFtHAmb2yI4cqkXHTxVrJT9DUGlpgo8fYD5J+vtlZcfhjo/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snLEXuHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snLEXuHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F56C4CEC3;
	Thu,  5 Sep 2024 09:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530081;
	bh=CtEUU8y9Ny4sPSHNaHlMLcw8JWw4JCFIq4jC6uZLCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snLEXuHQ/UtVXIAQWA0dxcIngI5jFje8T5bpof1ObXioB7a2t2yFjoYmKjSu0zRPA
	 Z8c/GhMrlxKo6yIQy33fr4qWGihfsso9fJDWNsbJtRlXQxJQ2ECbpjPP9y/XFvXt1+
	 g/l30laDPAJiVTU2AWXypPaMVg6CEag2PR5q+Vzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/132] drm/amd/pm: fix the Out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:40:35 +0200
Message-ID: <20240905093724.129375488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f503e61faa60..cc3b62f73394 100644
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



