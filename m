Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45164248F72;
	Mon, 29 Dec 2025 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024985; cv=none; b=P3+eR275QSeYbXNttN+LWEKQMhVWvwgttS6ufsxqfQxwC/UVeO1wkWdoG0XpB1E5QEhQmJfA32NPqmeRgSGszDTMb5vkfF1A69iZTD3Ak5yFrOp78WyjvFs+FT1ev8A5E1SWJvFPG7D0vHP8//vHDVfDHtemohM1h6gcnGkgOQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024985; c=relaxed/simple;
	bh=XajRUUjA8bZusK4wce3fXzxhIS7IgvUh4fyYM411gr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcZXlmgnu8ng5SWPAUIieH5LTGnYJpw2fJtI7ewZoduDtDlX7JxsN0RPQ6Y+AOCNFXOOePMGdjK+zIlmlAiSFZzDBdNa/mMqblpOGr06/cR5yGmyL91pgzUobY4acxxjAX26wbebn+sX1m/maSBSSdYPvXYBlCc/6FZdSPR0k3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnvPiGN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnvPiGN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ACEC4CEF7;
	Mon, 29 Dec 2025 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024985;
	bh=XajRUUjA8bZusK4wce3fXzxhIS7IgvUh4fyYM411gr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnvPiGN6wCz2AdCts5IMTLELAeGoW8Do61PM6eMdbSRRbvVE8nYlewxsyPPivY374
	 /iAVCBllRqXfsBafARXRFXczxKA3VFWBtaARnNHuK0HWmyrMPCnMQyvK/e2w/WhScJ
	 DtaUi2thWUv5kl0YnGndPH566qMVfORQdCJ+T2PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/430] gfs2: Fix use of bio_chain
Date: Mon, 29 Dec 2025 17:07:34 +0100
Message-ID: <20251229160726.283681845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]

In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
The result is leaked bios and incorrect synchronization (only the last
bio will actually be waited for).  This code is only used during mount
and filesystem thaw, so the bug normally won't be noticeable.

Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c46..914d03f6c4e82 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
+	bio_chain(prev, new);
 	submit_bio(prev);
 	return new;
 }
-- 
2.51.0



