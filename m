Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B450260;
	Tue, 23 Jan 2024 01:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974674; cv=none; b=OX7uXkKmv2plELo2WBNfcJyaDNYONzck392ey2jgIas0ATIU8sggqjBE1Mf0RMFLYHBhwAGOCDYRi9KD3V2fk/qq+0Ln0TlcznfTtkaszZiN6hVbeNxe8wWll5nuFIBLFZEMkKgruTK8bPttQBBySpr6do6voE7d2/iS7DXOasI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974674; c=relaxed/simple;
	bh=IGz/bK2zENLHZS30+zZ2mYCMvoOMh8uFP8fA1NYVYno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSnaZPGos6GKCjPMszdigYCV3pLnMZdkoxgfkWsbYTesfQGdo3QP0FYwPPRLAEy3P9cmABQ+N0O4LzMK6GnrEutMmW92qme/XoecggBGaWuu4ZjAQc/yYz6HMu67sLxinBrL3iLMrIHnGgFxfTy2vM9yViRVG9AEtkT7JP4JUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFJOgsZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFJOgsZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77A6C433F1;
	Tue, 23 Jan 2024 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974674;
	bh=IGz/bK2zENLHZS30+zZ2mYCMvoOMh8uFP8fA1NYVYno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFJOgsZOVdye5c7aeKDWFpkfGb0Ke4YzZKaGgCaIQmqky3hO7llfwxP2+nyvoJT/u
	 xFL8vRTBMq0M7vIkRpoFq73yo8sThZN+zhvi0gnJC0/lnbD6O2PG5somQQyquU8Vrq
	 4RdGXpiQ/zUI2KKcg7RCJNm4kZZD58iI729VA0E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.15 244/374] keys, dns: Fix size check of V1 server-list header
Date: Mon, 22 Jan 2024 15:58:20 -0800
Message-ID: <20240122235753.249416350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


