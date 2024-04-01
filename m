Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CC84778E;
	Mon,  1 Apr 2024 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988050; cv=none; b=Kb6xXpJgJ5+ZJOaxB6nPPyAezfcp22g4bPInCfHk5KI6t1TOIOq9pdLy/qhgOIrNBu7CZBYvg0QFZTPHFDkitiNf49rJnX529uzPNjqg50d6ZGSCN63XLfYi+kVcfVVkCscwbxW6PMeXztrsZfxH7QhNGOA1ph+SrOHtj3YIUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988050; c=relaxed/simple;
	bh=paU80dZ5Y56OmesFbgAc0LFyh0hXSkFCpKiEkmU7ZA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu4cJZToq8gqzVjO3k+dubutYMrVLfke1y1bcKdf0GIJDeUOJ61khAmzjSTy5lhkrKZwHmHy/FxYNFq4hFwMLu3Bp7BZIFy8TT6RQeBCFETjBxIN8IDLa29r9HItE777fK3i4ASSRX1Z+G+l8KzlZXap3MJIyJKCte28fRn2R68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/UfIdd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/UfIdd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB065C433C7;
	Mon,  1 Apr 2024 16:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988050;
	bh=paU80dZ5Y56OmesFbgAc0LFyh0hXSkFCpKiEkmU7ZA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/UfIdd9Oaelo9rGBZtlzoG304nf9wTOl68bV9ApX02UBzVONubGCcG58oOLjjsxO
	 RJtr85LU8ZmKZSkNv+bibxrKTgqZeat0r8KH1dYPk9VOpDELqCOsuHwHkN9nVCxLmD
	 VMsHl1X4qh1ksefYOmEwNmtr8Q2t0Ax/qUJtj0hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 068/432] vfio/pds: Always clear the save/restore FDs on reset
Date: Mon,  1 Apr 2024 17:40:55 +0200
Message-ID: <20240401152555.153688255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



