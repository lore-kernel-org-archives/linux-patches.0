Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F483A7F4C;
	Fri,  4 Sep 2026 05:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499033; cv=none; b=hZgxfziMoqwUILdDmkx2SHQHywlai7Fhs4jVVQHqRTUK4FSXWOdqLh1Vr3Zf0GQ11P7rdHrHatKZ4MabmRJhSDFjr5CWBqfBOq7Xw0ifMxwA43dqtvlhi/SVO69aP1AS3pPlYikLcEdFveE7U54EPbGwGHFdhO+30bHMRcDSG2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499033; c=relaxed/simple;
	bh=7ISmhpQyEBaosRmoEJBqSMhOUu/YmTZcxe6LgWo96oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLffxWDhc9z8c55zXJJY9opEfJiuODSSAeG1g6zIHWpkLreG02jdS8YihzAwKBd6gNaFZ/V7VvrBFoCS9SFS1YwkN4rZDyWQtZ71QG8kyX7h/m75g/epkNeUvKK1dBjpXgZ0Q4WXGL6nD7AuKlYF3J3MN/blgIMxpLqDaj2WUfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESkpRHoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESkpRHoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0766F1F00A3D;
	Fri,  4 Sep 2026 05:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499032;
	bh=eQUc84FmdIuxMjoTys1xQY/UKTK4Sv/FT+3CmOv2aRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESkpRHoBLmpk6Qr7V+HzKROjfODVZdSBIGdTKjDYMKkQ9x8gAq2UmgTY54sgAMaC3
	 EXcqlhTiZ3a/pU4DYHpTt1pv12U0/Srcj99XnOlLULFKmFzj9SO6cF3yhQUeHCBX2q
	 ZLKDUYeKZ115O0Ldeba3b8j2SrMhd0iiu3vjRu6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 7.2 275/713] ecryptfs: release message context on send failure
Date: Fri,  4 Sep 2026 06:54:03 +0200
Message-ID: <20260904045810.005794646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 219644a3ad5518217b2d62cad6d2c36a2308c949 upstream.

ecryptfs_send_message_locked() moves a message context from the free
list to the allocated list before sending the request to the userspace
daemon.

If ecryptfs_send_miscdev() fails, the context is left on the
allocated list and cannot be reused. Move it back to the free list on
failure and clear the caller's pointer.

Fixes: f66e883eb618 ("eCryptfs: integrate eCryptfs device handle into the module.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/messaging.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -286,9 +286,16 @@ ecryptfs_send_message_locked(char *data,
 	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	rc = ecryptfs_send_miscdev(data, data_len, *msg_ctx, msg_type, 0,
 				   daemon);
-	if (rc)
+	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to send message to "
 		       "userspace daemon; rc = [%d]\n", __func__, rc);
+		mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+		mutex_lock(&(*msg_ctx)->mux);
+		ecryptfs_msg_ctx_alloc_to_free(*msg_ctx);
+		mutex_unlock(&(*msg_ctx)->mux);
+		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+		*msg_ctx = NULL;
+	}
 out:
 	return rc;
 }


