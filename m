Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85744184549;
	Tue, 10 Sep 2024 10:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964317; cv=none; b=tTOZHaR1ECIhrzkg1yP+fWFBkO5xWV6FLkMA6w8MjG54AlIs6zmnqPH9dCTaIffr/ItDm1Ll9/PfuAmZwooi2G0Rfu1VOJ9jLlfuoOjcCfuNJKEoqAEWl6zGo0qb77uPxT2rOh9k91l8UEPyYc5eQmEh21jJZUqtCaLywGyUxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964317; c=relaxed/simple;
	bh=hNvI2ytjB1b+1/hOphCczworWwkFdEOoWlIrxnECZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVOpYh+isJcrD7chD3kifLX/G8X8Mk0H7PTierR/TFDpR5tv6LDibTPZ5f7NTW7YikMX0xfpOfiuu7dKZ0BBGCne5KpaxcO2fkrg9oiUTK5SIaHLc7izQ97DqKDTgaXQdTFPS8kwjdZj8cOfoocQE3cQ46pwQCBS88h08nzFTQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOaLTvLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOaLTvLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D98FC4CEC3;
	Tue, 10 Sep 2024 10:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964317;
	bh=hNvI2ytjB1b+1/hOphCczworWwkFdEOoWlIrxnECZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOaLTvLmHBKuhK9wGxsogfnYPXeZQaGpggIuTLEaFwRsSN89smo04e8UGsnO81Vj6
	 35eGgblq1xvqawxpF7zESktnNdXRbDtVV0kWvLpg714v+hMwCyHIcsi8hdc+lnzsNR
	 EhIErcCmnBkTSQRp5XrXVCt6T0Qku5vRDjEsKGVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/269] dm init: Handle minors larger than 255
Date: Tue, 10 Sep 2024 11:32:08 +0200
Message-ID: <20240910092613.236242601@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 2a71bcdba92d..b37bbe762500 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -212,8 +212,10 @@ static char __init *dm_parse_device_entry(struct dm_device *dev, char *str)
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



