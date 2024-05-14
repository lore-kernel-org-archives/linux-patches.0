Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04B813AA5C;
	Tue, 14 May 2024 10:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683111; cv=none; b=dBrYCGBDErCJ6Zonl8zPud4sWz9Yrqscjx5BO7T4IiY+ixFwlPhYO1fRQa8XasI3v/vffxkTLLoTi2qLscqKvXSVffDeFUCiseWdhJ/j9Z57Pkvy+zn5XbCdsIPzcmoRqZTTuWdHzmdhudWKVS+IodprTPyTioUWyJbtLxHZmzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683111; c=relaxed/simple;
	bh=ySlTYPtMjBI72p+lwi9ss/L9CF+6ya+bM9GN8JEqpwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvMI+ULc/kpHWrqoGxSwRzIvQAw7mMo56T7F3XLGg3BuqsAjeeNok+2INPwlXbVFNuE4og2j+puF9Cq2Y0B+zbbe85BDjYuXTSIow+rrgWccF1fLnufytvSFsJT0UB5crBzES9YHfmql22G1iZJjfTMh4cfJyd3Z9jvBmxK3mpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arNnj4Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arNnj4Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6C0C2BD10;
	Tue, 14 May 2024 10:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683110;
	bh=ySlTYPtMjBI72p+lwi9ss/L9CF+6ya+bM9GN8JEqpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arNnj4Ql1d08XOjGCYqT5xAU9i4x5JdoRcG0QHoVtr8Z7M26aMm7YF3OWoKcrMSfw
	 ibmpzxU6gKHyLCBuC6Pu0F8g24Z21VvfGNotUDkRGihTsCt2TQX8CxdyF4sgxSrPUW
	 ydBpTpwvhsMtnqlgMrQFQmIaIqh90A0PwIA0lBe8=
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
Subject: [PATCH 6.8 168/336] Drivers: hv: vmbus: Leak pages if set_memory_encrypted() fails
Date: Tue, 14 May 2024 12:16:12 +0200
Message-ID: <20240514101044.946352599@linuxfoundation.org>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit 03f5a999adba062456c8c818a683beb1b498983a ]

In CoCo VMs it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

VMBus code could free decrypted pages if set_memory_encrypted()/decrypted()
fails. Leak the pages if this happens.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20240311161558.1310-2-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240311161558.1310-2-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 3cabeeabb1cac..f001ae880e1db 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -237,8 +237,17 @@ int vmbus_connect(void)
 				vmbus_connection.monitor_pages[0], 1);
 	ret |= set_memory_decrypted((unsigned long)
 				vmbus_connection.monitor_pages[1], 1);
-	if (ret)
+	if (ret) {
+		/*
+		 * If set_memory_decrypted() fails, the encryption state
+		 * of the memory is unknown. So leak the memory instead
+		 * of risking returning decrypted memory to the free list.
+		 * For simplicity, always handle both pages the same.
+		 */
+		vmbus_connection.monitor_pages[0] = NULL;
+		vmbus_connection.monitor_pages[1] = NULL;
 		goto cleanup;
+	}
 
 	/*
 	 * Set_memory_decrypted() will change the memory contents if
@@ -337,13 +346,19 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
-	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[0], 1);
-	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[1], 1);
+	if (vmbus_connection.monitor_pages[0]) {
+		if (!set_memory_encrypted(
+			(unsigned long)vmbus_connection.monitor_pages[0], 1))
+			hv_free_hyperv_page(vmbus_connection.monitor_pages[0]);
+		vmbus_connection.monitor_pages[0] = NULL;
+	}
 
-	hv_free_hyperv_page(vmbus_connection.monitor_pages[0]);
-	hv_free_hyperv_page(vmbus_connection.monitor_pages[1]);
-	vmbus_connection.monitor_pages[0] = NULL;
-	vmbus_connection.monitor_pages[1] = NULL;
+	if (vmbus_connection.monitor_pages[1]) {
+		if (!set_memory_encrypted(
+			(unsigned long)vmbus_connection.monitor_pages[1], 1))
+			hv_free_hyperv_page(vmbus_connection.monitor_pages[1]);
+		vmbus_connection.monitor_pages[1] = NULL;
+	}
 }
 
 /*
-- 
2.43.0



