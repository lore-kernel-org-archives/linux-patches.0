Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828853;
	b=NrwMG5oMMWi6FSVPXkuGG/bsUN7k2pcoVa78jYnC6bfJpNebzjWVMy65z0gOrFL1+Fnr
	 iXDSXljtwwkDPUr9VRLyyFhxcnqF/9PFiN54AUBIs014Yb/U8tP8R7OwcFs+YW2FBGr23
	 G17C1PcUsl6gtHEOu+T8FBHg5ILNaYqCnVoLSSkTeLvGgI2iu7KYZqoCrY5RAq2gB99aV
	 b5PgmhBj1MxDI/SJlDCQpZQxGhotMrEmUoEIjU8oCOdmfYPZVhUkiBMtyntCWlJT4gtk7
	 fms94LI4tv9RsdWj5GlJO+fIloG6giLY6hUtcW3gZfdWaa+VVJcN3+yDnWIkCVFlxTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GqS4XGd7VMFWYaLZEmAQLhaP1o5s9DM6n13ME+ehbJU=;
	b=WqN5KP6/5aHXJbTU1y4UC94Nbe9mliXAC2US1ez534M8dM1S/Cuktriei31Q69pXYNCm
	 1aRvM1Yssbh5CxiDYZ8Ae+ti7QjLTgDHN6BvUGUeevgks6QTKpzmCmtf3b9cBoCqkiIfZ
	 ujK7jQUk4GNXtOyeEhE8nFDLhT/JcIgMSsPN+dHu+e4jYweyRu4ztFVenTHmUsUzE0qCh
	 sJzcJwj9silb9Y11xBs2WJ5Ca+BHzm9YogYZY7sBWAj4RCcXsbV4y613eao12tSI+N3Et
	 Yp1B4dtEDRSNH6q0nOAqgWnn/dOzcubJMAWWsC2uJ0ewYxEPOLRZyF51++JmQLln0WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fysa5NqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A7606A32D;
	Wed,  4 Nov 2026 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fysa5NqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84D71F000C1;
	Wed,  4 Nov 2026 21:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828853;
	bh=GqS4XGd7VMFWYaLZEmAQLhaP1o5s9DM6n13ME+ehbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fysa5NqArZuL+FGvrZCUzDp6S5WCI3XUPml9jWnDSoJvvVLX7Dt0PWW9/v36TNxwZ
	 H+P6QrlL/zVIHL5KrkLzKE0mwglz6sS/KVBenmCGesiXtGg+0hoTaPIUUrVdG3Dikp
	 ubViEylDfrstFfD6o3ucPT0UzcFE3ZwdpVhFtzXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24c7c12d69e63c6d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 281/547] smb: client: stop processing a read response after a receive error
Date: Wed,  4 Nov 2026 16:07:45 -0500
Message-ID: <20261104211046.184124800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 51efca72345acdbedc4af76782d464bd15ba50ff upstream.

cifs_read_iter_from_socket() may call cifs_reconnect() before returning an
error.  The reconnect path aborts pending mids and invokes their callbacks.
The callback can then release the cifs_io_subrequest containing rdata.

cifs_readv_receive() nevertheless continues after a negative return and may
dereference rdata in cifs_readv_discard().  KASAN reports the resulting
UAF:

  BUG: KASAN: slab-use-after-free in cifs_readv_receive
  Read of size 4 by task cifsd
  cifs_readv_receive (fs/smb/client/transport.c:1284)
  cifs_demultiplex_thread (fs/smb/client/connect.c:1355)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)

  Freed by task 148:
  netfs_put_subrequest (fs/netfs/objects.c:267)
  netfs_read_collection (fs/netfs/read_collect.c:460)
  netfs_wait_for_in_progress (fs/netfs/misc.c:462)

Return the socket error immediately, as this path did before the iterator
conversion.  This also avoids adding a negative length to total_read.

Cc: stable@vger.kernel.org
Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Reported-by: co+24c7c12d69e63c6d@bugs.sh
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1317,6 +1317,8 @@ cifs_readv_receive(struct TCP_Server_Inf
 #endif
 		length = cifs_read_iter_from_socket(server, &rdata->subreq.io_iter,
 						    data_len);
+	if (length < 0)
+		return length;
 	if (length > 0)
 		rdata->got_bytes += length;
 	server->total_read += length;


