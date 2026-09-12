Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1282E33F5A7;
	Sat, 12 Sep 2026 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222798; cv=none; b=oM41pnBpK6GHWTMzluaf9BIwt3VvBV5W3GFoGKQjBQB5oI7msLjX/oCSVSl+gvvBWDq3tIL9WCypOS590lN9tlppwztsgFc92TJ5Y510MN1BRlDf2EWL6tSxbkuZHMcyownEPawPfz73yTzuzE7kf6VEbGy/kDhLxA+lwhf9TsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222798; c=relaxed/simple;
	bh=zctUIYPh8sbb8P0UoZAgXviGdNQEm8rA4f898wmRyQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWgGPiZVgVyOA3ZgVp11yqdbCKZ6MaBg0gCp9vUJJyCY479dFX9aATZzN1iDiiWPd12JoQ57It307BsMcOPgKmrDA7jEOUKiZbsTSokKz50maZjMfowUKjovo9Xj+OYI3cR+YP8+WLBfmtzKJzAQsNHbLKgSPbISKDrBjwWzO2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmCzYqgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmCzYqgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93ED1F00893;
	Sat, 12 Sep 2026 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222796;
	bh=BT3TMJ/YsUIpB8h+s88wDMsRF5hg8/iQR87/LXSR+RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmCzYqgBphs+6PJcL3gCaEs64qMnm2PuLCszRE4DGPSdcSo9c6ebmTW2miY2LEj6K
	 tjxuqutrmFOICLzc6JYJNf2tVoPhcd6NojlEY3wBTAkYBCpwawS3knPbqZmr27b4Ja
	 /JoMBLmKgBd4kXFoWVQ0Ym86Xdv8dkTG/lf/0L3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0658/1424] greybus: audio: bound the topology section sizes against the fetched size
Date: Sat, 12 Sep 2026 08:51:30 +0200
Message-ID: <20260912065622.027912190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



