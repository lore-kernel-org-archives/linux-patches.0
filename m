Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1401434E2C;
	Tue, 21 Jul 2026 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664623; cv=none; b=ERqaO6nJBr1/idqg7svBNSH4Xxm3TYWK+mT5xuvOFNTP/FERpXaaBeKPHt7dNj13FrnhZr1CDrB/8PHUGcmJ1U1KmNH5ZdVvS6Z1PqBO/lUS6anRjBwk3eFF4UQ4GrOAtDgLA4iRCdMu6Wa2NkTgU+tXPAYo0ucij9bHQraG7ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664623; c=relaxed/simple;
	bh=LTvta63NATnEDhycUkNABYwtPr6C1c6irts/J/a9CH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVmN9RpIRNjOgflddCHkuQwL7lktgRElPGUyLyALTBPlgTpn2KlbqBe6+LbIddWdZk+kmk+7c/zC1U1PuLztrCqNlPBLCYWrTj7mGFMWoa/Vwtzanr3q+eZzWyACyBYf7hV4jPgvRTu2TkwWjAerRrA7Y9xiyrYtofSGsyNiEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpU/wRzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpU/wRzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5FA1F000E9;
	Tue, 21 Jul 2026 20:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664622;
	bh=iZVDk0axy6hK+D+G6EWYjlcxyThLiGF0ljXI01vveU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpU/wRznFzm6Iunyr3YTfcIF0XJxk4mH8YwzXwKs9Bdrk+YtAYn/f8v/rdn1iSpy2
	 YiHrfiyvcZJ+53wa+13mdQDCFnrWDbZxT92YTckuA/ewAxflAflvqVHlIVUucnAdRC
	 pxzq4vkEtVTms0LplHJwpET8T0My4V2AY3AP/YEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 1270/1276] crypto: ccp - Fix leaking the same page twice
Date: Tue, 21 Jul 2026 17:28:33 +0200
Message-ID: <20260721152514.511386980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit 5c52607c43c397b79a9852ce33fc61de58c3645c upstream.

Commit 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is
missed") fixed a case where SNP is left in INIT state if page reclaim
fails. It removes the transition to the INIT state for this command and
adjusts the page state management.

While doing this, it added a call to snp_leak_pages() after a call to
snp_reclaim_pages() failed. Since snp_reclaim_pages() already calls
snp_leak_pages() internally on the pages it fails to reclaim, calling
it again leaks the exact same page twice.

Fix by removing the extra call to snp_leak_pages().

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Assisted-by: Gemini:gemini-3.1-pro
Fixes: 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is missed")
Cc: Tycho Andersen (AMD) <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2102,10 +2102,8 @@ static int sev_ioctl_do_snp_platform_sta
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
 		 * transition either case back to Hypervisor-owned state.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true)) {
-			snp_leak_pages(__page_to_pfn(status_page), 1);
+		if (snp_reclaim_pages(__pa(data), 1, true))
 			return -EFAULT;
-		}
 	}
 
 	if (ret)


