Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A011C96
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6C3C433C8;
	Mon, 28 Aug 2023 10:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218656;
	bh=dWTUDuSrwZ6JWJ9HAIXqNccT/ryMBbK1gzGJGgNM2eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXH8ZXl1oYJYn7z5gsMsG5Su+cTODi1CQInIzef3a3piyy+RKpa5QRLD/0uzh2CYL
	 rKTPDnPZ3p3UXuIRKTQMzUpxe0rIUR2kP4qdKN+zZTfk9FvhqL/Unu+8g8JfGEY+cb
	 kpGeRFoq9z2YjQsN3UGdj5f/X7Q3ifqRNbs3i2H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/122] selftests: mlxsw: Fix test failure on Spectrum-4
Date: Mon, 28 Aug 2023 12:12:31 +0200
Message-ID: <20230828101157.608139261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f520489e99a35b0a5257667274fbe9afd2d8c50b ]

Remove assumptions about shared buffer cell size and instead query the
cell size from devlink. Adjust the test to send small packets that fit
inside a single cell.

Tested on Spectrum-{1,2,3,4}.

Fixes: 4735402173e6 ("mlxsw: spectrum: Extend to support Spectrum-4 ASIC")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/f7dfbf3c4d1cb23838d9eb99bab09afaa320c4ca.1692268427.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/sharedbuffer.sh  | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
index 7d9e73a43a49b..0c47faff9274b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -98,12 +98,12 @@ sb_occ_etc_check()
 
 port_pool_test()
 {
-	local exp_max_occ=288
+	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
-	$MZ $h1 -c 1 -p 160 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
+	$MZ $h1 -c 1 -p 10 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
 		-t ip -q
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
@@ -126,12 +126,12 @@ port_pool_test()
 
 port_tc_ip_test()
 {
-	local exp_max_occ=288
+	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
-	$MZ $h1 -c 1 -p 160 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
+	$MZ $h1 -c 1 -p 10 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
 		-t ip -q
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
@@ -154,16 +154,12 @@ port_tc_ip_test()
 
 port_tc_arp_test()
 {
-	local exp_max_occ=96
+	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
-	if [[ $MLXSW_CHIP != "mlxsw_spectrum" ]]; then
-		exp_max_occ=144
-	fi
-
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
-	$MZ $h1 -c 1 -p 160 -a $h1mac -A 192.0.1.1 -t arp -q
+	$MZ $h1 -c 1 -p 10 -a $h1mac -A 192.0.1.1 -t arp -q
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
 
-- 
2.40.1



