Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D7234DB7E;
	Fri, 21 Nov 2025 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733430; cv=none; b=fIeUzmH6BhJ5fKb9gPGL+PvVtKhT31+tt2nVUz8pjZE1qqJOuo6vAcu4SffVf/JWMv+POh6RstvRuTGQRP8Loa0ySDqB1U7eNGdl42WnSgiT4LqXqMdSlhz/6zEbyQNpVBaEtjzuFkXXblq89FaXYdHDVWBa9yQAfA2dNC3aDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733430; c=relaxed/simple;
	bh=3YcOL0CHmiVzBRhEStjx385ulnMTCN0nVLLXO+E55bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXixc3mNj+Xxdp8+8ltFbCZIVy+e8jcLykbCI5KZS4CcY88Dn11ExwuZiVhv2N0YEcSxhcjmy3wfJo+IEw1RfbcpQIYEO1vwUOpQ0LFI1Y71EL+ZpDEBQ7ztJ6ka0J/MdLXXWByw5nlSLFloQpSNLZf3qaNee4qvxTOzpQw58xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zIYNbuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zIYNbuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3788EC16AAE;
	Fri, 21 Nov 2025 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733430;
	bh=3YcOL0CHmiVzBRhEStjx385ulnMTCN0nVLLXO+E55bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zIYNbuYPf5ef9z8hRfY7YZU9LXFu24x3LKWCxIfguVamoF61OxjullK117yixego
	 ZL6jVte7mjWjLjyeX1UG9psGiVK2VJOZKBQZk8ezJdOu+OOKsnO2GkSY+DyqvvXykB
	 Vs6xJvDZWYzINShsCbqUf1gSzZ6iqi8t2geqV6oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Karstens <nate.karstens@garmin.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 466/529] strparser: Fix signed/unsigned mismatch bug
Date: Fri, 21 Nov 2025 14:12:45 +0100
Message-ID: <20251121130247.592847878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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


