Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101C64C10D5;
	Thu, 17 Sep 2026 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660314; cv=none; b=Stka04vn5r/NcRKHyx1WKtMQHmLqRGBTGvcYhpO3Ql90JzaCODeNc2tSlRm2KkmF3ukZZN2LqwWFz5twNg5Ndb4P2Kk6obmPUg4a2N2ikL4Uhd+OrRHstYyx+iBYxYiBs1wDFmGiXrr0QI6WkiSum/7f80CZsRB1n+j8yhgT1iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660314; c=relaxed/simple;
	bh=WFpo00y8DkxPxZKRCsM2feDwKaIpUTVC8Xlw8wPzxsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWJv8LC6R7O3kt2LlknWeujucpkgPhv4O8E6tdt2ucuQKvRUi9Niq6pN9WRPRoj7MWp+jDRFXTGpHKSL+2IBNgmNHtwqP+rPXCbsZ5OE6fk9XrEFHeTsmQk7nc0WLXMJ6BNGd8xuD3DM2WO7qg+1HmKRP9Hpg5dB0KOWwQIu2Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3jYzpy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3jYzpy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BD11F000FF;
	Thu, 17 Sep 2026 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660313;
	bh=rdu5k0V1miqBA0A/ADQu6ramwHKgdUUB7eRMC23PoTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3jYzpy+OHDudFoKpEaN7zyA6+FjLQbg8+PqHPePCN7XTvvwvYfq/bSeyOu8HGBz1
	 Mr7WYHDWgcat+qO5I1YJ/ZY4xz13M0vwvcelafJsxHuytosU5c4ik+x48IumQ1BRLP
	 pLRtOa0na/h/HoscAmpVhERSqV6rmV961j8Pciy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 551/733] netfs: Fix uninitialized return value in netfs_unbuffered_write()
Date: Thu, 17 Sep 2026 16:14:19 +0100
Message-ID: <20260917151405.997669733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit f18e8774f4d3137fa0a5fb8ffa83d59a719666d8 upstream.

If preparation of the first subrequest fails,
netfs_unbuffered_write() exits its loop before ret is initialized. The
empty-iterator check can do the same.

For synchronous writes, netfs_unbuffered_write_iter_locked() may then
return an unrelated error instead of wreq->error. This is reachable
through CIFS if cifs_prepare_write() fails to reopen the file or obtain
credits.

Initialize ret to 0 so the caller returns wreq->error if no data was
written, or the number of bytes already written otherwise.

Found with Clang's -Wconditional-uninitialized.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-2-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/direct_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -95,7 +95,7 @@ static int netfs_unbuffered_write(struct
 {
 	struct netfs_io_subrequest *subreq = NULL;
 	struct netfs_io_stream *stream = &wreq->io_streams[0];
-	int ret;
+	int ret = 0;
 
 	_enter("%llx", wreq->len);
 


