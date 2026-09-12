Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D0D3C1D79;
	Sat, 12 Sep 2026 07:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197920; cv=none; b=NKYx75AoyJprVJmYkflFy+hoxBK5ll//YgH9RGe4GR/tW38RBPzddU5MbUUH3ZH02v9lTgnM3L6WsBYxDInBlE6ZOF9N38efZOhXtlLc2AiQl2D/R/Lzaby9ty/MAtBOlFqjO3OnrdBllkxxRdThFhmMD44yTT9f+qzXQwBLTMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197920; c=relaxed/simple;
	bh=8II4ghQMx2kjwAavsaC1ei9E8fX+nyb2KIXMdVr9xKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qov6+Xx2+qTL6/oa64OQDTdg4JCLUphoWgcET/nB6lUv0R4XJEk/1lKIMfrYLsf2TnVfYz1iaQA0xUsYzNnQcCfm3iDx/qczM9HKEAdft9+/fX548B4dB0R8b2YDH02hrGgUgWezD/zLxQ/RreIz7hPdX9hjOH95xOYiMV54KLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxdhjX9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxdhjX9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A711F000FF;
	Sat, 12 Sep 2026 07:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197919;
	bh=yuT1TJsj5a7zuc5j83qX2LdF0QfW0UkcMXPnm8cOOrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxdhjX9JxfbU5gqJvoR9YqID0LcOf96/SbR8ZhLjrG+h5DeN7v0QMwAH6jBnvg780
	 9Rw4hijzpy2nyMWrhj8yiOqrGSula1CKF+aXfYokL8g3xPS0McN2jL21wpq+M7z7FZ
	 VZq0/PKYREewOgmknZHZoD92GRzhht+biFSO2o4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0231/1815] greybus: audio: bound the topology section sizes against the fetched size
Date: Sat, 12 Sep 2026 08:33:01 +0200
Message-ID: <20260912065654.415206943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 33d8c7b794d2a30637c9d3fcb478f1d3222bef1e ]

gb_audio_gb_get_topology() fetches a topology blob of a module-supplied
size, and gbaudio_tplg_parse_data() then walks it by adding the
module-supplied size_dais, size_controls and size_widgets fields to
form the control, widget and route section offsets. Those le32 sizes
are never checked against the fetched blob, so a module reporting a
small topology size but large section sizes makes the offsets point
past the allocation, and parsing reads out of bounds.

Reject a topology whose section sizes do not fit within the fetched
size before it is parsed.

Fixes: 184992e305f1 ("greybus: audio: Add Greybus Audio Device Class Protocol helper routines")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260616-b4-disp-4352e8b0-v1-1-3e09f62e0ad5@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_gb.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/greybus/audio_gb.c b/drivers/staging/greybus/audio_gb.c
index 9d8994fdb41a2..144591f1a5128 100644
--- a/drivers/staging/greybus/audio_gb.c
+++ b/drivers/staging/greybus/audio_gb.c
@@ -37,6 +37,19 @@ int gb_audio_gb_get_topology(struct gb_connection *connection,
 		return ret;
 	}
 
+	/*
+	 * The size_* fields are supplied by the module and are used by
+	 * gbaudio_tplg_parse_data() to compute offsets into the blob; make
+	 * sure the sections fit within the fetched topology, so walking it
+	 * cannot read out of bounds.
+	 */
+	if ((u64)le32_to_cpu(topo->size_dais) + le32_to_cpu(topo->size_controls) +
+	    le32_to_cpu(topo->size_widgets) + le32_to_cpu(topo->size_routes) >
+	    size - sizeof(*topo)) {
+		kfree(topo);
+		return -EINVAL;
+	}
+
 	*topology = topo;
 
 	return 0;
-- 
2.53.0



