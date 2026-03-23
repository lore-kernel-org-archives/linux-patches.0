Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71446394476;
	Mon, 23 Mar 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276989; cv=none; b=KNBGgraJyiK5xCsrBAPHWzM+YKvcCm5UynpZBPnesCG8RXppTF/sjBqXcLnkWbRUTsLrrJGJzYqQqBjCYVQMnmVjSYsurqXz/vt3o8BJygvuBUTcfUZ705jWNQq2z2tRUkUposhUllsuOdxJOCmWbDv+j73mMPuP03g9ovEgxKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276989; c=relaxed/simple;
	bh=shvIH7kSACZGSJzDbS83aZnlXdHNGgY/mVnyeKGQDaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxr6zok8cdqgPI/fnLawpyypC6jWfIQHZF64FKs7eEYZZt8q1ISQXMn4P3W5P3NszuN5n7TCWTod0+vfF+FSv/wvHAFaU3suX2V0A+8HWljsxzlD0/oeAAz36tiLKMx5iIN3RzfW1lWEj5mrbRkMsgH+qaDVXbfP02+MNzvt6Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvGoRFbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvGoRFbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D07C4CEF7;
	Mon, 23 Mar 2026 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276989;
	bh=shvIH7kSACZGSJzDbS83aZnlXdHNGgY/mVnyeKGQDaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvGoRFbGiAAya5cDyqQoYx/I0kkWNNX4MAkqm1x/d8wPIJx2H+eLJyLwPeDuIY8MN
	 RIlcp7VH5zDyJF3CByhIo4lvp1XZDyHb2coust1Y7UjmpdB5h9Y4aVtSWVsdUyT9zD
	 uBuZjyJ0P0nmgUQglnddBOwNOrX6fxCFAjd9DF0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Wenshan Lan <jetlan9@163.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 278/460] ice: fix devlink reload call trace
Date: Mon, 23 Mar 2026 14:44:34 +0100
Message-ID: <20260323134533.307974826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit d3f867e7a04678640ebcbfb81893c59f4af48586 ]

Commit 4da71a77fc3b ("ice: read internal temperature sensor") introduced
internal temperature sensor reading via HWMON. ice_hwmon_init() was added
to ice_init_feature() and ice_hwmon_exit() was added to ice_remove(). As a
result if devlink reload is used to reinit the device and then the driver
is removed, a call trace can occur.

BUG: unable to handle page fault for address: ffffffffc0fd4b5d
Call Trace:
 string+0x48/0xe0
 vsnprintf+0x1f9/0x650
 sprintf+0x62/0x80
 name_show+0x1f/0x30
 dev_attr_show+0x19/0x60

The call trace repeats approximately every 10 minutes when system
monitoring tools (e.g., sadc) attempt to read the orphaned hwmon sysfs
attributes that reference freed module memory.

The sequence is:
1. Driver load, ice_hwmon_init() gets called from ice_init_feature()
2. Devlink reload down, flow does not call ice_remove()
3. Devlink reload up, ice_hwmon_init() gets called from
   ice_init_feature() resulting in a second instance
4. Driver unload, ice_hwmon_exit() called from ice_remove() leaving the
   first hwmon instance orphaned with dangling pointer

Fix this by moving ice_hwmon_exit() from ice_remove() to
ice_deinit_features() to ensure proper cleanup symmetry with
ice_hwmon_init().

Fixes: 4da71a77fc3b ("ice: read internal temperature sensor")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
[ Adjust context. The context change is irrelevant to the current patch
logic. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4920,6 +4920,7 @@ static void ice_deinit_features(struct i
 		ice_dpll_deinit(pf);
 	if (pf->eswitch_mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
 		xa_destroy(&pf->eswitch.reprs);
+	ice_hwmon_exit(pf);
 }
 
 static void ice_init_wakeup(struct ice_pf *pf)
@@ -5451,8 +5452,6 @@ static void ice_remove(struct pci_dev *p
 		ice_free_vfs(pf);
 	}
 
-	ice_hwmon_exit(pf);
-
 	ice_service_task_stop(pf);
 	ice_aq_cancel_waiting_tasks(pf);
 	set_bit(ICE_DOWN, pf->state);


