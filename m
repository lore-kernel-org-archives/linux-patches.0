Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEBA1FB3;
	Tue, 27 May 2025 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368400; cv=none; b=s5JOVLiwWH5YBkT56XizwAKCnkBksYyu/pJxUtCZg7WeuuLdpRJG00i+9wOhTxN6ZJ/JCljC2kFs00+28Zcju4g4FIXpjLYT1HuP+Glld/93YcMUVkrj298o9jvMnFncf+eEJKEs8d/R75M5ffzfob0JFkKXd7ByStkHZW3Z+JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368400; c=relaxed/simple;
	bh=TUP/JyOmOf/77pJkuwua4ARUaaSN6Ljng3RFVyqKVA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUMnDlIaNHe0npSCSyVIxn9Tf6VbrLwxR6cLQu1AFwO5BTxVbtbB1EjkFG2gaqsAi3hVZ94/DTLomYJjgzfAYHKYdiTrq6uvlkJBtASQTRgDda0dlcJgudUajNSYpmWEqv0upas3EIxFYVM0MzUIl3q0JrPHiE9e7kfWDbqyLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de3Mrbpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de3Mrbpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A770DC4CEE9;
	Tue, 27 May 2025 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368400;
	bh=TUP/JyOmOf/77pJkuwua4ARUaaSN6Ljng3RFVyqKVA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de3MrbpmIkvDhLhktaUj55Q0Z96dd7g+5NvEoMvlV73qFF88GJj8SZhC0HlVPDrCT
	 mrj5FytLe+hWYXhklPIIp6SOWyMjGpomNnB/zifu9rKN0GXHMdFyuNAGVwFr2w9kwp
	 ECNO6MHlRBlieFi78pwUVbmuv0Jmvwzg8hJZv+Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 694/783] devres: Introduce devm_kmemdup_array()
Date: Tue, 27 May 2025 18:28:11 +0200
Message-ID: <20250527162541.391433077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit a103b833ac3806b816bc993cba77d0b17cf801f1 ]

Introduce '_array' variant of devm_kmemdup() which is more robust and
consistent with alloc family of helpers.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 7dd7f39fce00 ("ASoC: SOF: Intel: hda: Fix UAF when reloading module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device/devres.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
index 6b0b265058bcc..9b49f99158508 100644
--- a/include/linux/device/devres.h
+++ b/include/linux/device/devres.h
@@ -79,6 +79,11 @@ void devm_kfree(struct device *dev, const void *p);
 
 void * __realloc_size(3)
 devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp);
+static inline void *devm_kmemdup_array(struct device *dev, const void *src,
+				       size_t n, size_t size, gfp_t flags)
+{
+	return devm_kmemdup(dev, src, size_mul(size, n), flags);
+}
 
 char * __malloc
 devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
-- 
2.39.5



