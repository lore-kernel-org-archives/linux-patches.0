Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2871F4735;
	Fri,  6 Dec 2024 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498729; cv=none; b=ER7nos6d0kmov8IQ8TOLspCX5dqsPCusBy44zzwV/jWDsNB7a26LnuZ2qlE/JNqAJAV0nRYQCWzz7yTrQaet4zMVjSUqaNPiRGqRLxBpe/vD6LAdiVn8U6mPXBB4Pljw+ga1mMt4dDyYmBgK7yce1OE0Zfj6tL2qIPS2tA30ibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498729; c=relaxed/simple;
	bh=wp62qq41ADrBwB+r3XhfXJPSNVbZRDJviAF/xBqDjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1pg4Q+voIAMkQJf9qMVNyt7vn7tM4hi7NDmq/WNgNxY7J4TWOkr3rU4K2jShyFSbs80yEsZNlj8nybTDnZemuKGlzZOWYzMOxadnkZEqWdOBY5yube/aRvoc5q1mTRRJ1uI4ioITAEoCs7UNncz6xPZzMHBJxBj/NxAjVBu9Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPUQ0d+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPUQ0d+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1E8C4CEDC;
	Fri,  6 Dec 2024 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498729;
	bh=wp62qq41ADrBwB+r3XhfXJPSNVbZRDJviAF/xBqDjeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPUQ0d+h9SLrSURlevkIcPQYyDSJHn/TXPYQav6rUc/3k4wU7OKDMq13xvjVdkCms
	 Z2mhdy1/5W58ofrHG/74Dj8+yyVSsP2BX4gm+JWG8jR++uuhVJQSFCB1OdNqNLzAph
	 3JkHXsFGBDM8ryXE9O+RbmNTP4vTMfBb2GlglUSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 6.6 671/676] drm/etnaviv: flush shader L1 cache after user commandstream
Date: Fri,  6 Dec 2024 15:38:10 +0100
Message-ID: <20241206143719.579756812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

commit 4f8dbadef085ab447a01a8d4806a3f629fea05ed upstream.

The shader L1 cache is a writeback cache for shader loads/stores
and thus must be flushed before any BOs backing the shader buffers
are potentially freed.

Cc: stable@vger.kernel.org
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -482,7 +482,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	} else {
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE,
 				       VIVS_GL_FLUSH_CACHE_DEPTH |
-				       VIVS_GL_FLUSH_CACHE_COLOR);
+				       VIVS_GL_FLUSH_CACHE_COLOR |
+				       VIVS_GL_FLUSH_CACHE_SHADER_L1);
 		if (has_blt) {
 			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
 			CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);


