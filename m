Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C64754903;
	Tue, 14 May 2024 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683133; cv=none; b=lWS3xX/rCdXDLuhqh61Xpbz3sh6II9Tv+faKXwUkgZ8Y9PHVztqzBCrLLlZNR+Yy52Yg6pR5b5nilWVWM+pi3pAE6H8p/6RiGa9OEciRt383a9FWxWbkG/KeLGcxl1sHSyekbyI+qqwTtWbvXa1YexpGD+3frekJqE2sHf8mgzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683133; c=relaxed/simple;
	bh=mVlLpRDyR9p/953mgVFGVsjmYZ96HpUu+vG34tGSbnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/PhjErSY6c7MwXWTn+GrKQ+zWgBJpIjjkJ+qD0AVvSFUwFo+CrzPyA99uR7EsjrGcL8fR8Qf9gFzRA2m32izT4Xq1JMxPv/mqMJbhMcHa0soUQTYA8pVx5JJ0mTORa28IlnUQ601CrbSmw1RqJkCKJRvJ8y+d1BG9H6ShDMQo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLUFB8pf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLUFB8pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C50C2BD10;
	Tue, 14 May 2024 10:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683133;
	bh=mVlLpRDyR9p/953mgVFGVsjmYZ96HpUu+vG34tGSbnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLUFB8pfdoi10qgllOke8NKNEKixegCip+BeTeklI7q8Joy2HR3IVSY+wMLdb1qjM
	 z1Nxrs4kDC+ewwzoVmkj+bIpJdBuaxPBOoh83Lcyy8zCGABiUWwhy+LBDMuHGyU4E3
	 ecq4g1wd/8vVQn+rHSKmhY+VhTu71rXHolYFY0HQ=
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
Subject: [PATCH 6.8 171/336] uio_hv_generic: Dont free decrypted memory
Date: Tue, 14 May 2024 12:16:15 +0200
Message-ID: <20240514101045.059399686@linuxfoundation.org>
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

[ Upstream commit 3d788b2fbe6a1a1a9e3db09742b90809d51638b7 ]

In CoCo VMs it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

The VMBus device UIO driver could free decrypted/shared pages if
set_memory_decrypted() fails. Check the decrypted field in the gpadl
to decide whether to free the memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20240311161558.1310-5-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240311161558.1310-5-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_hv_generic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 20d9762331bd7..6be3462b109ff 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -181,12 +181,14 @@ hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
 {
 	if (pdata->send_gpadl.gpadl_handle) {
 		vmbus_teardown_gpadl(dev->channel, &pdata->send_gpadl);
-		vfree(pdata->send_buf);
+		if (!pdata->send_gpadl.decrypted)
+			vfree(pdata->send_buf);
 	}
 
 	if (pdata->recv_gpadl.gpadl_handle) {
 		vmbus_teardown_gpadl(dev->channel, &pdata->recv_gpadl);
-		vfree(pdata->recv_buf);
+		if (!pdata->recv_gpadl.decrypted)
+			vfree(pdata->recv_buf);
 	}
 }
 
@@ -295,7 +297,8 @@ hv_uio_probe(struct hv_device *dev,
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
 				    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
 	if (ret) {
-		vfree(pdata->recv_buf);
+		if (!pdata->recv_gpadl.decrypted)
+			vfree(pdata->recv_buf);
 		goto fail_close;
 	}
 
@@ -317,7 +320,8 @@ hv_uio_probe(struct hv_device *dev,
 	ret = vmbus_establish_gpadl(channel, pdata->send_buf,
 				    SEND_BUFFER_SIZE, &pdata->send_gpadl);
 	if (ret) {
-		vfree(pdata->send_buf);
+		if (!pdata->send_gpadl.decrypted)
+			vfree(pdata->send_buf);
 		goto fail_close;
 	}
 
-- 
2.43.0



