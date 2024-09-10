Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7714D431;
	Tue, 10 Sep 2024 10:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962544; cv=none; b=BtpY7GaudY4smjRghyHz3lGByZbi5Inxd/iXEul/7q8iGK2j5st0WIBbGVjnM2UfxGPbzLjvigrj6+Ioj0+0YikOUEWIkP5QjrRPiep++BthhKR5YN5e7m+tiqQuQqNimOK36Mj8uuHCClme5Msizg/+0A+Heiiu0++q+yOG8B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962544; c=relaxed/simple;
	bh=IY3jHYFyce30SdFrSRsGr2ZMjJRbXfhJh8uhcer1uFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2dowObvIsfTo+UMI/TRIgy4fWahNKL05HUV1r7gKOL4uaWr6LLcCqLKRPbCO6DLsop+O7nLzUEJlZ4BtdgU4rHoJ928uhbW3MTGtSJv67KmusUqO8oJnhYDKR/L1SquxnFXpIIhoz3uBtRE8NXVh4pk5u/6dlLhR6a83AIKv40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM7uTs5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM7uTs5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811FEC4CEC3;
	Tue, 10 Sep 2024 10:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962543;
	bh=IY3jHYFyce30SdFrSRsGr2ZMjJRbXfhJh8uhcer1uFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UM7uTs5/J/09TjNsCcYLDK6NdfGB6/0ebIgwK5H7gqyG9Y+XmAH477hrITQOvagrJ
	 2M6dC/mTMOUvWca5lXXaUoUNyYGgmdEHqIj40ZN6Gltx+Z6+CFEWPyT0miCgTv+ITE
	 6+dV8fRttkXfX+4c3TsLmFu3C/05q3fMoUHO8LTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/121] dm init: Handle minors larger than 255
Date: Tue, 10 Sep 2024 11:32:25 +0200
Message-ID: <20240910092549.205058914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 140ce37fd78a629105377e17842465258a5459ef ]

dm_parse_device_entry() simply copies the minor number into dmi.dev, but
the dev_t format splits the minor number between the lowest 8 bytes and
highest 12 bytes. If the minor number is larger than 255, part of it
will end up getting treated as the major number

Fix this by checking that the minor number is valid and then encoding it
as a dev_t.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b869316d3722..4a8bbe0391a2 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -207,8 +207,10 @@ static char __init *dm_parse_device_entry(struct dm_device *dev, char *str)
 	strscpy(dev->dmi.uuid, field[1], sizeof(dev->dmi.uuid));
 	/* minor */
 	if (strlen(field[2])) {
-		if (kstrtoull(field[2], 0, &dev->dmi.dev))
+		if (kstrtoull(field[2], 0, &dev->dmi.dev) ||
+		    dev->dmi.dev >= (1 << MINORBITS))
 			return ERR_PTR(-EINVAL);
+		dev->dmi.dev = huge_encode_dev((dev_t)dev->dmi.dev);
 		dev->dmi.flags |= DM_PERSISTENT_DEV_FLAG;
 	}
 	/* flags */
-- 
2.43.0



