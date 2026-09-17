Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671084EF149;
	Thu, 17 Sep 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666644; cv=none; b=KmLodzkMnbaqPtbrOUmQ3wYL3fSEYHUMjNEiBApKRk2AxuTHgRY+vgw4jjKa6/X11Nsq3JhAkhBTgyUUAtksT7mQzvXvce2dwLCAav4GnB1xAWP6oW6+jzfWlBJKnmdfJ2j/VleEhW9oQF5dYKV6u8Dgf9dDwt/yWhNp1cJEQwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666644; c=relaxed/simple;
	bh=wq7S6gJidqoXLZC8SsVO1xcTni/Oluo4MUiumJpP9Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STaMZgGzZcXjPTVL8SqqO65FAtVF/L2Ts1iekN5dukUNV7Hmr5yyXXVeebzImUzSD7YfcO+BGCzzT+NvasgigrGa8PKjWHJ8BDN3qSCMuj5984s/9YpNKdvPxv2YTqGCio2nfZ/uK1nKoRqTv0KYn/sEcHo8MgyJVLeRQ/nlj9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alx3ZKpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alx3ZKpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B941F00893;
	Thu, 17 Sep 2026 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666642;
	bh=9TRFC48MbaQOLNpa6YHwNHH/mttWhxYsy8IsfKsjrjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alx3ZKpAejLz5JlDVyrMLW+l2RlgR9qOg9R3Lvu59jHcSGJGkDCThjwhVxng2Rp51
	 ukV6tjbmyb8qHEyJaRSqAn0tisSgGd+9PH7SHP2ejYyhfl9uSBDBcd1QCNyqUb2t59
	 Od/O9xN2YPpXAH2t8BGKzJg6xBoJnz7RmrkXAZnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 1067/1250] media: v4l2-ctrls: validate AV1 tile counts
Date: Thu, 17 Sep 2026 16:14:22 +0100
Message-ID: <20260917151621.050755471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 439058ced617fbb3febc017b9e93bb7387f309e0 upstream.

The stateless AV1 decoders use tile_info.tile_cols and tile_rows as loop
bounds and as indices into the mi_*_starts[] and *_in_sbs_minus_1[]
arrays, as the divisor for context_update_tile_id, and their product
bounds the per-tile descriptor buffers, but std_validate_compound() does
not bound these u8 fields. Reject a V4L2_CTRL_TYPE_AV1_FRAME whose
tile_cols or tile_rows exceeds V4L2_AV1_MAX_TILE_COLS / _ROWS, or whose
product exceeds V4L2_AV1_MAX_TILE_COUNT. A zero tile count is left to the
consuming driver so the zero-initialised control that existing userspace
submits is still accepted.

Fixes: 9de30f579980 ("media: Add AV1 uAPI")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -778,10 +778,30 @@ static int validate_av1_film_grain(struc
 	return 0;
 }
 
+static int validate_av1_tile_info(struct v4l2_av1_tile_info *t)
+{
+	/*
+	 * tile_cols and tile_rows index the per-tile descriptor arrays and
+	 * bound the tile loops in the stateless AV1 drivers; the product
+	 * bounds the total tile descriptor count.
+	 */
+	if (t->tile_cols > V4L2_AV1_MAX_TILE_COLS ||
+	    t->tile_rows > V4L2_AV1_MAX_TILE_ROWS)
+		return -EINVAL;
+
+	if ((u32)t->tile_cols * t->tile_rows > V4L2_AV1_MAX_TILE_COUNT)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int validate_av1_frame(struct v4l2_ctrl_av1_frame *f)
 {
 	int ret = 0;
 
+	ret = validate_av1_tile_info(&f->tile_info);
+	if (ret)
+		return ret;
 	ret = validate_av1_quantization(&f->quantization);
 	if (ret)
 		return ret;


