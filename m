Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF85218A2;
	Wed, 30 Sep 2026 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791276; cv=none; b=Di26fJnmA0ETewh8kxVveqs6bVnLE2iyfT9J14fPJXeQaT+eVzbMZS1783wrYt6Bv1/2yN8iWx3q5ZGLfnL3IjaEPZ2BwtngPq39l7B7/o6M1B/1cKloq1QJi+JyIKd5NJtwctxXhZ1B5+kjhVAUXeB37w8kyoMa1Jy4Eu/sxLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791276; c=relaxed/simple;
	bh=ayGyxp1u3vR48hD5+a680OWYlYATvng3GOtKUbKZKIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8N1+fBkaQazqZiAWgftATy3UlXcu6yFyZW+PYdVAI9s4As9Cgj1hadrU+G3FDOEDUunJRcWbhHx2YJxgyARjnabIj6qTIFJDF0gjX5x5e6/Y5HL9DVPrZW0LnVg9khbT/hEZdHpgvc6tyP/3EKDsbRrVZUUcQgPbva19BZI3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OC7fugI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OC7fugI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC831F000FF;
	Wed, 30 Sep 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791275;
	bh=Yjg8Ztw87H3jheluiUn4omQtVF0PR7q7uSuDN5Ffa/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OC7fugI5kzP0lJ1JN3t0PemFKc/lkB5D4HzHX6RRDT09ayAMd7MrBLxpRQE9qs4Wg
	 oOUB1V+EBa7HBP9bI1+WwJh8xRx0JhxANbW5vxg0iNSxdS4v5k3FXOxNoaOsqS/v+4
	 lcTDdRFteU9TJC2Y1VM1Sq+xLBC6ulFdM9vqvuk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/752] smb: client: transport: Fix debug printing in __release_mid()
Date: Wed, 30 Sep 2026 17:21:55 +0200
Message-ID: <20260930152403.573644594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d83a21bb26015bfdd79b0440fe816b271b8bbab3 ]

Long time ago during upgrading printk():s to the respective pr_<level>()
calls one misconversion happened and nobody has noticed that. So,
previously printk(KERN_DEBUG) + printk() worked as one long debug print
since the trailing '\n' is only present in the followup printk() format
string. The culprit change missed that and split the message to two on
the different levels. Restore the original behaviour to make users be
less confused in the most likely never happen cases of partially getting
that message.

Fixes: 0b456f04bcdf ("cifs: convert printk(LEVEL...) to pr_<level>")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 65a225a9c6cf8..fbf0b154169a5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -141,12 +141,11 @@ void _cifs_mid_q_entry_release(struct kref *refcount)
 		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
 			       midEntry->when_sent, midEntry->when_received);
 		if (cifsFYI & CIFS_TIMER) {
-			pr_debug("slow rsp: cmd %d mid %llu",
-				 midEntry->command, midEntry->mid);
-			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-				  now - midEntry->when_alloc,
-				  now - midEntry->when_sent,
-				  now - midEntry->when_received);
+			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
+				 midEntry->command, midEntry->mid,
+				 now - midEntry->when_alloc,
+				 now - midEntry->when_sent,
+				 now - midEntry->when_received);
 		}
 	}
 #endif
-- 
2.53.0



