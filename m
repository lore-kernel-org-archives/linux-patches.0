Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7E43D890F;
	Thu, 17 Sep 2026 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668754; cv=none; b=C+p87rX+eiYb3Msx7HoXZFRDlMR+DMUj4ZtwY91EomlBy8U7ELdKfFexuPQIC1ooCCci56azAG2HXTle8gmjNeyWN5JCyLdZNl4p/6G43OeQOKrXFgIjVmxHOJ3kWLDu6xJB3Ma7KX6W9B6vufVjcZYM2bemttKN1DMqOUbtuVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668754; c=relaxed/simple;
	bh=gfbzEGIqFSZfy0d89y9YiQIsiwpS6P7QyLAx1MYjhxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifYZYRY3RyPCP+PBg8BJGs3PW/JPa1PoESksmWSoZX1wBQRXkF0JdXaTQIS2DD5CfzOssNfVOreSe2Lirwvxunk5CLcw6d+AA/TxXV2UndrYPec1ipLmLCyBC3T6aFxoZCav8Xf8MrEjs1ymbEkhfiZgqAUu8dKGgdNAcVHo0C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V83uoPmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V83uoPmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD631F000FF;
	Thu, 17 Sep 2026 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668753;
	bh=DJfzQmv7Ey57CEmNeDXIWGzBnZkCHTw6YC3F/DRryZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V83uoPmKD9xeyhW8w3Gi6hlTvOjvRCSrFKqZWFrI3uULuFyNfy5lOznSEx6Vx3J72
	 /yqsVzdnDaUbEqQRRbSZ+S/TVtEiN6Mrr7Ty82+eM5vqak4vlWIDyJUUF4J7UU3YJl
	 HYJB3IiavS+kdRbKbCNJ7wvde8ZbSlp60Jl0POqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0531/1102] smb: client: transport: Fix debug printing in __release_mid()
Date: Thu, 17 Sep 2026 16:07:54 +0100
Message-ID: <20260917151553.130947442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
 fs/smb/client/transport.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index d7dbbd908cd90..c3940d3ecd5f3 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -144,12 +144,11 @@ void __release_mid(struct kref *refcount)
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



