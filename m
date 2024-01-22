Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713CA65189;
	Tue, 23 Jan 2024 01:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971668; cv=none; b=LZQ2QEPFQ9n8Eva5rxgLB7h8rbkx2hx79QWQPxmNZtCzKG8tvHcn68LaM97VH7o/YFpH0Z2SQnhc9Ay9ynuHQZeSegXF24ZoKmdLNZIKyG0ty8fVfrw5re4mG6ol1bIVXSC2EASJAXyEAzgpmtR6asazzycvocs65v4QS8NWgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971668; c=relaxed/simple;
	bh=ABfn0+NyjJZ2DXJrht572OdongEe40Zr+Q8EpgZ8wwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY31JBICaP220M39sCsrAro2s02AvJ9CgbnPz5l+GtP4/9kIuVK6SpxlaFVXheJqllsBtwtlEx4Z2DGAdT6kxtdaqc5N7th7Qi0q0+idtHxlYULzNU0qpEjU5qEVPw+fMhoGJvEut0Vlo4/aCJOCxV0WMB+jaYHJpXRjhVxM88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xwd5qLYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xwd5qLYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B75C433F1;
	Tue, 23 Jan 2024 01:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971668;
	bh=ABfn0+NyjJZ2DXJrht572OdongEe40Zr+Q8EpgZ8wwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xwd5qLYejNZgkGa4++UnawYP+TrqJm0jfgr3hUORy9pn3woRMkgd138cLwAMXGhPD
	 K6HaoIAZ1H/3OPVcL67v0Kzx95DjR5wEDd2QgWoF3GKcyeD9Ita0enqqsRazdNGiXt
	 S1R9I5jvATGpOuSwRKqbbqAQvT0oZEnisD84eGrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.10 197/286] keys, dns: Fix size check of V1 server-list header
Date: Mon, 22 Jan 2024 15:58:23 -0800
Message-ID: <20240122235739.704035165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit acc657692aed438e9931438f8c923b2b107aebf9 upstream.

Fix the size check added to dns_resolver_preparse() for the V1 server-list
header so that it doesn't give EINVAL if the size supplied is the same as
the size of the header struct (which should be valid).

This can be tested with:

        echo -n -e '\0\0\01\xff\0\0' | keyctl padd dns_resolver desc @p

which will give "add_key: Invalid argument" without this fix.

Fixes: 1997b3cb4217 ("keys, dns: Fix missing size check of V1 server-list header")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/ZZ4fyY4r3rqgZL+4@xpf.sh.intel.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dns_resolver/dns_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -104,7 +104,7 @@ dns_resolver_preparse(struct key_prepars
 		const struct dns_server_list_v1_header *v1;
 
 		/* It may be a server list. */
-		if (datalen <= sizeof(*v1))
+		if (datalen < sizeof(*v1))
 			return -EINVAL;
 
 		v1 = (const struct dns_server_list_v1_header *)data;


