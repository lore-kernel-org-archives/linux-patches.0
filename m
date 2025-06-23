Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0672561A8;
	Mon, 23 Jun 2025 13:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684795; cv=none; b=InltHysyxpZ+rA3iIc2ZsimUt0E/jjtMEoxRVmFZ2R7aXUZVIDw+cGeIQAKo8grfo+aNOfmCXR8DZOjudXkoIBlJyvSa1kYKUQ4/xmuSOLP1QDQWbu/fqjCXe1c++HdzUSjPefqpcTMBj+GoZk36xckY/l1MkZUvcudVMGZrOC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684795; c=relaxed/simple;
	bh=hwLN4D+uW4NowzYsVOY0gpugnUTfLzDb6+zxNyPy0ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KncZL9s96zolk0CdgQC8unp8NN/XSOt/4hVMt8K8ZAMUUwUxqm1c4BO3Cex5WO5fJ8VMcN3DkjQDRtu+0L4loXtc8XFEOU7uQEwQ5p7yz7hoancbroMsy6JDLwJwzYvH6EbQoDBYNvI9wreGru/8deISjCrrLPfZ51FAD4KZOck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu1Z21xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu1Z21xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4837AC4CEF0;
	Mon, 23 Jun 2025 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684794;
	bh=hwLN4D+uW4NowzYsVOY0gpugnUTfLzDb6+zxNyPy0ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu1Z21xTbK0oWh9FqPNZdg2UjykiSTC9gdcT41RIzL6IV0xOOE/93OTNjsm0bfz5R
	 eBtZdgCgJP/6QF0CT0/tVLhBc2q+RMFsFPQGRfU6i4X0Q4BRq0otNXFGfZTConcxwu
	 3CBcYuMkm/lMNXxM0SoYD3nQa0rPXC1Ib0W0gi8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 174/592] cifs: update dstaddr whenever channel iface is updated
Date: Mon, 23 Jun 2025 15:02:12 +0200
Message-ID: <20250623130704.417460926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit c1846893991f3b4ec8a0cc12219ada153f0814d6 upstream.

When the server interface info changes (more common in clustered
servers like Azure Files), the per-channel iface gets updated.
However, this did not update the corresponding dstaddr. As a result
these channels will still connect (or try connecting) to older addresses.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -445,6 +445,10 @@ cifs_chan_update_iface(struct cifs_ses *
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
+
+	spin_lock(&server->srv_lock);
+	memcpy(&server->dstaddr, &iface->sockaddr, sizeof(server->dstaddr));
+	spin_unlock(&server->srv_lock);
 }
 
 static int


