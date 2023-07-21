Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D00200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27246C433C8;
	Fri, 21 Jul 2023 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966383;
	bh=nbadC5G980JyFCJLJsQXECqrva+et2+2crCnaUZl3tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXYrtCXksxvyIin0hHrqdvnA8/4nrDKSkhhlS1bjbN+J+XTzhPiGSXtUDFyqTP+qm
	 2BAgGBpRvDyhAp+/rLme9natiBAo8eGIs5z+/j4KLoaT6Eymn5h7gpkAeDi9z2971Z
	 8zd3OGDzUjeCUkAxkeBBFIPLm8UthuIWS7XDZI4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/532] octeontx2-af: Add validation before accessing cgx and lmac
Date: Fri, 21 Jul 2023 18:03:49 +0200
Message-ID: <20230721160632.052067925@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 79ebb53772c95d3a6ae51b3c65f9985fdd430df6 ]

with the addition of new MAC blocks like CN10K RPM and CN10KB
RPM_USX, LMACs are noncontiguous and CGX blocks are also
noncontiguous. But during RVU driver initialization, the driver
is assuming they are contiguous and trying to access
cgx or lmac with their id which is resulting in kernel panic.

This patch fixes the issue by adding proper checks.

[   23.219150] pc : cgx_lmac_read+0x38/0x70
[   23.219154] lr : rvu_program_channels+0x3f0/0x498
[   23.223852] sp : ffff000100d6fc80
[   23.227158] x29: ffff000100d6fc80 x28: ffff00010009f880 x27:
000000000000005a
[   23.234288] x26: ffff000102586768 x25: 0000000000002500 x24:
fffffffffff0f000

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fd0a31bf94fea..8ac95cb7bbb74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -167,6 +167,9 @@ void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
 
+	/* Software must not access disabled LMAC registers */
+	if (!is_lmac_valid(cgx_dev, lmac_id))
+		return;
 	cgx_write(cgx_dev, lmac_id, offset, val);
 }
 
@@ -174,6 +177,10 @@ u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
 
+	/* Software must not access disabled LMAC registers */
+	if (!is_lmac_valid(cgx_dev, lmac_id))
+		return 0;
+
 	return cgx_read(cgx_dev, lmac_id, offset);
 }
 
-- 
2.39.2



