Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED25101A;
	Mon, 11 Dec 2023 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIVjToD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6809C433C8;
	Mon, 11 Dec 2023 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319359;
	bh=AMFH4FUGPzQT00qqOVBRAlhMGA4kSIwGzrX54NadCeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIVjToD9ogu0KY+uMh6gKtq4x4ungdi+s6HO3+G3LME05RiJB/98RZbmaLrgSbTfm
	 9FdtoWjvaVc8lcbXZrWolokH7L9bIkERcE32rUoYkyBKhoXJoeg00nIka+fl+J/7CN
	 AU8n/G4roOXiLosp9Q8EpzhDMVFtiqY4dw77fgPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/244] i40e: Fix unexpected MFS warning message
Date: Mon, 11 Dec 2023 19:18:59 +0100
Message-ID: <20231211182047.897423592@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7d9f22b3d3ef379ed05bd3f3e2de83dfa8da8258 ]

Commit 3a2c6ced90e1 ("i40e: Add a check to see if MFS is set") added
a warning message that reports unexpected size of port's MFS (max
frame size) value. This message use for the port number local
variable 'i' that is wrong.
In i40e_probe() this 'i' variable is used only to iterate VSIs
to find FDIR VSI:

<code>
...
/* if FDIR VSI was set up, start it now */
        for (i = 0; i < pf->num_alloc_vsi; i++) {
                if (pf->vsi[i] && pf->vsi[i]->type == I40E_VSI_FDIR) {
                        i40e_vsi_open(pf->vsi[i]);
                        break;
                }
        }
...
</code>

So the warning message use for the port number index of FDIR VSI
if this exists or pf->num_alloc_vsi if not.

Fix the message by using 'pf->hw.port' for the port number.

Fixes: 3a2c6ced90e1 ("i40e: Add a check to see if MFS is set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 00ca2b88165cb..a9f5a8a7d3f05 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16195,7 +16195,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	       I40E_PRTGL_SAH_MFS_MASK) >> I40E_PRTGL_SAH_MFS_SHIFT;
 	if (val < MAX_FRAME_SIZE_DEFAULT)
 		dev_warn(&pdev->dev, "MFS for port %x has been set below the default: %x\n",
-			 i, val);
+			 pf->hw.port, val);
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
-- 
2.42.0



