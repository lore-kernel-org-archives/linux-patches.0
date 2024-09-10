Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE076188A1E;
	Tue, 10 Sep 2024 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965075; cv=none; b=ICMq0rC/pQlo4atlT6QQHDu1b71Cm5cGf0uLvuohbFmUNw2YImGZcWmoJS1bkz7YYryuZsRoQWMie5mWAl9YDSCh2gq9OMQfGOGeLLrJ97+hiKdGoMjzF/rreOfEHx6gySAn9YPSHQ/TEShWhkF0jmlm1mnKCCztnb4784ZqZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965075; c=relaxed/simple;
	bh=sx0ThNUt+w9xBFtUA75Tb8yUEZy+QwcRa0rahTTIi9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L24JLyhFedUyxWnqsz62uB+VzEUFvGJLVUp+wUtjLB08VPOJgHHoKsZ+Y8MkwCC/iJEQKCDBA57rGOr8AOwnyYzq6uPL9Ak6hGpZIXqELrHE/JN1H8oc4r3zOJACdsJVVtskfCggQ1MWACcj+J3gfg1MWQutmHrLl+i8bAXHgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaZCVVp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaZCVVp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FA1C4CEC3;
	Tue, 10 Sep 2024 10:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965075;
	bh=sx0ThNUt+w9xBFtUA75Tb8yUEZy+QwcRa0rahTTIi9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaZCVVp1UoFx/Ph3vyho8ip0GiUgF1p/FBi2/aUnuUvh+Cv/u+/H6qL7bvvUTTD1O
	 3cEYbo8lApF1StTaHLFRSWOSrdNI6dhKjtbUXXQkBp7lHxvuEzjxHAD+YxWtO0H89Z
	 R+UKuEira7MnKhZn0dnqfd+yBNBrkNq2M5SVtQR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/186] dm init: Handle minors larger than 255
Date: Tue, 10 Sep 2024 11:33:44 +0200
Message-ID: <20240910092559.888214492@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b0c45c6ebe0b..f76477044ec1 100644
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



