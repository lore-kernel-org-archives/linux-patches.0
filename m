Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3AE280CD6;
	Tue, 27 May 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368684; cv=none; b=eztpPpwHG2VIouAX00LMnovlooyIDHhWPcLjYoFVS35JRiWJue87uz/UQyS+yboOuY0OdEpp6edhlz5wbcoqruM1T+Q5HYwBhgYpk/jI3myDM2q/k1L0pRdxqeQS3wDayVBzNZLwbBWH1t99zJA2j8QtY3WqgxIqvmKDOx3DO90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368684; c=relaxed/simple;
	bh=o4fJbsWY0FPGtlXPOCWBIXSeNjbGx4fPxe+9E/fq7Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHbeVE1ONnbnnMdyvsLR2Ob1QDZ5D04+m3lE72VpIonxNieetwtC4zLqXdtIawc59AlgeyqldFJE2zh7oXK8GFtrCKJ/rh6c8vMp8dYCS9aITFQMOqiraH06l7c/JxqSFHem+sa3vCPq+IlkUrFFHjD+yDXZvK1HCzaRnqWEV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDp8GyiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDp8GyiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D3AC4CEE9;
	Tue, 27 May 2025 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368684;
	bh=o4fJbsWY0FPGtlXPOCWBIXSeNjbGx4fPxe+9E/fq7Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDp8GyiTLKMLX2wtabtU9T1etxV7XatNFdMF+mvSdmfycw3dthjTC3ZFyQ8TO5es/
	 FgRcC/ENFItfKVSZceCXVpt8cJB2QemRKhLnyxXs3yZWI/67+O8Ci+PAysE0KSPqWy
	 77etVvgBs/s0xbOcukTluQ6iP32qa8H3khcqWFF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.14 776/783] err.h: move IOMEM_ERR_PTR() to err.h
Date: Tue, 27 May 2025 18:29:33 +0200
Message-ID: <20250527162544.730719766@linuxfoundation.org>
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

commit 18311a766c587fc69b1806f1d5943305903b7e6e upstream.

Since IOMEM_ERR_PTR() macro deals with an error pointer, a better place
for it is err.h. This helps avoid dependency on io.h for the users that
don't need it.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/err.h |    3 +++
 include/linux/io.h  |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -44,6 +44,9 @@ static inline void * __must_check ERR_PT
 /* Return the pointer in the percpu address space. */
 #define ERR_PTR_PCPU(error) ((void __percpu *)(unsigned long)ERR_PTR(error))
 
+/* Cast an error pointer to __iomem. */
+#define IOMEM_ERR_PTR(error) (__force void __iomem *)ERR_PTR(error)
+
 /**
  * PTR_ERR - Extract the error code from an error pointer.
  * @ptr: An error pointer.
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -65,8 +65,6 @@ static inline void devm_ioport_unmap(str
 }
 #endif
 
-#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
-
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   resource_size_t size);
 void __iomem *devm_ioremap_uc(struct device *dev, resource_size_t offset,


