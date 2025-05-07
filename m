Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5A28AAE9;
	Wed,  7 May 2025 19:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644405; cv=none; b=EqTvfVERv646QY61zpCxOlUcbZdHD3/iOF1NDhIt3G/IKEWNUE6pR/TqNhxkN3XySJHv6OZW766Zp2aKWheBkcRS8yK6hvfa5uzGIXtbezu2W9z2ApM2Gd6yOVdURFqWHANpYcLPPx5Nv1YuLZvCeI4AP/Hx9UpRAqP0FvtErmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644405; c=relaxed/simple;
	bh=OzU7vVGetSAjD58KHIOTspSBMHDfC51ZHlKi16AxbRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMqXyXKU56caUOAxyiCBT4jwfPZ61LFxfM921ZToEhySjqYnU0eAMDTerxOCLBvdAdrQN2xjqcMf4v0Ts1gTYsT3km/JVivBnPgviqW1X82DXRDQVpZKgAfCECJJ3KHL+sphgNyPqFCtHQ0C6vP+eISHy9BtyScIIAQf3aZrmzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXQPKCKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXQPKCKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1CDC4CEE2;
	Wed,  7 May 2025 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644404;
	bh=OzU7vVGetSAjD58KHIOTspSBMHDfC51ZHlKi16AxbRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXQPKCKOHQAx5p1WYaWrdCU4dnP2IUNUE8MX0SwYr3hV/5SG/IIvFpkeLBvJynIIv
	 JS/nuKdyPvlwL5iX+S8AppSzit+vwfC0pxITUux6mjcFFmRHBNC7yE6LH/mE9P9RYk
	 mFdu1+GtqQTtwED/G02rOlRfyVdVLLweIYpRmpW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 033/164] dm-integrity: fix a warning on invalid table line
Date: Wed,  7 May 2025 20:38:38 +0200
Message-ID: <20250507183822.216818310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a533c3e4246c29d502a7e0fba0e86d80a906b04 upstream.

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -5173,7 +5173,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


