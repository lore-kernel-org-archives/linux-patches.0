Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE54E10A3B;
	Mon,  1 Apr 2024 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989491; cv=none; b=YrxSI+OQC9HA2+jMssS2UoyRWWMwCyHHxfYGR+idD0vGr/dgjFcOfItR+Rv72SjGam7Ww8PXOx8lBf2fSmW4Qnx447FUUZXG3g+GAjonXnRgXs7NcmsoaYOwHLQaUbLRYDFuomev/1mPjoEsIES8EJFNi4+vYS9F0wa+xE6GO64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989491; c=relaxed/simple;
	bh=3vxF5gPh9b8t6oPFEw9hfgO2l2eFi4Im6/+yFznBM1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgZ0uTyR0ac6uTYPelXgZ5GLE+6814la0/aHbFO5ODttYxwOmI3jDDQLxa2BGK/E/gSk5ybMjzRceXW7i83vEX4XCLceSCXAo/XSCtlryvJOwA7U0pi4pxL/JnknAtg/F6dAS4Jfm4LVAMdkKkpR8sO/n33cONCNav93cG9HSn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKF+8I2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKF+8I2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69694C433F1;
	Mon,  1 Apr 2024 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989490;
	bh=3vxF5gPh9b8t6oPFEw9hfgO2l2eFi4Im6/+yFznBM1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKF+8I2lPTqPQG9rGEoqQImz/hr8HeZhYjAmHvMbYchHzsgv7x6Jj0OsHC3pS6Kwn
	 2M8DgP39kVGkN6xd2uW99L5mo1D51zVlljNSLGbhTiqepZ6w82WQgTTx3u0QNfu3fK
	 tWL0ah6a/bL4d5lkn8OkaAI8+ByYR/xe20sF4f+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/396] vfio/pds: Always clear the save/restore FDs on reset
Date: Mon,  1 Apr 2024 17:41:54 +0200
Message-ID: <20240401152549.861971709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 8512ed256334f6637fc0699ce794792c357544ec ]

After reset the VFIO device state will always be put in
VFIO_DEVICE_STATE_RUNNING, but the save/restore files will only be
cleared if the previous state was VFIO_DEVICE_STATE_ERROR. This
can/will cause the restore/save files to be leaked if/when the
migration state machine transitions through the states that
re-allocates these files. Fix this by always clearing the
restore/save files for resets.

Fixes: 7dabb1bcd177 ("vfio/pds: Add support for firmware recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240228003205.47311-2-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/vfio_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 4c351c59d05a9..a286ebcc71126 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -32,9 +32,9 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	mutex_lock(&pds_vfio->reset_mutex);
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
+		pds_vfio_put_restore_file(pds_vfio);
+		pds_vfio_put_save_file(pds_vfio);
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio_put_restore_file(pds_vfio);
-			pds_vfio_put_save_file(pds_vfio);
 			pds_vfio_dirty_disable(pds_vfio, false);
 		}
 		pds_vfio->state = pds_vfio->deferred_reset_state;
-- 
2.43.0



