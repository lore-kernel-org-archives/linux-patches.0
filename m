Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829083;
	b=Vjf3k5Kv8rzC7SjbL+ZrE5lKftiwxC7dKGHpmAfFn4N+qQpHiMIxkV66ZyQ04TVDZhcS
	 lEJq8PVLV3w6Rsi2ZiYGTtXhBeIHkABvPUEDMldeTsjGBD9X4XPM8yYg2Nt/9fQTzxTW2
	 2o4wKycJ03VaQzrOBgQcbzoChgc0S9AlN3Aov1oixwADIWX5QYm/YaZ22/FJoCzUAZ9sy
	 kFigfcsu6cVXjU5jl+n3OfTU1b5LZUc0Ay9K9yTXk8o2NjFLdLvoFZp3zkfnHWiLCQxb8
	 PbZz7iXPKDV9g9ME/X93yeBox/k9xK0GufO9082DXpfb33BxdmycLwb6BZK58ZtI3SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKAWhysZQkjrxMB/5yGoZTSlfbi9X8gtggwxpOZ8+z4=;
	b=J3usTVEx5BumcxYRxlBgFpiAXDDnbAcyx/qMyd0b8S8U93chE9b2SX614JrX6aBnlt06
	 2jRtRcd0+OCJ/3npF3lJlOxf5v5FYhtOc2yTYwRn5susCxF484gGB/b9NDaiwpK6Wyw6n
	 5OaUywTAoM2W/ddcmwJn37DDI3d++1r9h0r1l1LLyY46ZOs4W6y6+o2VZJNz1LqSjZE5n
	 EOAowsEw9Yj8pC0bn5RAzLZ2nDxpdIXKLZv2oOaz7u7GS1ICAfZYV2eeX6R9pYs+GiJi7
	 SFRpR6zfqOu6x9o7/EfVAslfvEjHivpA0elJKTNfQMxbRWXOXhUIt6LkhHkQLGjruCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOR2FtqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4339C6070328;
	Wed,  4 Nov 2026 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOR2FtqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57101F000C1;
	Wed,  4 Nov 2026 21:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829083;
	bh=pKAWhysZQkjrxMB/5yGoZTSlfbi9X8gtggwxpOZ8+z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOR2FtqDbnyUlVNtTaCOq6Tx7w9RLCpL8Db9QGogsUxGSYgP9JpxXUsy17oijURpH
	 50yMxTOUovDLNMqtTywGzppXFJRUEUomZTingsk7yX19TKDvtvEnu7DRhDwLuMHzAb
	 HIQEAvUPF0ZvuWRI8TNMYYhPULWh+BfwkzHlZ+v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 394/547] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed,  4 Nov 2026 16:09:38 -0500
Message-ID: <20261104211049.498782839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit a0cb76dc3b2919af8257fc08b4f9a79a35442483 upstream.

decode_devicenotify_args() gated the trailing ndc_immediate on
cbd_layout_type rather than cbd_notify_type, so the flag was never
consumed and a multi-item cnda_changes<> misaligned after the first
entry.

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback_xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -312,7 +312,7 @@ __be32 decode_devicenotify_args(struct s
 		memcpy(dev->cbd_dev_id.data, p, NFS4_DEVICEID4_SIZE);
 		p += XDR_QUADLEN(NFS4_DEVICEID4_SIZE);
 
-		if (dev->cbd_layout_type == NOTIFY_DEVICEID4_CHANGE) {
+		if (dev->cbd_notify_type == NOTIFY_DEVICEID4_CHANGE) {
 			p = xdr_inline_decode(xdr, sizeof(uint32_t));
 			if (unlikely(p == NULL)) {
 				status = htonl(NFS4ERR_BADXDR);


