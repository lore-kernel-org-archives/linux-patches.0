Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29E35BDDF;
	Wed,  3 Dec 2025 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779908; cv=none; b=aUXZ6cvrTs3Gw4ZJndZUgWvmxrW93Bjo3Ulc2aZR1zWDRekWtUNbf2ydFhpn+pabj3FMmc7zrPJ3wHyQwmjCAEWVl1K5QnMX5eKpRoVYzA7cXabv6ShhPUQ1skZXQKcRQHfKLtud025xr0Pi9/w+GvdSZgdjJLw4U9gjffb2ZAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779908; c=relaxed/simple;
	bh=2dg+v68oLsc4MwxciPdZKf4DM+qsNi3fL18j1us0krE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3ZUSpV9L2u2DL4ve6odHq+3mXuXCNyPbX/sb16oru2+OXr9FB9Uv5IGjo+l8iFH+LLjr2XfGl9jH+QFZI5PxpdcbLFJ/xIomFPzmOhSBSA2l0apn1WOFGHWQyXiA4q3chUMccsBK8xS3UQGCnyvK1pzjVA/ZasMXW5DSaOuogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynKPauet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynKPauet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E61C4CEF5;
	Wed,  3 Dec 2025 16:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779907;
	bh=2dg+v68oLsc4MwxciPdZKf4DM+qsNi3fL18j1us0krE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynKPauetDxO7i37mZTVsiquS16/Scg5WX9/9/TUYvId550mKmMt69bkQ4Q240Dq6v
	 8UtYrcAVpt8ZmQOo5oCk+tWAwT8fEAfB5V6sK88JLrBsTwPLHrW+a1pneKif8gHea2
	 0OajqqQMcoJmSTpyFm6CezySDhyU+pWzpzzBKX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Karstens <nate.karstens@garmin.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 399/568] strparser: Fix signed/unsigned mismatch bug
Date: Wed,  3 Dec 2025 16:26:41 +0100
Message-ID: <20251203152455.305766913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nate Karstens <nate.karstens@garmin.com>

commit 4da4e4bde1c453ac5cc2dce5def81d504ae257ee upstream.

The `len` member of the sk_buff is an unsigned int. This is cast to
`ssize_t` (a signed type) for the first sk_buff in the comparison,
but not the second sk_buff. On 32-bit systems, this can result in
an integer underflow for certain values because unsigned arithmetic
is being used.

This appears to be an oversight: if the intention was to use unsigned
arithmetic, then the first cast would have been omitted. The change
ensures both len values are cast to `ssize_t`.

The underflow causes an issue with ktls when multiple TLS PDUs are
included in a single TCP segment. The mainline kernel does not use
strparser for ktls anymore, but this is still useful for other
features that still use strparser, and for backporting.

Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
Cc: stable@vger.kernel.org
Fixes: 43a0c6751a32 ("strparser: Stream parser for messages")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20251106222835.1871628-1-nate.karstens@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/strparser/strparser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -238,7 +238,7 @@ static int __strp_recv(read_descriptor_t
 				strp_parser_err(strp, -EMSGSIZE, desc);
 				break;
 			} else if (len <= (ssize_t)head->len -
-					  skb->len - stm->strp.offset) {
+					  (ssize_t)skb->len - stm->strp.offset) {
 				/* Length must be into new skb (and also
 				 * greater than zero)
 				 */


