Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C1C7080D;
	Fri,  4 Sep 2026 06:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502012; cv=none; b=J5Yl+d7Mitc1RDrSNf+F5Lm2XQM4HOndYsiZclbtEbVFN2LzErQP2IAtiAKOaOR8G5lXLIFS9zUSrDb374M+ZFhAg/1E6bjjSNqJjq3VrsSYEN/PQLX48bytdDJ2C8WImbsIJUph7H0OKOY89589/sC6eZYWJH1lCthr+wu8D4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502012; c=relaxed/simple;
	bh=jioL9MEDuaIcG+/arEnZdeBygW3VYatxz8TmdxpcFfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZY4qFpWPzJwzrVWuZ4EnmG3dssRZ26ZTosvZzHqT3kWK93Kv//96PVI0AXO6Vbdr69PCPVXMaLVxvPkkks+PXk3yNPFVId2f40EKzH/7hyqic4zncy9aMdoL3wexbFN4//UnAG7a5ETsR+UclwLWK58LIVJmJDaosB2mWazGJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gaim9atb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gaim9atb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838891F00A3D;
	Fri,  4 Sep 2026 06:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502011;
	bh=98uCjk3fkzFOm0j0op1E2PVHXltbwsrzJIzvDUIc+rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gaim9atb6dsd+3CabuK8MkjhYBfKNOUQVLlgV4V4cxUp90ndxslGj6BJjlVIH8ynq
	 PMlS+1UGVthm5lYXd45HqLlIwpr+EDXK8qC6mkyUISHORQ2NvjVFajhm9PcVaadYXL
	 soUzbTOp7ifz3bd3lSVQrFq/4/inZJE+2JbkA3fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.12 041/403] misc: nsm: bound the device-reported response length
Date: Fri,  4 Sep 2026 06:57:24 +0200
Message-ID: <20260904045735.748733416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 808e530654a5354e6df78863a5d61e4d44e67235 upstream.

nsm_sendrecv_msg_locked() stores the virtqueue used-ring length reported
by the NSM device into msg->resp.len without bounding it to the response
buffer. A malicious or buggy backend can report a length larger than the
response buffer; parse_resp_raw() then copies that many bytes out of the
fixed buffer to user space, disclosing adjacent kernel heap (an
out-of-bounds read). The request path already floors its length in
fill_req_raw(); the response path lacks the symmetric check.

Clamp the stored length to the size of the response buffer. Well-behaved
devices report no more than the posted buffer size, so conforming traffic
is unaffected.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260620-b4-disp-a54b7dd6-v1-1-79d1f236a854@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/nsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -243,7 +243,7 @@ static int nsm_sendrecv_msg_locked(struc
 		goto cleanup;
 	}
 
-	msg->resp.len = len;
+	msg->resp.len = min_t(unsigned int, len, sizeof(msg->resp.data));
 
 	rc = 0;
 


