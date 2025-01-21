Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8B1F666C;
	Tue, 21 Jan 2025 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482982; cv=none; b=MWQChOS6X4ir1pENG/ljBnZ7Jz73sCmfQ2u1rM8Bxs/Agi36bI/o3+44Hj1x5ZT1jp39dd6aaPi2hKpHrl4X4nqIVYnOGkSzuP/ObiGGBAe+oGRj1grDjuZ+KDaRD+Y6NAz9KB0aYYJlwRIZmg4XzJQEExMgGDbwmB6kta6X9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482982; c=relaxed/simple;
	bh=fyic/8NRlp51ZHTWYu1Cp1XX9aLGEmO9hbXRyVa6slk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbFEww6ZnJsbmavrPb/z/2JC9ehVW1G3JF7TwXwmbko0GDVTCkliGXWWm+Az3TS6IQBBZ1+ExoE3ljyt6aeSNI6sw0G/oIlpfMt7qxjRYbrFmAyGiWo8Zuk9Qr5nvU7lyH3dn/djtd6Kl6ANy4aRw/lKokBMkSzgu+Ao1QhNqvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIoElNr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIoElNr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24981C4CEDF;
	Tue, 21 Jan 2025 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482982;
	bh=fyic/8NRlp51ZHTWYu1Cp1XX9aLGEmO9hbXRyVa6slk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIoElNr41ALVQdMlUgd558XD+qsLVuYrorKupQgMxBMh2Xpv12Hi5O9dP+o+vNQhN
	 kG0+1No84Wa01IKJiemDARTZ6aEC98N+vQHbM0bvxLTfhCMawOrlkXcP72hKAbZfxT
	 7t6OlYyLL66ZZsh023zXDyLccH2ZzsIuy3/wXkQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 035/127] zram: check comp is non-NULL before calling comp_destroy
Date: Tue, 21 Jan 2025 18:51:47 +0100
Message-ID: <20250121174531.035920800@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 677294e4da96547b9ea2955661a4bbf1d13552a3 upstream.

This is a pre-requisite for the backport of commit 74363ec674cb ("zram:
fix uninitialized ZRAM not releasing backing device"), which has been
implemented differently in commit 7ac07a26dea7 ("zram: preparation for
multi-zcomp support") upstream.

We only need to ensure that zcomp_destroy is not called with a NULL
comp, so add this check as the other commit cannot be backported easily.

Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Link: https://lore.kernel.org/Z3ytcILx4S1v_ueJ@codewreck.org
Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1712,7 +1712,8 @@ static void zram_reset_device(struct zra
 	zram_meta_free(zram, zram->disksize);
 	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(zram->comp);
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
 	zram->comp = NULL;
 	reset_bdev(zram);
 }


