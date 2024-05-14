Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665627602F;
	Tue, 14 May 2024 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685207; cv=none; b=En4gBOD5YZr6/Al8At7TquKCCpCDZDRfa7Ex7QmVMlFMBMACVgAXZyEtcqDHJ8F4LgJS2C73VEXLQSmnjrLndh17mkVvWTA+A0VpVWIagN8fXGMkMf97dj90/CsCOh8jQ1zYECkvIhwW2tlpH8U0Uy8P1JOWLGVUD07VuTg6058=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685207; c=relaxed/simple;
	bh=ksbO1mhsVybdyBxIQ7hkeNHiXYqYjmqCdtcQymOS+Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBlRERJQwLX9CWKYwIDCiODH2BXaP4my7dPA1FeIeE1brn3thSLJ8jl+kmeN6zw0nwdP3tEXbpbRJhWBezDP4SZ9OuJ4yrig7nDxTQoYzXnaJ9bpicHlH6HRQ02AnB3Hljd9OOBg4x9HmcEgmEVstAxkbkOChaTAuDBTaY0hchU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKiN0Pjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKiN0Pjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E750C2BD10;
	Tue, 14 May 2024 11:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685206;
	bh=ksbO1mhsVybdyBxIQ7hkeNHiXYqYjmqCdtcQymOS+Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKiN0PjxVlJARFnPQZXIGvAqIruLTCpdV3nmpoBBQBr/y6jlKIvKF2fcioIOFPWDP
	 vuyzXfkezPKI6aRLHas04JRCrde1UZHnR9oXCQqBW2bBb0fyMexpFhRl+qPi9bGwrD
	 mPh8EoPYweAEWqwOjI7+MLb8Qw6tdcI9sgqbyfEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/301] Drivers: hv: vmbus: Track decrypted status in vmbus_gpadl
Date: Tue, 14 May 2024 12:17:03 +0200
Message-ID: <20240514101037.995332144@linuxfoundation.org>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit 211f514ebf1ef5de37b1cf6df9d28a56cfd242ca ]

In CoCo VMs it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

In order to make sure callers of vmbus_establish_gpadl() and
vmbus_teardown_gpadl() don't return decrypted/shared pages to
allocators, add a field in struct vmbus_gpadl to keep track of the
decryption status of the buffers. This will allow the callers to
know if they should free or leak the pages.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20240311161558.1310-3-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240311161558.1310-3-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c   | 25 +++++++++++++++++++++----
 include/linux/hyperv.h |  1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 56f7e06c673e4..bb5abdcda18f8 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -472,9 +472,18 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
 	ret = create_gpadl_header(type, kbuffer, size, send_offset, &msginfo);
-	if (ret)
+	if (ret) {
+		gpadl->decrypted = false;
 		return ret;
+	}
 
+	/*
+	 * Set the "decrypted" flag to true for the set_memory_decrypted()
+	 * success case. In the failure case, the encryption state of the
+	 * memory is unknown. Leave "decrypted" as true to ensure the
+	 * memory will be leaked instead of going back on the free list.
+	 */
+	gpadl->decrypted = true;
 	ret = set_memory_decrypted((unsigned long)kbuffer,
 				   PFN_UP(size));
 	if (ret) {
@@ -563,9 +572,15 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 
 	kfree(msginfo);
 
-	if (ret)
-		set_memory_encrypted((unsigned long)kbuffer,
-				     PFN_UP(size));
+	if (ret) {
+		/*
+		 * If set_memory_encrypted() fails, the decrypted flag is
+		 * left as true so the memory is leaked instead of being
+		 * put back on the free list.
+		 */
+		if (!set_memory_encrypted((unsigned long)kbuffer, PFN_UP(size)))
+			gpadl->decrypted = false;
+	}
 
 	return ret;
 }
@@ -886,6 +901,8 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, struct vmbus_gpadl *gpad
 	if (ret)
 		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret);
 
+	gpadl->decrypted = ret;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 6ef0557b4bff8..96ceb4095425e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -832,6 +832,7 @@ struct vmbus_gpadl {
 	u32 gpadl_handle;
 	u32 size;
 	void *buffer;
+	bool decrypted;
 };
 
 struct vmbus_channel {
-- 
2.43.0



