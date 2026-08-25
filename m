Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E55481244;
	Tue, 25 Aug 2026 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665048; cv=none; b=V3E24TD5/ouUDq7f8m4VuRup63Vk3zYvBAp88I28puOaNExHCCtnjBHGKVjA0yQAn8fKhZKtiTSXJ+Uib46p9Shls0AipljW93Is6RVQJ7DDIv6TQgx8bFLB4dmT3fAdMEB6Ynlre2UyZloSWhDUAIbE07ixEex5Ana3FmEn9EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665048; c=relaxed/simple;
	bh=5PhfTR12FtEAk6kQuMsiIel0EN6xHPVLRIHoOFEruHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvnsXBPlg2RKKc2q5mT2SQkNe4MM2Fc7M3fmmxouw/akzL1OllHqmiCZCJSeIPyo5bH1MK3MMp92sVZ0Z5iAa70ywfif/AAY7uh57UXi+3mEcjDvFfn/px0rvW4Zvojpwl3Q3zxx7N9bQpR7UFl/55Dn3u00mtFfkVVJMmbqedE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytCQyP00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytCQyP00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCA61F000E9;
	Tue, 25 Aug 2026 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665047;
	bh=oQmIMVWVpA7vC6fBSAgDTLrumYnPJ6l700GSqFeCW+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytCQyP00WMx62c4OLWuxKvp/Z+/u/mhM5ndS0856UZT6WJfef1eKqoaR5F8u0fMAn
	 WEx31E5ciFRf8ahL2ezTZSybBkiPt4OTCVl+Z9qyCPs6YC/w1JX5NuRAptBeY2WzkB
	 AcDcVnY8lcdzs+9CYJGw1Wdrajh2mOjiW9re5yuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 053/101] nvmet-auth: zero the AUTH_RECEIVE response buffer
Date: Tue, 25 Aug 2026 15:25:31 +0200
Message-ID: <20260825132544.083996543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 3ddcfb013322aa37eaa7a0d344b73079c38dfa21 upstream.

nvmet_execute_auth_receive() allocates the response buffer with kmalloc()
sized by the host-supplied AUTH_RECEIVE allocation length, but the
DH-HMAC-CHAP builders write only a fixed-size message into it. The full
allocation length is then copied to the wire by nvmet_copy_to_sgl(), so a
remote initiator receives the bytes past the built message -- up to nearly
a page of uninitialized slab -- during the pre-authentication handshake.

Allocate the buffer with kzalloc() so the unwritten tail is zeroed before
it is sent; conforming responses are unaffected.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -557,7 +557,7 @@ void nvmet_execute_auth_receive(struct n
 		return;
 	}
 
-	d = kmalloc(al, GFP_KERNEL);
+	d = kzalloc(al, GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
 		goto done;


