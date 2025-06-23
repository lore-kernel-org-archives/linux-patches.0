Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D174315A;
	Mon, 23 Jun 2025 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714917; cv=none; b=G0gN7fw68SMarUKrv3d1lPbLc46lkI/FtBYrpi3yczMmY3GuxCkhzx2ovYuYXwCi5wiRqSpIWyz3w8Q+Xwt11T9T0mp6n9DGdL5QGjkmnlWK2umcoAqTqiG8cvwYsGinnRgeTF/lcKrb8vBrDnAgt32g11pvo1XQ+WV8ErYi/f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714917; c=relaxed/simple;
	bh=dhaCsYbXtocCG8sRDBVWLrke1+pq2ZPLTpga4Xyrfv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpid0FsZCaykNW+dch37HW2h0kjOuhXF+KnWM+W2c6BCOK63ivSvnbTcrg/lB89RUuxSadtYNFcwZPHZlfVu9Y9bz9t6YO0OQiKeFMP5vTlrC/oQN7aLDGn2Xnw5h4lpkNLLDHuEzV4TrNVWfqOX+QVrwW4AWzrwXq435xvds/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkhVVHBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkhVVHBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6150AC4CEEA;
	Mon, 23 Jun 2025 21:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714916;
	bh=dhaCsYbXtocCG8sRDBVWLrke1+pq2ZPLTpga4Xyrfv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkhVVHBetr/XpEFc5IYUygsBHUYR6r8ifL15z+r5k0wP0RGhUJNNKC/aVR9/vUxyi
	 PrWwTKL4njXOgsTeO3exeTBVaAy0d2FzSkUlFVjUz963IazJKVjhLcwsmbjq5nwM0N
	 2H4hwDp/C42taO/xMK1J63vksYAMRr+PGSd4u1Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 144/414] cifs: update dstaddr whenever channel iface is updated
Date: Mon, 23 Jun 2025 15:04:41 +0200
Message-ID: <20250623130645.654101876@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -473,6 +473,10 @@ cifs_chan_update_iface(struct cifs_ses *
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
+
+	spin_lock(&server->srv_lock);
+	memcpy(&server->dstaddr, &iface->sockaddr, sizeof(server->dstaddr));
+	spin_unlock(&server->srv_lock);
 }
 
 static int


