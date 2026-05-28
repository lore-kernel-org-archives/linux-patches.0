Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F72459D1;
	Thu, 28 May 2026 20:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999325; cv=none; b=SeGsC5Ilmz3zI24LIVQ7bMqOVHAQa5ykFlWyfH080J1XyfNh2g1IM3nbVAYydBvKXwouPhhuvN3Y4cfWuSY/N+TrEIolP01qdtnzvjoEtHbaKwZ2H7iDhoXmhxjmc4f+X2KiiVVthE0FVykLSyrzTxTqd/5V5CUguIxsA3lgnuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999325; c=relaxed/simple;
	bh=v9lJMt9WX7zrb6Ru/l4W/IkLlTB3mRRYfRDIRXAxExk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ1E7DQd1GIVEPwv0kt77tl8deH34bfyPdes/DbhyeAUOOG4rLAhWx2StTMINDg4WRhiPrx36ciiVsD3oUKR+dw44FD14tFdRAkqIVLa8grpiMa4wQGHY+UrJgbSICnKVA9yECa+IZ3b9ezEKUR1rdeuhGACpj8bW+0Sd7HdTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdwzsBzM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdwzsBzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB9A1F000E9;
	Thu, 28 May 2026 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999324;
	bh=bnZOcSkXCkUF1oZmAbKZO+dp+nvFBheH8V6599YfMm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdwzsBzMPn3XPu7zqylz8TKgMi41DM6dy+cOzfYNEqDTuBg6urUsIfw3cLfF+6gyk
	 BqVdKDofgRveQdiEMQ2p01nPu72fvxT/Jcy1aj7buvchLOplZvNFI/X4oOLz2+wCXI
	 4qXLb0Ie9dgVOBhJg6+ikpvjnK/jgmNgCKObRGFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	stable <stable@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 026/377] sysfs: dont remove existing directory on update failure
Date: Thu, 28 May 2026 21:44:24 +0200
Message-ID: <20260528194639.142626965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 237557b8a81ab948e8332f7c0058e758f081c0a3 upstream.

When sysfs_update_group() is called for a named group and create_files()
fails (e.g. -ENOMEM), internal_create_group() calls kernfs_remove(kn) on
the group directory.  In the update path, kn was obtained via
kernfs_find_and_get() and refers to a directory that already existed
before this call.  Removing it silently destroys a sysfs group that the
caller did not create.

Only remove the directory if we created it ourselves.  On update failure
the directory remains as it is left empty by remove_files() inside
create_files(), but can be repopulated by a retry.

Cc: Rajat Jain <rajatja@google.com>
Fixes: c855cf2759d2 ("sysfs: Fix internal_create_group() for named group updates")
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052003-uniquely-hastily-c093@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -182,7 +182,7 @@ static int internal_create_group(struct
 	kernfs_get(kn);
 	error = create_files(kn, kobj, uid, gid, grp, update);
 	if (error) {
-		if (grp->name)
+		if (grp->name && !update)
 			kernfs_remove(kn);
 	}
 	kernfs_put(kn);


