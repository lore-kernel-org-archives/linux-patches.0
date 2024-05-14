Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752496D1A1;
	Tue, 14 May 2024 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685196; cv=none; b=r/1u5eT2W1A4fesLck4RLF8k55CFRuCvTGZoDi7o7KdOaXT9XCnSjsuHY0vy0ABD8ULFmAOIK3nTDHvcaQb4I7krkO2sl4Nm6fRlyZ8n7lYRK8A2vu0BjDOkkzgA2/tSqILLa6lRLu07TkLqc31e/hjU22S0My20uf/fm15B/y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685196; c=relaxed/simple;
	bh=KzqFuDOEZ2wNtDNIUQMRDGNCr4nVBS7rvLjUs+Lgk4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRwPEknkxOqmBCRKlvQc2hVj5QVtRt5qD6PlIQumouzMDXzdk0OMftyO4X1jhKknCXolcBB9t2Z170RG1D0vE2Deuzm9Z04K/2mMtTV6j6WSrMXA/JJ2uRFh/twe8iMqIAS8YK7L5XvJl7fjBjU1RHqRFPF8FS2PqvX/cmXtXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZO6RX8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZO6RX8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE1AC2BD10;
	Tue, 14 May 2024 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685196;
	bh=KzqFuDOEZ2wNtDNIUQMRDGNCr4nVBS7rvLjUs+Lgk4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZO6RX8PZ1voh2bguwiNKe8ldo2O4ODWMNOkv51sKlLO9tn4Pw7ixgFkEloRb4BRK
	 tygn9gvEj5LoVzBh2BFNhYBx1PA5eU1ODk9FJTytvjva2RtqdjgQGzrLzeEqR0lnXB
	 dnuXJ3F23xSStNLyje3Zz5qNEoRhEtEnYfLouSuk=
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
Subject: [PATCH 6.6 151/301] Drivers: hv: vmbus: Leak pages if set_memory_encrypted() fails
Date: Tue, 14 May 2024 12:17:02 +0200
Message-ID: <20240514101037.957426397@linuxfoundation.org>
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



