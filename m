Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC9440FDB9;
	Thu, 30 Jul 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424008; cv=none; b=WWP/WVNAYExV4Nj/v1JuNsnXGfo1NUb209Nkk7kE8OZWwZy1P2qAft/TeJ35K1HzFGNvTD5DVgnKm50u8xWyTeezD1uKkQNMEDYzTJcVM/SkFSijbFTstcNCqTWCkJrL34FFhBfBPe6XM6EaMJOzJvR0GPlhS1BCGOYKb4+Oy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424008; c=relaxed/simple;
	bh=jNWd7HEpQ6+fIhW/pFn6nYG6r96MyR9BYOhiUl3yv2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN9tCUHgwY4O/oGoEwkomjwQC9Z4GO+Ob4M6hEIBzJmoFlIjFOiytn/ex0ViOMYhyXycynr88saxzOjIJ2DoPYVIrYKqrTZvmIq6wVkh85CdEybws2IMemaXe/8zMReGr231+Ji62XfEjq+ge0qehIBYrrCJinTzkF4i3w5ME5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJQND6Dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJQND6Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091721F000E9;
	Thu, 30 Jul 2026 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424007;
	bh=enfC9PhLuTBiiMwECB8/xgcQ6YBmqSLtG0Bk4XPfdIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJQND6DrltFVm6sY4ziRDsW7D1IMOc7OupH7QlFp3/qC7eb3X5z9xf2IixRbBz/de
	 1nspIa8hgFNHb21tBHqdQOrlD/MblA4DfXhcleJHqaZCOICffoFf36Idrl/9K/txqh
	 JE85KZNomjhxUgeUiZMxk42zDDpSfuLjMxSmih54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sashiko-bot@kernel.org
Subject: [PATCH 6.18 243/675] pds_core: fix auxiliary device add/del races
Date: Thu, 30 Jul 2026 16:09:33 +0200
Message-ID: <20260730141450.300058212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit bfa33cd513c7ceb93c5a4c30e5662acd73c0a916 ]

Two paths add or delete the same slot (pf->vfs[vf_id].padev): a VF's
pdsc_reset_done() and the PF's devlink enable_vnet/disable_vnet handler.
They serialize on config_lock, but neither guards the slot under it
correctly.

add() registers and stores a new auxiliary device without first checking
the slot, so a second add of an already-populated slot leaks the first
device. del() makes that check outside config_lock, so two concurrent
dels can both pass it; the first clears the slot, and the second
dereferences a NULL pointer.

Check and update the slot under config_lock in both paths.

Fixes: b699bdc720c0 ("pds_core: specify auxiliary_device to be created")
Reported-by: sashiko-bot@kernel.org # Running on a local machine
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260714210745.1785625-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 92f359f2b44920..874812bafc1d39 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -177,17 +177,21 @@ void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf,
 {
 	struct pds_auxiliary_dev *padev;
 
-	if (!*pd_ptr)
-		return;
-
 	mutex_lock(&pf->config_lock);
 
+	/* A concurrent del may have already torn this device down and
+	 * cleared it.
+	 */
 	padev = *pd_ptr;
+	if (!padev)
+		goto out_unlock;
+
 	pds_client_unregister(pf, padev->client_id);
 	auxiliary_device_delete(&padev->aux_dev);
 	auxiliary_device_uninit(&padev->aux_dev);
 	*pd_ptr = NULL;
 
+out_unlock:
 	mutex_unlock(&pf->config_lock);
 }
 
@@ -210,6 +214,13 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf,
 
 	mutex_lock(&pf->config_lock);
 
+	/* Nothing to do if the aux device is already present.  This also
+	 * guards against a second add overwriting *pd_ptr and leaking the
+	 * first, symmetric with the check in pdsc_auxbus_dev_del().
+	 */
+	if (*pd_ptr)
+		goto out_unlock;
+
 	mask = BIT_ULL(PDSC_S_FW_DEAD) |
 	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
 	if (cf->state & mask) {
-- 
2.53.0



