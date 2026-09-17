Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8249D59C;
	Thu, 17 Sep 2026 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671264; cv=none; b=mLuDP/bRPBKuRdljJd+oBEGN6FMIKdjChwoFFtOIk5NBRNfWU+NudYwCHkK4JQWfFK4FASR29w+FAVXvbDAi+thTx4oGAYNIMvGcip4uQy4Gx8gykecWNcsHVuCurZ0PY6/qMFJuhFrxFigjeWmp71oIbbgq+XxF4WzFIVSOqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671264; c=relaxed/simple;
	bh=hZ9DZs0a3diS3XNDPn7kD8CgFH1aMD2pb76FWUmpDoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYMmblJN5MNmNueLuXr0HA7tbUscvUHiZAJ95DjDTL5eI7TBLrmBtzZcyFIsSB1XjjR3UrREmUj4MrDVySQ0l4oTk7zOGJyzvRh3l6yDGJqlZPKJKUHI+IDMVpiZSKUxTsNitiK+Dz+mKykkpv6d1YA8H/L0wxlA8FJQgGC7wCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdlMWnMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdlMWnMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6FF1F000FF;
	Thu, 17 Sep 2026 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671262;
	bh=G8gKDkJubXQfl5o2LjJBT4x08QdNiybgxuedKS9A2rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdlMWnMl6B7oWJQjt/gY8b49O9lKX2eYsUuqAMLPWNUWVKUEa08Fi1ocftPOUUHuK
	 eE33kPnMewbw95PHf4X2WcaeDt1NCF6LdPnpLmRIVWY7NI0eA/YDO/aljPPtH/VftY
	 rx/9qV35JtRLvIZPW/KF6Kux4zJq1FarCPv26OGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0918/1102] xfs: bail out on bitmap errors in xrep_agfl_fill
Date: Thu, 17 Sep 2026 16:14:21 +0100
Message-ID: <20260917151603.673762875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit eaf580538eb1be3d162400d04c4b7dc4c627296b upstream.

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

Cc: stable@vger.kernel.org # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -699,7 +699,9 @@ xrep_agfl_init_header(
 	 */
 	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	if (error && error != -ECANCELED)
+		goto err_undo;
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		goto err_undo;


