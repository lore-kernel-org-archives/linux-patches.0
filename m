Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9AF3B8948;
	Wed, 30 Sep 2026 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794783; cv=none; b=RyloJi18sYPlC5SYy1JeDCF82dFRnMaePCuXOqFh2Ll1dMuhrdl/9JkUj/3dWF1psd804/au45vzf/Pu1WvYO+JtvWjgyHhMidVLaz9lw/cAblLC3VXEu4qjEv3QECzedzBbStWwNmd+tPX5hej71uapMX7pnTJ+RXmtWm/ygz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794783; c=relaxed/simple;
	bh=j168HTXTREKVue6UxFWYQDYk6ZyJctUexyGTLN878w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knW0ArGJIgZkHkPXjsaeOcJm8JYipcpgr4j6gVfxWEbpadSZ4lofdqObemyOm2FmYSjJEHu2mZPnHG0CKzw6AANde1abEIU+q8wAem8XQ0QJM2uBLw9R3AXjqD9dU6I0JybmpFBL4ECeclszlIfvIyWI8Fn/xahDpvuCIU1RJJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIimCMI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIimCMI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD3A1F000FF;
	Wed, 30 Sep 2026 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794782;
	bh=Uvxvo4gDgewRl2HdUd+JleZ4XeRPTrMEMqZqpG1wvHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIimCMI8Oo74JvVk1JMSgPPpAdhCzvefdbIpcEF0B7PhwZ+NUpaM6tBapXDFVE1x1
	 KMyMEMqaTcaACxFsZggtmZ/NrJtmrs0sWPqwlPgDeD+p85reFBrNp0a6M4uEBowjVw
	 mNRDMJ2T3RRkOoahoNua6qvhUb4x+SXB8vHcVhvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0333/1193] cifs: validate idmap key payload length
Date: Wed, 30 Sep 2026 17:16:57 +0200
Message-ID: <20260930152441.551382398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 455488cd5054bcc59db40fa1cc2c004031a5b2a5 ]

The cifs.idmap key type stores its payload length in key->datalen, which
is limited to U16_MAX.  Accepting a larger key payload truncates the
recorded length and can make later users interpret the payload using
inconsistent bounds.

Reject oversized preparsed payloads before allocating or copying them.
This keeps key->datalen consistent with the stored data for both inline
and separately allocated idmap payloads.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 230b98b3a272c..1f596d2493bd9 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -69,6 +69,9 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 
+	if (prep->datalen > U16_MAX)
+		return -EINVAL;
+
 	/*
 	 * If the payload is less than or equal to the size of a pointer, then
 	 * an allocation here is wasteful. Just copy the data directly to the
-- 
2.53.0



