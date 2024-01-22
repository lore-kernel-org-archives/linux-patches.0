Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1385112CDBD;
	Tue, 23 Jan 2024 00:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971479; cv=none; b=jXXl3uOMBmVYCQGA5nNQMff7PrzAMOjkzgkNX1dQjSkOQBt1H+KPEQ4YKwLG0itAz10oWAp/j72oqHlZp7MBUxRoVSw6DmiSc6DBaVAFSv5RD0AvZBB4DnBKSgUyww3IpZ+5jHpa8q9lU+D6+A7VRdt5KaMzyEbxbY3hjb720bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971479; c=relaxed/simple;
	bh=04iJCYRbLQR65wA+/Ylx332JvKn5DdsIf0ygInjXMyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9KA6TRsVFmY644/cy+sJVSyZBn0Sdwv7t5EJT4MCZZdXJT+JFCC/MahmvCVK0C+brJhW1lEKLY9zayGep6fLjg/GIIn+aEau+5xjq6IOHTDeuOc4vawNpDHiZKsmub0zGUD21M3IAHH1NCaM8A2Xwvn8nGZmtCmNk509LMnBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaUsrJXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaUsrJXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F85C433C7;
	Tue, 23 Jan 2024 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971478;
	bh=04iJCYRbLQR65wA+/Ylx332JvKn5DdsIf0ygInjXMyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaUsrJXN1H55pqiCMSgUrT5we9I+OowSAhZY7FLdIZej/aTzPTPdDZ/XZg2hcfJWm
	 gyFlOEOi6kbQIpNJlCSrbD0woSbCstkOBDgzhvaW4cnFMLtPIqj4JU5Wwksy2Dt4DR
	 qyiLssmyhP5W6s2i/8JbM6xNGGqBDNzjklfm0p3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 6.1 249/417] keys, dns: Fix size check of V1 server-list header
Date: Mon, 22 Jan 2024 15:56:57 -0800
Message-ID: <20240122235800.504467747@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


