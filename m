Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0155630FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBE1C433C8;
	Wed, 20 Sep 2023 12:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212347;
	bh=gMXiOkccmfJ+TW4QLoMO80+9U6lmPsOvOS+KCyAgs6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQ9z1G6hdOfcqO796xp0yNug/1kNjH3qZKmiIw4seMjBQcs0kP/qlfCTAZf6WRHJG
	 CqzFl6a86gKLCv4s+3lGPVacM/c0ofH5HBXh5rYJ42jIbdPyVEsftUtUr7Lt4h2lLT
	 fWxPGcXfldXExQjwk0P0x6vpxfJdPzpvDwead6e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wesley Chalmers <wesley.chalmers@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 4.19 235/273] drm/amd/display: Fix a bug when searching for insert_above_mpcc
Date: Wed, 20 Sep 2023 13:31:15 +0200
Message-ID: <20230920112853.626126584@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Chalmers <wesley.chalmers@amd.com>

commit 3d028d5d60d516c536de1ddd3ebf3d55f3f8983b upstream.

[WHY]
Currently, when insert_plane is called with insert_above_mpcc
parameter that is equal to tree->opp_list, the function returns NULL.

[HOW]
Instead, the function should insert the plane at the top of the tree.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wesley Chalmers <wesley.chalmers@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
@@ -193,8 +193,9 @@ struct mpcc *mpc1_insert_plane(
 		/* check insert_above_mpcc exist in tree->opp_list */
 		struct mpcc *temp_mpcc = tree->opp_list;
 
-		while (temp_mpcc && temp_mpcc->mpcc_bot != insert_above_mpcc)
-			temp_mpcc = temp_mpcc->mpcc_bot;
+		if (temp_mpcc != insert_above_mpcc)
+			while (temp_mpcc && temp_mpcc->mpcc_bot != insert_above_mpcc)
+				temp_mpcc = temp_mpcc->mpcc_bot;
 		if (temp_mpcc == NULL)
 			return NULL;
 	}


