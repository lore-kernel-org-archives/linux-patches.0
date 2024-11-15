Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5745F3BBEB;
	Fri, 15 Nov 2024 06:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652917; cv=none; b=icsg1AWfGfWabKik9WFse2sWf9Dnw0Sz3hmMnRCFnMxEUS5AohMqE3RlIf5iGFlTzwMX1RQ1VeBViQUgclJTTwfWiZ2KKCeLCuVZBwxkgLvD9cWKsW3fvvQotft/0lJ3gO/9LoMfH3ydCfkFj2R8X/ZDzpOozRNbHIMvmN5RpA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652917; c=relaxed/simple;
	bh=f/0EmlfGxOQI2a7fS6tgAs/UWotwYl6XVO3E8ueY1pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIfwBSY6j/paD7bVyVKG8uGakwVO9lYPHcz5Fg191HtCNWActD8EsS1iLxSJXtre5sWTHXVIQupCvUdsjiqxC15+yTizyOHyhYvtOZ+JBVOLHhuYKED9WVuiuUDjtlFXL+ePYfH8O2+D9RJ73SdpgWkpf4rEHI/FIVCsEExF9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrB3ftuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrB3ftuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B33C4CED0;
	Fri, 15 Nov 2024 06:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652917;
	bh=f/0EmlfGxOQI2a7fS6tgAs/UWotwYl6XVO3E8ueY1pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrB3ftuk6tvpQxA4cUL0ZDgJgEW9Pvy6BQfV7DOJJpyk6XP+ilzpCJiwBZPbZMt4i
	 BdTuxhK/f3329iVGvB3nvfqZya0stnjzBdub5M4jS+g+nm0T3r0ISEk3vrRIwfRRaa
	 7b9bsVU6zShlC01yO1P9qpgJPOx2oa9RsrHO9cBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Omar Sandoval <osandov@fb.com>
Subject: [PATCH 4.19 52/52] 9p: fix slab cache name creation for real
Date: Fri, 15 Nov 2024 07:38:05 +0100
Message-ID: <20241115063724.729942143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a360f311f57a36e96d88fa8086b749159714dcd2 upstream.

This was attempted by using the dev_name in the slab cache name, but as
Omar Sandoval pointed out, that can be an arbitrary string, eg something
like "/dev/root".  Which in turn trips verify_dirent_name(), which fails
if a filename contains a slash.

So just make it use a sequence counter, and make it an atomic_t to avoid
any possible races or locking issues.

Reported-and-tested-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/all/ZxafcO8KWMlXaeWE@telecaster.dhcp.thefacebook.com/
Fixes: 79efebae4afc ("9p: Avoid creating multiple slab caches with the same name")
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1016,6 +1016,7 @@ error:
 struct p9_client *p9_client_create(const char *dev_name, char *options)
 {
 	int err;
+	static atomic_t seqno = ATOMIC_INIT(0);
 	struct p9_client *clnt;
 	char *client_id;
 	char *cache_name;
@@ -1071,7 +1072,8 @@ struct p9_client *p9_client_create(const
 	if (err)
 		goto close_trans;
 
-	cache_name = kasprintf(GFP_KERNEL, "9p-fcall-cache-%s", dev_name);
+	cache_name = kasprintf(GFP_KERNEL,
+		"9p-fcall-cache-%u", atomic_inc_return(&seqno));
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto close_trans;


