Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9C8615A;
	Tue, 17 Dec 2024 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456349; cv=none; b=nabZvA2n6HRHlmbHetzdLwDWL6tavLrnjdsvSqapOA2qxIEyHzCr0ocxDrMr8EqCCm8af5KF+r41gtfaJCOd1Yc7N9MDMpefgT1vuXfl8AkgOt0bMcEbeD93YqYBbXOmkD3u6Kq7ePgR0LZL+7tsd0eR1YjGDmMN3Yuh10ZCRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456349; c=relaxed/simple;
	bh=72OrcYTbqlKYVwS+SNbFdBBhdEfaE6iUr6J+EMwWPBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci+L/a+FLc/5MSS0GrfjxZ44qGL3rvTUSGNILnzE/M9lJvUiF49DoHMfATJFrn1jP76UtQNtTSijlfnKy5nlW0RfaKCnmXIA3agb1ZX25gO35y02Jy3fmGM9OBLDHhQ+2/Hkxxy/IUNi5j7o7a/4PquLJISYHaDXPcSX01qMXXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAdnqHmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAdnqHmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FB3C4CED3;
	Tue, 17 Dec 2024 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456348;
	bh=72OrcYTbqlKYVwS+SNbFdBBhdEfaE6iUr6J+EMwWPBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAdnqHmANRnYPXgRPjcB+c5RfgLLbX0sh4XXTgk8YuGD4+dhgSixd1vVN8sK/BhnP
	 BIPXCtmUS9PrJQK6hqW9XlRfpBru3UzIL3qnKvhIBk38dRT5oiRrYX7hV7XxZJR+ZW
	 Sop3Phd5ry4spYrIEd8cQXMCph7XGqn2MuZNtJNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 031/172] block: Ignore REQ_NOWAIT for zone reset and zone finish operations
Date: Tue, 17 Dec 2024 18:06:27 +0100
Message-ID: <20241217170547.551963598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 5eb3317aa5a2ffe4574ab1a12cf9bc9447ca26c0 upstream.

There are currently any issuer of REQ_OP_ZONE_RESET and
REQ_OP_ZONE_FINISH operations that set REQ_NOWAIT. However, as we cannot
handle this flag correctly due to the potential request allocation
failure that may happen in blk_mq_submit_bio() after blk_zone_plug_bio()
has handled the zone write plug write pointer updates for the targeted
zones, modify blk_zone_wplug_handle_reset_or_finish() to warn if this
flag is set and ignore it.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20241209122357.47838-3-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -704,6 +704,15 @@ static bool blk_zone_wplug_handle_reset_
 	}
 
 	/*
+	 * No-wait reset or finish BIOs do not make much sense as the callers
+	 * issue these as blocking operations in most cases. To avoid issues
+	 * the BIO execution potentially failing with BLK_STS_AGAIN, warn about
+	 * REQ_NOWAIT being set and ignore that flag.
+	 */
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT))
+		bio->bi_opf &= ~REQ_NOWAIT;
+
+	/*
 	 * If we have a zone write plug, set its write pointer offset to 0
 	 * (reset case) or to the zone size (finish case). This will abort all
 	 * BIOs plugged for the target zone. It is fine as resetting or


