Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D48502554;
	Wed, 30 Sep 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788876; cv=none; b=GP5WocHZDPFLnCMhn4gN8WVk+TL+V05voiqLL9agjiIzAD4Pfhopd7jaPak5umxqqVhA4Tsqr8fFvs7LdA+fHLNUOmpcCSPQqzH+k+ESVZeBdvNNbHOsSZrhkw2Ctwfda0UEk6ZJHTLl9Qs2HR9tzSLCJLtX3eFtB/yDIT5loEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788876; c=relaxed/simple;
	bh=29s8yx+JDEEw00jK0s3L2d7k63DXj0Td08mzvxeOAMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYoIfgpmcPKesRGw2DHQGudEJHc2qZHAOQt49hWFu0K0BOtaiNBuJVdV0HgN0Gjn6CwZYvBZI+EpKuQMHEo71fqLJUYgs2nhHFWwfP6uCMPBuY8Jnl+bv/8HlUovUdhu8M/0Ao+gaNY9r4LYQyd+9o2rq5zm4wocuTo7cRy/kMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VX7hNJGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX7hNJGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9E81F000FF;
	Wed, 30 Sep 2026 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788874;
	bh=x3X0qtY4Bh8RHePMUibT3+TTL1klr8V12tjfJlwEZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX7hNJGCAVwqFsf2Um6jmG/jN80HHfCPXk8Z9pCrYMXVEUgO++uf+SvKxqHnDn/CO
	 5PeeAaG/Bhxk0mdNhBUliehXkPZPLhANHVN2+xv1XXazAERJEOY7yMrNUE9+Azaxba
	 loZA5w+f2wfBv8BfwKz+84+wvfvTjiZ4YRaPulMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.12 279/877] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Wed, 30 Sep 2026 17:19:50 +0200
Message-ID: <20260930152420.738629506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit e75c96157d45e498970158c8f7373d90102e33b9 upstream.

When an RDMA connection is successfully established via
smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
kthread_create() returns an error), the error path frees tcp_ses
without first destroying the smbd_connection.

Fix this by calling smbd_destroy() in the out_err cleanup path before
kfree(tcp_ses).  smbd_destroy() safely handles the case where
smbd_conn is NULL, so it can be called unconditionally.

Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40manguebit.org
Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1885,6 +1885,7 @@ out_err:
 		kfree(tcp_ses->leaf_fullpath);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);


