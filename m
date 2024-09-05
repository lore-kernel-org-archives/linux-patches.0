Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B82C1494DB;
	Thu,  5 Sep 2024 10:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530477; cv=none; b=lQ2JiiViHcWd3KCJgP6+gWn1XLSpxSYFDtVu2QJk/hRMoksoQLxD+EIsgEtCTz9HkC3UR9jYqgYR4N43N3+ET2yAq4OA6y2zlYWPqXUiJnmst9jIDd+7rCJwLEQDI8H4k4H+nsEynYwBv4HY28kr5kgPTeFWILjejmx9lHbTf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530477; c=relaxed/simple;
	bh=adAa39WKMvSzCvC6p4PMlsHPlyfACTOS2S+48g9nj9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuqxfSDU5kaPK6/M7h8FQzYXQQCpbqIOfyfMn+NOM9Ojvx5GN/NBa++z3+JiXFA9ZBW7jK6jd7IJYBP9ZF5+lpB8Oe5px9TLL1s87trGQwaedTkvBbj14dHfw7eZHO+DdAjdX41UJY0K1B/903qYJ95Q+hGWbm1vcwsL7eIHkPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcjOqPyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcjOqPyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080CCC4CEC3;
	Thu,  5 Sep 2024 10:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530477;
	bh=adAa39WKMvSzCvC6p4PMlsHPlyfACTOS2S+48g9nj9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcjOqPyhOJQKRkVVzjyY7YzLlHtEwgLu+d0xxJ8OnKSYWZBaZpgVZ0tUm0BAnB3YX
	 semAt1721FEHMIRWNmEDWUjhn08dUBLLUIMuTLzrZHz5sSnGLVkdMwRvaJHp5kHPnE
	 vuuAvhbhQ41hASUvaXyvrQ4Kf2aldAXzRVuCFbVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/101] drm/amd/pm: fix the Out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:41:09 +0200
Message-ID: <20240905093717.581559768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



