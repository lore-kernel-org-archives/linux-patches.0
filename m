Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E0182D7;
	Tue, 27 May 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366191; cv=none; b=Hfl4eOuXk6usrrPxtMPgSXQgXFWvb+e0zNKp+AigZr3JvDngQbUUanlH6+hfABBinJNQV/fVcmvazcTTYKIvyYhwGPPxHRil9x3wv8/Gyxe3+wWpr1zevHdzIdb0MlPoH3T40XmxFRolppR+TQg+bPZ58diZpK4APw4crjUccLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366191; c=relaxed/simple;
	bh=01Hd7+D9LM27uwNHf+FUqx+9M2UAuaWvXmY8eqmQXV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYhQV5lkm6JIWHe7fh1PpNTmAjyednQW9zOSQ1T4Zm6reHrHkK55uKxZHjS4IJQEIlclk3nOYOPW686T+tYk8O2AMxK3XFMm0r+Zgiqv939QNn6evq+/rzamAW/Z6DjyEJ+Djv3zBU/oS7S8DkNEsk5iqxRMwgCndv46H9dgE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snOx47NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snOx47NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE96C4CEE9;
	Tue, 27 May 2025 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366191;
	bh=01Hd7+D9LM27uwNHf+FUqx+9M2UAuaWvXmY8eqmQXV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snOx47NB1BvhEnkSskuKp9nS/aFPo3xKAgw5FerK1sPXfJcyVPsgj9hdYNBIK5Gxn
	 v27D+tglRfRRZ/bwc3keWNQAD2OE1W1ltAG4LfLEtwCENf9VvHx0o8ZmOsFKHDas3U
	 gmkca7vrIjZZJog2k+JO4EZvkqsWLpLdEvYA84fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 609/626] spi: use container_of_cont() for to_spi_device()
Date: Tue, 27 May 2025 18:28:22 +0200
Message-ID: <20250527162509.747746092@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 1007ae0d464ceb55a3740634790521d3543aaab9 ]

Some places in the spi core pass in a const pointer to a device and the
default container_of() casts that away, which is not a good idea.
Preserve the proper const attribute by using container_of_const() for
to_spi_device() instead, which is what it was designed for.

Note, this removes the NULL check for a device pointer in the call, but
no one was ever checking for that return value, and a device pointer
should never be NULL overall anyway, so this should be a safe change.

Cc: Mark Brown <broonie@kernel.org>
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2025052230-fidgeting-stooge-66f5@gregkh
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 4b95663163e0b..71ad766932d31 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -247,10 +247,7 @@ struct spi_device {
 static_assert((SPI_MODE_KERNEL_MASK & SPI_MODE_USER_MASK) == 0,
 	      "SPI_MODE_USER_MASK & SPI_MODE_KERNEL_MASK must not overlap");
 
-static inline struct spi_device *to_spi_device(const struct device *dev)
-{
-	return dev ? container_of(dev, struct spi_device, dev) : NULL;
-}
+#define to_spi_device(__dev)	container_of_const(__dev, struct spi_device, dev)
 
 /* Most drivers won't need to care about device refcounting */
 static inline struct spi_device *spi_dev_get(struct spi_device *spi)
-- 
2.39.5



