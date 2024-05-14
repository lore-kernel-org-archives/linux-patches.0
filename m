Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3178B54903;
	Tue, 14 May 2024 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683142; cv=none; b=guku1h414VO4oQMaZcOw+yyLbgMCct6t7ViTFGDQmohQV9769FIxnGuhvckaTqy8RS9BLVJtwPFCm8d6AFjXpzBFq0VrX9/eeiRXNbOZtxfPhzLj5aEq/FDpOkZb/1ucW6x/lSVpztxGiR3hU8FCCvJNp82QcKB8GhY+jCL4UgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683142; c=relaxed/simple;
	bh=t8o94IorgW5ro0uq/Z9PbUmCAzJIpf3Kp63HPDh9ZWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDonf609Kn6cnPv8EkeumHqUYFA1xAh+8Z6DmJu05nC/+GXkafrmDo8XR8m+/pyKx8tVIvOcuhs4vQ/x6Di2uV0dAy3G84CPjA5X1VO/daS89bRSClKX5jRFXAuMZE4NJGx/XW0LqCeFCbYToL7NESBa1qm12WzGRCRGBxijpjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/rCjD2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/rCjD2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B6AC2BD10;
	Tue, 14 May 2024 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683141;
	bh=t8o94IorgW5ro0uq/Z9PbUmCAzJIpf3Kp63HPDh9ZWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/rCjD2Sb2J23fvdazGKYw5lo9yARtumO4xuuU9I+sL3jOHdou0jSD8lxjplIpKFb
	 w1V0RnQM0qfe1NFqC/+6nElldwhXSHNGD9731iIKNGJmqGKptr2+P50OioxiMtJbNp
	 aCnjKhycMpzLREg7hgJmge44YlGmXyzKfBQGu+Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 172/336] Drivers: hv: vmbus: Dont free ring buffers that couldnt be re-encrypted
Date: Tue, 14 May 2024 12:16:16 +0200
Message-ID: <20240514101045.096893326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 98259b4925029..fb8cd8469328e 100644
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



