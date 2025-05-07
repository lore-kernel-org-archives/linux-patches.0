Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297191FF5EC;
	Wed,  7 May 2025 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644058; cv=none; b=RirpHAYfJnLclDCpAg0ZN3PX4FAOSq6/kDeVhBEeAeF4BB5HoBpPTm/FpAhn/365fNF3I1cniGJDreNnRWrz/t76d8sNgZwaALDA9Mb/5RpcwgQ4mxEkIIG7r04VHdX9vLq3NJIE3y7EvN/yY1WkCdxnFydCCYAPo9gHppf0kcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644058; c=relaxed/simple;
	bh=GLti/U3PYkAq5BTXtnCzlIAxyv7/0QwTSeNl6rvFpp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuc9GtOzxttLGB8v9T+GO4rh4rFXrwM6AQkH/hkW2FBt7kHZQSnq0jONYhmJH1LylxGAYWWIYEJQba0VTwjo0Gn0DwwGoKm9QKKj1jJSTP8wySroyxIRaqksmHW0L/BHVeHouEH5oT2rC9rxESkMPTkPniqIeu6Ux7Q+qF/0Ob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1+doAD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1+doAD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A754CC4CEE2;
	Wed,  7 May 2025 18:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644058;
	bh=GLti/U3PYkAq5BTXtnCzlIAxyv7/0QwTSeNl6rvFpp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1+doAD1GnO/pDUVYOojs4jJLffgoeCzxew2D1+oSn6rLysa55DsJba4WWVHLV0Ck
	 G8rWtsn8lgQhS6+ImL31WnBpvBfDm753lvdoSA2k/Z/HmH8TvUQxDIsTf65FWdLu+4
	 mRGxLHDKQHUQUT+Mq/QOqqBEupDxZFRembeb/uts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 105/183] scsi: ufs: core: Remove redundant query_complete trace
Date: Wed,  7 May 2025 20:39:10 +0200
Message-ID: <20250507183829.086237959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keoseong Park <keosung.park@samsung.com>

[ Upstream commit 0e9693b97a0eee1df7bae33aec207c975fbcbdb8 ]

The query_complete trace was not removed after ufshcd_issue_dev_cmd() was
called from the bsg path, resulting in duplicate output.

Below is an example of the trace:

 ufs-utils-773     [000] .....   218.176933: ufshcd_upiu: query_send: 0000:00:04.0: HDR:16 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ufs-utils-773     [000] .....   218.177145: ufshcd_upiu: query_complete: 0000:00:04.0: HDR:36 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 08 00 00 00 00
 ufs-utils-773     [000] .....   218.177146: ufshcd_upiu: query_complete: 0000:00:04.0: HDR:36 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 08 00 00 00 00

Remove the redundant trace call in the bsg path, preventing duplication.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
Link: https://lore.kernel.org/r/20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6
Fixes: 71aabb747d5f ("scsi: ufs: core: Reuse exec_dev_cmd")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 128e35a848b7b..99e7e4a570f0e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7201,8 +7201,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 			err = -EINVAL;
 		}
 	}
-	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
-				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 	return err;
 }
-- 
2.39.5



