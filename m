Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF1360EF5;
	Sat, 12 Sep 2026 08:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200724; cv=none; b=XISpou1egQmmBgBA7Z+wrCAldDOcbfPZ1hBxkHR+BLc5+TNBNrRVJWxJPQOhWcFdgMizTR40w6jNnP+uGLsePtuGpfw7xmOtd9k3jwftQNcLNJKtnlnK9OEt67yX9POvkORYyFpgj+2A0L/vQoHJtZ+gtXs1zpHUxT3uaYFzb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200724; c=relaxed/simple;
	bh=njyTi5uy2FS8Fgrqf/5v5u1+pwzJsnMHBQRgmvI7Ip4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rml0B7T7NuSUnMfkHJdKd/OY0bUcB/leqefru42LeUd0azSMpVWLXTyVopr4k0b6xjh6REmD4a63Ow5BIms+3ff3G/QipdjrFBYrKjhQdm6maDE2wSZ143EDo7RsV5biKZg6kuY5VmZS1M01ROh6APwP3azYPU3ztqGIG0DagMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JibQAmly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JibQAmly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12891F000FF;
	Sat, 12 Sep 2026 08:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200723;
	bh=sczfu4tKFu61lGvrg9k2jhNutr2Ly+1tWqw/EiOdXSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JibQAmlyY6VL1QNDAjaNL5l8q7VaObetGzOoAzJhnZ3CrklSLsr2snSyM9w9jR2xg
	 VSgd7N9Tt4vCsDf9nM3ACdsXxFVLkXNGq3C6/6OIoMVrT1OrL4V75K28+iX4qeI6eo
	 Nua99enGdRq8U1VoW3mz4mM8X3JrHu3Vog1SavC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Savery <asavery@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0822/1815] platform/chrome: lightbar: Limit payload to max packet size
Date: Sat, 12 Sep 2026 08:42:52 +0200
Message-ID: <20260912065708.210912299@linuxfoundation.org>
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

From: Alexis Savery <asavery@google.com>

[ Upstream commit ed1d1f519c56c6c2ffa13f3d52cd77beb023db13 ]

The LIGHTBAR_CMD_SET_PROGRAM command uses an 8-bit size field for its
payload length, but the protocol-negotiated `max_request` may exceed
the maximum value an 8-bit integer can represent.

When this occurs, large payloads (e.g., >255 bytes) integer wrap the
8-bit size variable when assigning `param->set_program_ex.size`, causing
truncation and parse failures downstream in the EC firmware stack.

Clamp `max_size` to the maximum value the structural size field can
support.

Fixes: 9600b8bdbfe4 ("platform/chrome: lightbar: Add support for large sequence")
Signed-off-by: Alexis Savery <asavery@google.com>
Link: https://lore.kernel.org/r/20260730204240.2227178-1-asavery@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lightbar.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
index ac919c14c631e..1a89e90957cde 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -504,9 +504,14 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 			return -EINVAL;
 		}
 	} else {
+		/*
+		 * Bound the payload strictly by the maximum value the structural
+		 * size field can natively support.
+		 */
 		extra_bytes = offsetof(typeof(*param), set_program_ex) +
 			sizeof(param->set_program_ex);
-		max_size = ec->ec_dev->max_request - extra_bytes;
+		max_size = min_t(size_t, ec->ec_dev->max_request - extra_bytes,
+				 type_max(typeof(param->set_program_ex.size)));
 	}
 
 	msg = alloc_lightbar_cmd_msg(ec);
-- 
2.53.0



