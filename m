Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D6640683D;
	Tue, 21 Jul 2026 19:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660693; cv=none; b=H4wzZI0X7J2+VrEqBd9mjsqGI/ASvCggIkuGxhWE55r/nhTF0lhI2a+pMMY9jrtr65539ocohk4RS5HZw8lbD+OCQ0mqzG4ROOupwotghvDUOv2h389iTMgpwcwdJELSefcLxUyCFvUVu1vYHeFIdYFIMHt5fg3nRn/gIkyTJro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660693; c=relaxed/simple;
	bh=CnFtYguolLU55ujFJtjZ0QUguo8T3OntwGrOG/jbfmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n34GQha4fQEOCUpeLOYTD5JdCgmdM0ICx8t6i0mC32JkFPID3ZZWPQX3Xlh2215Efr7oo0s4adx19h1x6BAoWRH59d4h5quoPztzGMowbq4OP6uXk/HInQv1DG5FR9fwfhjmY+7r3Hi7lmo1GvcwSDthw5pqjaWAOL6gnOPMFpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyR1EPu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyR1EPu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103F51F000E9;
	Tue, 21 Jul 2026 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660692;
	bh=pzsFuJ8FnHVmAqbEoYHyHaFSaAJrcH7vhuPuJgd8dQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyR1EPu85vVD+U6gZcoJO02JXAvoE6YPnYECO2k/Bw94v803FIloYYVe1dRAeTAx8
	 FaoQyZlPdT4Dw/SU6RxMLn2pcbl/27dbnP/P3dDBZee7eXrVYDNCwSD7U8PjP2V1xD
	 w277BByaHBZmt8KvNv7rQUYnwZks16p9xvIfq32s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1059/2077] i3c: master: Serialize i3c_set_hotjoin() with the maintenance lock
Date: Tue, 21 Jul 2026 17:12:12 +0200
Message-ID: <20260721152617.798887045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 5b130aadc36b6a935b90937dcd67b8ed4ba57831 ]

i3c_set_hotjoin() dispatches the controller's enable_hotjoin() or
disable_hotjoin() op and updates master->hotjoin under
i3c_bus_normaluse_lock(). That lock is a read-side acquisition of
bus->lock (down_read()), so it does not exclude concurrent callers.

The hotjoin sysfs attribute can be opened multiple times, and writes
through different opens are not serialized.  Two concurrent writers
to "hotjoin" can therefore race in i3c_set_hotjoin(), with the
controller op and the master->hotjoin store from one call interleaving
with the other.  The hardware enable/disable state and the value reported
by hotjoin_show() can end up out of sync.

Take i3c_bus_maintenance_lock() instead. Toggling Hot Join enable
changes bus state and is conceptually a maintenance operation, so the
write-side acquisition of bus->lock is the appropriate lock and
serializes concurrent callers against each other and against other
maintenance operations.

Fixes: 317bacf960a48 ("i3c: master: add enable(disable) hot join in sys entry")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260608054312.10604-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index ab11e2d79aabb4..38ffc87131678a 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -649,7 +649,7 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 			return ret;
 	}
 
-	i3c_bus_normaluse_lock(&master->bus);
+	i3c_bus_maintenance_lock(&master->bus);
 
 	if (enable)
 		ret = master->ops->enable_hotjoin(master);
@@ -659,7 +659,7 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	if (!ret)
 		master->hotjoin = enable;
 
-	i3c_bus_normaluse_unlock(&master->bus);
+	i3c_bus_maintenance_unlock(&master->bus);
 
 	if ((enable && ret) || (!enable && !ret) || master->rpm_ibi_allowed)
 		i3c_master_rpm_put(master);
-- 
2.53.0



