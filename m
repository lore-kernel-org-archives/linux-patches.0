Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210987;
	b=BcGvNYkgAtkZtoveQ36bHpHyAzfJWfcFNQIKtag+cUAtaeLDp4mr1aKqkmCgXo7dRVCn
	 QTxWU77mOc5YA3PHrXat6ryn784wHjyrmhzjod8oEjk9+fhPncXWwmkBLQ1NyukwD+g/Y
	 UjIUA2az8IktjDT+oBU72qvlLv7jWiYB5zQqx4BcGSvaYkKPQsFRZJqGl5g5TxvIwjWlJ
	 fdatpiAt6k2pu34xubN0fmm6cy3vYbp2UTvP+d7J8lZ/lx5hHM7u/T7SbqU/kmApDCW5E
	 G7OnFcD4KHg5BsCgNwsLYaXSTscopAXjKbUiARZmDg2fpX9UKsWFaFfozFmyguiyyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0QqxZl0S9ALZymRycoWmo7tgUeN9xFSeM+w02Kc9bg=;
	b=iGhJnHllVazVnvMFJzxXANn/pEnBESEN/UuSoAhokIwPgJr4KUfNzri9mSHLkQJgVtVo
	 tuD8tg+dKRGDpSik5tl2bJOEXx4N2rvV6QtvSxw2nqcV9Nn2oOcRqsC5LbiXPuaVvfkVA
	 lE5V26NunnZuDGhUwyhoXiicOCGS7a5Rz7YGwlSIhVpMzepLeOGG++cBemIMpDKRbH0sG
	 rJY65morKVCC1W+bC6hcGqMDtvO3+Al5pdNH2t0mAXgyeqB/KtUG6Xj1s7UAWFWR3kpie
	 C5xx9J8mlSwq82yvS4h9XCVipAD5Sm1T8Hr+f2rAQA8x6g98RCd8rYbvjHvmYll0q9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdGuF7H+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B57A60A2611;
	Wed, 28 Oct 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdGuF7H+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6FE1F01829;
	Wed, 28 Oct 2026 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210987;
	bh=R0QqxZl0S9ALZymRycoWmo7tgUeN9xFSeM+w02Kc9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdGuF7H+wkqryE0UN/x4CWKpOv9gTMIAV898/HMXwtwURyPAHsl8d5dmFpBaKCG+h
	 KGBJONTbvtAnuJDWzpKoHezdoa6chQIejMcvlEIwl/v+uWdkKJ3x6K24Gp2uzpAskQ
	 mLyRRxohVMF2AlXZTcY3UDDXTP9fsGEzZnyOVZU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 217/571] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Wed, 28 Oct 2026 17:56:04 +0100
Message-ID: <20261028170013.152013360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -491,7 +491,7 @@ static ssize_t domain_show(struct device
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


