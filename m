Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991202F2351;
	Tue, 17 Jun 2025 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176383; cv=none; b=Cer8OtJczE8qblqHcGEa+1MC+IGyL0fcWSq/AnKIQWOiH9ewe7SE6ruIAR1cKvw04Sq0RMHsH/goxxa2h1KhHoAXcnlexXTRh395pRbhgR7t11LXu4tw4TcK01BEYJ7/3U/L+AQtsM3ju9GuKy1duteAO40k7BFlBKIWx0Ehy3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176383; c=relaxed/simple;
	bh=cYV7uacDWOCxSv9ysEm9MEC0nuseopwFHOmIcnZ62IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ9tHPyJymrncDE3DX0P+jzEia4AD5XxE1ypX0fqvpD432dn50SDZmLRC7gjdTPerCP5/0p4I9S8clASZfWGAuH/Ud4qDjyKx/esdReI2Vdnbfe4E3+Z6oR1I7iy4evv64s3BoEs+C8UnNndOHAeA2ohMMjFSH0VQsEYXQ+QAHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyAR49yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyAR49yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31FDC4CEE3;
	Tue, 17 Jun 2025 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176383;
	bh=cYV7uacDWOCxSv9ysEm9MEC0nuseopwFHOmIcnZ62IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyAR49yzNyL+urnbpxKb4r5yZFW9rkiYfjXKceR5nnXIoVxzkMtOBBee82pjpsnW4
	 OQ4O3xMClDr4Llk44FFOL3nHe7MCchITpsh8dCULE+AzMCC+0uKlk1kLqmlangLFMR
	 O1E/dCB8tO2xQD17ZLvZ0EW4Ly9x3s7N8Y2BfV0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/356] ASoC: Intel: avs: Verify content returned by parse_int_array()
Date: Tue, 17 Jun 2025 17:26:27 +0200
Message-ID: <20250617152349.146553941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 93e246b6769bdacb09cfff4ea0f00fe5ab4f0d7a ]

The first element of the returned array stores its length. If it is 0,
any manipulation beyond the element at index 0 ends with null-ptr-deref.

Fixes: 5a565ba23abe ("ASoC: Intel: avs: Probing and firmware tracing over debugfs")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/debugfs.c b/sound/soc/intel/avs/debugfs.c
index bdd388ec01eaf..26d0c3a5a9542 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -371,7 +371,10 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 		return ret;
 
 	num_elems = *array;
-	resource_mask = array[1];
+	if (!num_elems) {
+		ret = -EINVAL;
+		goto free_array;
+	}
 
 	/*
 	 * Disable if just resource mask is provided - no log priority flags.
@@ -379,6 +382,7 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 	 * Enable input format:   mask, prio1, .., prioN
 	 * Where 'N' equals number of bits set in the 'mask'.
 	 */
+	resource_mask = array[1];
 	if (num_elems == 1) {
 		ret = disable_logs(adev, resource_mask);
 	} else {
-- 
2.39.5



