Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90C45BE3;
	Fri,  6 Dec 2024 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496350; cv=none; b=lqwoc5ZHjTaeeT0S1CtXQXTA5/CzHDbfgd4MlYyllaHIHkqpSdxFGSNb1B04HnX+EyP7HQNyAKaFVljl+sBMUx5JAUjgJlp13OBI9CEha5mSdmQlzBZkQ4sKeQHSJAbTQOtRifO7nXH3ZPjckTJVH54eM3NFdm371NmjfpJC5L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496350; c=relaxed/simple;
	bh=wWsVPwcjDXhjtALqA45UmtBJHfq4IwXc/zOUFgKc+Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD2UMgQ5N0WXRsWRNUpdAqf5gB+CLQLsdNQWTRGrLpnzc0rYMb9zeRxcToUJv2gONIsZ93eSQyD/olRM5ZDraOzl+CKLMmKtXFR1yuZDdABG5Srwte8nllitJucdfTEnJ8wpGIPmBa3tsCBJQ30+2zMeMgerMSSbm1M2uUS9aSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulNIOOiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulNIOOiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7CCC4CED1;
	Fri,  6 Dec 2024 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496350;
	bh=wWsVPwcjDXhjtALqA45UmtBJHfq4IwXc/zOUFgKc+Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulNIOOiEFUqSJyBq4PqmaEaVCUh2Xz4FrDwW1OUqB+MSOA9muDc0mS7LWEiBVu0KR
	 SQukFur7xHzJW8YXHfXLaUXJpxCl9yWtnCvmSShw4RM3wb+g1WPUquc1rDK6nfdfam
	 3MHo0OiTvwJRIfxkpNsYG6iCP0USehrDUDmsCIjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 6.12 127/146] drm/etnaviv: flush shader L1 cache after user commandstream
Date: Fri,  6 Dec 2024 15:37:38 +0100
Message-ID: <20241206143532.540698007@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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


