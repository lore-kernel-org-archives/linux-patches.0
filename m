Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8C1CFECF;
	Wed,  2 Oct 2024 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875678; cv=none; b=PMDzB14g2SVthd2szGtuhFo1DQIP50Q0lF61ADkmHWkPvQNC1/O/p3eWRgYLOg/J6+9Tp/oEY4gG2AWReDvEoA3sCvzvgKjW9u6pRKjyEwQBzF3gCkuWSKjpYWhLgU+MXvudwKJxyL5tREwRh8UURSG248/r07gFt5yocUzEfQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875678; c=relaxed/simple;
	bh=S4aKJSSdXMRn7b3BfSEHpFOVCQv3UqsJk23X4q+J/oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOhGyAQ0w3kZe2+dlnDsqqgtSa85Z8kXy/1TfERyX3s1tCg6+YmF6JbAx1t/VuhMq+de5ISJZYRjJVChetaEjdx30GnSwKutlsaboyyEw9IUcLMVjHHk7ExXR1NS/t45z8CE3JnnLab55qu3VlJynY7Zew11wVLbDzC+u2NJ3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGXpB9Rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGXpB9Rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0811BC4CECD;
	Wed,  2 Oct 2024 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875678;
	bh=S4aKJSSdXMRn7b3BfSEHpFOVCQv3UqsJk23X4q+J/oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGXpB9RwwCuy+OwwXplyEjwAWFqwPBXo9HqN45eGEmxM3eiPb2SFNYiUfAPO/fpJ+
	 pzK3k3/Ue0hXcy9EOtBtqKuqmT2qdBXhYRAqHqF+pDbvLcsP/5TNauBSPnNnsfr7Tt
	 eYo3lRZbM4NV3BBHGvO/73nBJ03ft3LkZFCGmHJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 182/695] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Wed,  2 Oct 2024 14:53:00 +0200
Message-ID: <20241002125829.736207749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index 66fac8e5393e0..a1144b1509826 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -345,6 +345,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



