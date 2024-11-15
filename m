Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72FC187FE8;
	Fri, 15 Nov 2024 06:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653946; cv=none; b=elqaME1g7+5FRRa0IcTPjiajFKIBW7uHB2XPH3c9q521PmRQaySdkolp3ceDj52fA2ms4OhlVG4M5bHLNUjGZ+OmhZ4NlQyoTZoVIa8aH8g+/BoOt/u3SMSXKTgesrN9iMHGh1XFlrufxixopKol5qsZgqVvef1msXC7Ifk7lZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653946; c=relaxed/simple;
	bh=cKUazjlMGfOKjT4nYI29YulVq8LoK8RYklJPgm/N1f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8pVhVv3NX0gLNXaSPxdl089i5DOhP5qlTpzxtGfMV8YYCAF4tgmBznZflwbV//HaZV3TsDY3mcCSKtUYaHwuJaLznOLCsVhaJP49wba8d0vBJvbFaDx2nVg5hXGSgZZPVXNKIr7E7KV7ugSCpFmogmyISB7307tPsulrS+hfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEG9W3b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEG9W3b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563C4C4CECF;
	Fri, 15 Nov 2024 06:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653945;
	bh=cKUazjlMGfOKjT4nYI29YulVq8LoK8RYklJPgm/N1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEG9W3b6gNwqPL2s0hsS7muc5UJRsFmsqPmWbX25SAuEp4wzXWvIIXYFOM+qzp0D5
	 dkDiDXobI6slPEDrqB/10bcz/hGrrGxDFNkuGfwXT+CFnXVKW/9B1V4unka3ZOeO+a
	 R727qUx9LMpPBxdVsLK0nZmCYCB+CfxAiQz4xR70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Omar Sandoval <osandov@fb.com>
Subject: [PATCH 5.10 82/82] 9p: fix slab cache name creation for real
Date: Fri, 15 Nov 2024 07:38:59 +0100
Message-ID: <20241115063728.498056759@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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
@@ -1004,6 +1004,7 @@ error:
 struct p9_client *p9_client_create(const char *dev_name, char *options)
 {
 	int err;
+	static atomic_t seqno = ATOMIC_INIT(0);
 	struct p9_client *clnt;
 	char *client_id;
 	char *cache_name;
@@ -1059,7 +1060,8 @@ struct p9_client *p9_client_create(const
 	if (err)
 		goto close_trans;
 
-	cache_name = kasprintf(GFP_KERNEL, "9p-fcall-cache-%s", dev_name);
+	cache_name = kasprintf(GFP_KERNEL,
+		"9p-fcall-cache-%u", atomic_inc_return(&seqno));
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto close_trans;


