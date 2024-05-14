Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8CF76028;
	Tue, 14 May 2024 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685230; cv=none; b=Sl4B2fvs6N5qr7Df8JSCfq6uKBOZW+YREt6nT78GywjcL/bxrhsrqr2bdphBEHdeK42BRJGQw+6F7SaPVCovLX55z6EGdZWscYthlGzuc7wE9OkiL3jM3sMsywyX/RBZ2OCTRbusVSaOuJTpWIDHeUto1smMX+jg83S10hR5tJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685230; c=relaxed/simple;
	bh=c2tqDX+Tu/5PekSXAYf6jSF7f2+zYHUOK8Yg7gmVDZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUPIE0r8YK9pGlBAUroWoOwkqNd9X9aTvV/XeVti+B5hbWKRdx8Qa7suypMrUw7sqPhVsaDqre9O/TY4IGnLSW6IlCgwK8hcMYoHkkAH5pRhTCqMNN7cfb3qux/6sKGknHQL/QdBWUGbcXuKFtukz9TUkDVOOIcamp7v1Uibkos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvYdkx59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvYdkx59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C34C2BD10;
	Tue, 14 May 2024 11:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685230;
	bh=c2tqDX+Tu/5PekSXAYf6jSF7f2+zYHUOK8Yg7gmVDZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvYdkx59Y8v16JdHp2kehrvafRChTlQoDwtRNROEjZyQgdLhr33s+a7OvBeigEmRz
	 AGn5ULPH9oeis5501WCI9E7c0cO8u+4NnSeMnLwRpX0GZQgepd4wOMgSkA/e8vlKGc
	 U/FwDhHSdIVGSuM0LiHO+uH31FJqaPLa2l+XpnVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/301] Drivers: hv: vmbus: Dont free ring buffers that couldnt be re-encrypted
Date: Tue, 14 May 2024 12:17:06 +0200
Message-ID: <20240514101038.109221594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 30d18df6567be09c1433e81993e35e3da573ac48 ]

In CoCo VMs it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

The VMBus ring buffer code could free decrypted/shared pages if
set_memory_decrypted() fails. Check the decrypted field in the struct
vmbus_gpadl for the ring buffers to decide whether to free the memory.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20240311161558.1310-6-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240311161558.1310-6-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index bb5abdcda18f8..47e1bd8de9fcf 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -153,7 +153,9 @@ void vmbus_free_ring(struct vmbus_channel *channel)
 	hv_ringbuffer_cleanup(&channel->inbound);
 
 	if (channel->ringbuffer_page) {
-		__free_pages(channel->ringbuffer_page,
+		/* In a CoCo VM leak the memory if it didn't get re-encrypted */
+		if (!channel->ringbuffer_gpadlhandle.decrypted)
+			__free_pages(channel->ringbuffer_page,
 			     get_order(channel->ringbuffer_pagecount
 				       << PAGE_SHIFT));
 		channel->ringbuffer_page = NULL;
-- 
2.43.0



