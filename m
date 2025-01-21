Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165A1F63EF;
	Tue, 21 Jan 2025 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482286; cv=none; b=HScKcB1ts3zhApw/1R7pn29qIErypJ6a+lJItTALodig7idi6cJVJidh7Ii+2knoD/ecJ+NHDYeVJWs6zKjtcs+KpQQ9paFOSTAgZvlN8kv4b8feArIovNJduekyF0vSWJAN93JptrM8EF8iO2ueGUnrsa5pVVCfE2PjaWuRTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482286; c=relaxed/simple;
	bh=xxpuAPT7FMHrzsE6o6wL8xnErBIDLSQu/JzUpdAm7AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXGnnazfYxdax5MYdl3affUBNDsaklV+pww2ERxP59hcCHnPY0Gtu80EaRI6tIXoQ6ngidXFCRETp62GaQ/vaIE3CAv6lYArmWw6Fr7MMNhf/q9Giic2fIWNgxB8sd3YDIBaSngDKf9uT0wy7JcvOzcjXwF1yRXomYjpGSX5gcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFJaHSDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFJaHSDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB51C4CEDF;
	Tue, 21 Jan 2025 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482285;
	bh=xxpuAPT7FMHrzsE6o6wL8xnErBIDLSQu/JzUpdAm7AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFJaHSDfMrckmSFq8BFWB+CZQ5UYAeSPnqnCmPrF6eohepP0Iuz7vDQ6+M1tBxV0y
	 IWHywpcQAkPs8Os9vf8WSkYrLe4RVfBYkExm4/32gVXYhHi91VAobNTDmHFt3a2Jth
	 4oQopoVK3iqtPWNf/d7EvZov6YvV3saGLI3WJSuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/122] net: make page_pool_ref_netmem work with net iovs
Date: Tue, 21 Jan 2025 18:51:12 +0100
Message-ID: <20250121174533.930128755@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit cbc16bceea784210d585a42ac9f8f10ce62b300e ]

page_pool_ref_netmem() should work with either netmem representation, but
currently it casts to a page with netmem_to_page(), which will fail with
net iovs. Use netmem_get_pp_ref_count_ref() instead.

Fixes: 8ab79ed50cf1 ("page_pool: devmem support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://lore.kernel.org/20250108220644.3528845-2-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/page_pool/helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 793e6fd78bc5c..60a5347922bec 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -294,7 +294,7 @@ static inline long page_pool_unref_page(struct page *page, long nr)
 
 static inline void page_pool_ref_netmem(netmem_ref netmem)
 {
-	atomic_long_inc(&netmem_to_page(netmem)->pp_ref_count);
+	atomic_long_inc(netmem_get_pp_ref_count_ref(netmem));
 }
 
 static inline void page_pool_ref_page(struct page *page)
-- 
2.39.5



