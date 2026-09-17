Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381C551DB11;
	Thu, 17 Sep 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665226; cv=none; b=BYSeXz1NBz2h9Q8xigBjSjSqBV9+2wHUvogW1W5PgJPYeKk48UIJIPJT2mJ+n+j0eu8YtDfEcb+E4/IaFb/EEIf/i5fNbHMwreR8rcU0aTTfKXcae6+l7wW75qkzH0gXJCHIYcSOyPFvBJq9DV8DaTGKpAUz+WLtCxuI92MZSqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665226; c=relaxed/simple;
	bh=/B8ToZPw9xzXRNcaoM7zX5zYnjWSelExqTo4rLI09B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyELcVxUl4rgJQowMDOEg8jIsvjFSKNCkaQ1EaaquzE0F4VgmcU+xnQsLtDnqr5OG9FkFBS77PHj4ZumaHhrOItTtwxXNvUDvXgfd291+wyDlcPy7C3XddeEoQucrr5yTBDgBzWKqV5TeD5Nz0txLZrPTpH/pOrgaYr1DDZULUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KI6ke3V1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KI6ke3V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535571F000FF;
	Thu, 17 Sep 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665224;
	bh=oFQbHvKvU1QkckhFLJT9H8efCB26j2YkJGBacA4HWVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KI6ke3V1ADbYsQDB5SDUD3HWbFTLTX9tjs7H5w1eUt/hV4h77DQzJ0A6U5nhBel4j
	 Gwa659UebdhRi5HUjG5Ix4F9bS+Npe2TKmW2KLXdQbvzkGN+C4/Ia5wARHYzrZY0wq
	 xhrD/Jj3q8sMijyPfc9dLxDwaevFt9dOEbut8Fcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0633/1250] smb: client: transport: Fix debug printing in __release_mid()
Date: Thu, 17 Sep 2026 16:07:08 +0100
Message-ID: <20260917151609.040366080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2d7140767dc43..4da3d62b6481e 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -105,12 +105,11 @@ void __release_mid(struct kref *refcount)
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



