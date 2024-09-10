Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37008190667;
	Tue, 10 Sep 2024 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962968; cv=none; b=R5Xn/6JAPQS34oFnUG9eYHt8hQJEcDIlVCGLROZoEu/0P/4qkSFcxBNBIMd+avqM7XI1tjoHVuII197HwoozTOQjGNpE7aioZyI1oNLh/VJZawrNn9OGlLuHnNr4mJizjWrLd4ORKCbuvpd9WiryfCOA94J3aW1Q/fCJbMjQ4mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962968; c=relaxed/simple;
	bh=WtCxVucatc299nPxR4mSEJJ/ZWS1je7Hr4/TKwhSWfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHkDgi8L2rb2gso0aPbZW3sssEkkHv6qcG5NeJ+YLOrL9IxuwPVWlq9gkdLXj+hOL4RPT2BdsYK4pAo6dyjBxzq4d1Xr9VmeoqjKDJPGJb7eZTXXbIwzJjzTdRfCh9HnVEuWrf2/oLxPyBepFVSE/s3bb/HTKz67IUq0VFQcD/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM0SHPEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM0SHPEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44BBC4CEC3;
	Tue, 10 Sep 2024 10:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962968;
	bh=WtCxVucatc299nPxR4mSEJJ/ZWS1je7Hr4/TKwhSWfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM0SHPEzlShjoEmtbT/sy1eqCib04wj5OEXyT+dg9kEhu1dnOmo8yOozlDzVtPyFv
	 tSIdbIgy7fLCuPQWeKT0J8jDY/kpwxdyW6RN7SOcAu4roXic5MpUbmxpb5dHQPdqSA
	 J5/JKs2C3SxqFI5ZfrZE99FnIEwCAQtHzbFR2JZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/192] dm init: Handle minors larger than 255
Date: Tue, 10 Sep 2024 11:31:55 +0200
Message-ID: <20240910092601.746259931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc4381d68313..6e9e73a55874 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -213,8 +213,10 @@ static char __init *dm_parse_device_entry(struct dm_device *dev, char *str)
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



