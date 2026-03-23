Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946120125F;
	Mon, 23 Mar 2026 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273862; cv=none; b=ASKZwJ0GvwMc55HmAlTl0sxV3ejyvV4U3trhsqmfqszXO3uMbtxOdhdPuV7ke1aOp1vnvhB+LdOg265T6B9E/zHJpN+lJOyJ3zZWWo3oIhf3edTtrYgrzBQBdPE6+LAssK0DSQJpKlR4AzXvziX9YzvOgxK67EkOS1/sIu2QDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273862; c=relaxed/simple;
	bh=YEAgzvquC4WdxAk583jIy218c9PGZlUPYakQGMSWZic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyGhIcDZ9cfrbj3fqYL1lsjeQCflfU45hZHbLSIBmg9BYgI1rGijUmS8jwdWOPCHNKp9JKhjcgnaZ7GwhHcSue6vKqTTk7Mc3C3bS8LrYrRPcerbovKMOjK4/Z9eftZNLZlb12VYFGjcdyGvCnQIKJwjQsr1Z8r0f5w24lggIMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkWTKKc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkWTKKc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55935C4CEF7;
	Mon, 23 Mar 2026 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273861;
	bh=YEAgzvquC4WdxAk583jIy218c9PGZlUPYakQGMSWZic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkWTKKc6Gz8bp2YrtKAHhXKM8iweJE1dGc3aoxNOfiSxTftOePH1yyGfG5F6NZf4C
	 a4NfFlvc+M6xWv4Kuoet392QOWSl0r1am1koSleYFgqdH83Yfc3WRYXS6TJhMirjIb
	 uiWUncN5vRO1kVsDbjjnwLtSXT/0G2V+VL+dnhjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 008/220] crash_dump: dont log dm-crypt key bytes in read_key_from_user_keying
Date: Mon, 23 Mar 2026 14:43:05 +0100
Message-ID: <20260323134504.843299727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 36f46b0e36892eba08978eef7502ff3c94ddba77 upstream.

When debug logging is enabled, read_key_from_user_keying() logs the first
8 bytes of the key payload and partially exposes the dm-crypt key.  Stop
logging any key bytes.

Link: https://lkml.kernel.org/r/20260227230008.858641-2-thorsten.blum@linux.dev
Fixes: 479e58549b0f ("crash_dump: store dm crypt keys in kdump reserved memory")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/crash_dump_dm_crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -168,8 +168,8 @@ static int read_key_from_user_keying(str
 
 	memcpy(dm_key->data, ukp->data, ukp->datalen);
 	dm_key->key_size = ukp->datalen;
-	kexec_dprintk("Get dm crypt key (size=%u) %s: %8ph\n", dm_key->key_size,
-		      dm_key->key_desc, dm_key->data);
+	kexec_dprintk("Get dm crypt key (size=%u) %s\n", dm_key->key_size,
+		      dm_key->key_desc);
 
 out:
 	up_read(&key->sem);


