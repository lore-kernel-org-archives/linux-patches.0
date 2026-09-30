Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5F51B178;
	Wed, 30 Sep 2026 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784964; cv=none; b=nYTI8dQQLXTpZJOo+ddsIWlxJotHPtNm/C5SN3duX7VdivvUCYCAXF4J2OQOQJqx3QGSwiETjvt6L6I8Vg7JkRPiS1SKhxwcqIcKAXmuRY9VJ1rQ8qtfRy4MqOUUg6MQU5mXv1QOhiCwKuRjRf/sUOm2hV0PazfLPX+S+zJcsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784964; c=relaxed/simple;
	bh=WOL6EVyCFbKsqGmwiaJAWT+/8CAZzn4Y4PTCcHb1fMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1njpLd9mDlKXUDpheU+JtXQeSMLZy8LjOaYeCAcwhTFp+NXl5AXYhkKJKnEYBJx3qMCph6h8Jc6Iig6oQ6aQqUA2dsFopP/vn9HAJ4kUB0yJ2AoeST9V3HmeH1OtpZIuQF/G0aLXX5YMI7nSKtUL5JunPcOE022mmH7Ne5/1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXo/KSvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXo/KSvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3C21F00898;
	Wed, 30 Sep 2026 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784957;
	bh=IrqyeAyh5p6qVzhDqLH8cf44nUD9QCdfLG9zYNnoxEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXo/KSvZRbxhoZX6XyA3OOZnJ+Y75cQEVBu8+RsOrwklbb8EPudPcF0+i9RGL4+rK
	 o6he9JgkMGBjjAAMLMnaa18mxwmyqZM7g8m+W/2bUM0/4mNzayWxcg3rGR81CtpKnD
	 dnXOxvqGWOt0LoyW8bv1I8HO9vsDQSRIES7lSkv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 338/982] smb: client: transport: Fix debug printing in __release_mid()
Date: Wed, 30 Sep 2026 17:17:54 +0200
Message-ID: <20260930152424.078327453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index b72d12a24056c..59063b26afe43 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -143,12 +143,11 @@ void __release_mid(struct kref *refcount)
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



