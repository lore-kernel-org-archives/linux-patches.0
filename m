Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A791182D7;
	Tue, 27 May 2025 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366232; cv=none; b=naacFHjMt9lqaNCxqKPJbYaOYPdJlZiPtFRoz3jcFd92XrK46WPTkKy6OpzdtDmHKRdN22qaEIGGOoktKYrHuk1Fg3lFtsIxw5lVgH41yX3vgEfszrytte9m0vFLnRDbj+pY/WhQ4QSftFl+MNitjdrbhOgJVf1jua0D7hKZHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366232; c=relaxed/simple;
	bh=eO8pmykyRouOG8LT8/8HVyJ+RUpVmgTpNdDM9r9JMhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwifA9qnNb28L5Jfjww6UAGCmGdfSdrlKZqilDdVjBzq4EXZ5o3mb2MwLnCEyhLx0A6USWzfBiiJV6kqHBbycYQW343AlgaqcdffRgetn8jDqWj6yBUujh4T0rH3andIpnkpj8ddB1p8JMKI87pEQvyBWYjYyTbG2PnTQ95HkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPNuj6iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPNuj6iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA7FC4CEEB;
	Tue, 27 May 2025 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366231;
	bh=eO8pmykyRouOG8LT8/8HVyJ+RUpVmgTpNdDM9r9JMhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPNuj6iz1gb5UvIMwk/Zf1y7uWlgclWy8CdhXOMn23yTASYG+phIrXWazJt0k8SCW
	 Zn80RhdiwogiJkSg6KoWiw23gr/VUIHhDWe0smgVSZAj8a25uo9x0dhAQg0J6iO2aE
	 CDZh7bstAQZMzOay++OH2kJUTNPo0DsrpY7uHrKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 613/626] err.h: move IOMEM_ERR_PTR() to err.h
Date: Tue, 27 May 2025 18:28:26 +0200
Message-ID: <20250527162509.907793180@linuxfoundation.org>
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


