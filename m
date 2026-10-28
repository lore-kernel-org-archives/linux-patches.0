Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214935;
	b=K7fiy36Ic9fTsA8iMeyiQy6XjsOa3UOmksQfId0R+HElppKTfl5IiAS8jkFwK28DYVEi
	 3WOcbiLrVlp1E7FfFiN9oPZowQaUBOSCVcYHG0QYdXLvVtg1sPhLH3hiAnMJM9hb84fI0
	 SiIwAVVT+kNjGWAeBZLXvozoSdYOstLNV8uAZ7ZQdmqP0vcu96YwB+ZfsGU/9yGGb50Y/
	 0n7a0hmASwfHwyuN4TJiLYYv+xT3V0oRPN8J2s6KChHXJSVT9kasbzLyVneESjSwa9J76
	 Sml0hYWcJhJds45KBX7jWXgErUny7ixDc37Z8umt468gnSgiSzTQnUP7y7ImyrdfTgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZPN1xtrKO6HJocYbDDDXLSkdM3/iMGNwp9ix6/xNJo=;
	b=qjAOGxIk8/yvDaZPBaLusk5qLDrD61tJoKfrLDNghbrDxK0JKhNk2SVflfpuoi8psITK
	 fC8x8wzfA41j9vv5jIvh+qWfTeO8XpQFgFTlzUvQVQ5bthZSSHB391V6E+1SwV20JMI5a
	 tQEVmAj1ILlMTHUj8ZZkolluGtK93XGZ/IVw+RtkoHT11JEYsxncM5NC/l5/evjD4Ks8Q
	 0jBkNLnXCtjx8kjYaOjWfMB5Se3GUOucR1cXiFQcbttfsYt18zyLNIcTxbEjstUqv0JJm
	 PKekH9QW3iAuczsup0hED9k+2CREBuEayQy44G+TZJFRqpxXO2Oj888PvzH6m/ElzuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4zr2gD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB12606A31F;
	Wed, 28 Oct 2026 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4zr2gD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FB91F01825;
	Wed, 28 Oct 2026 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214935;
	bh=dZPN1xtrKO6HJocYbDDDXLSkdM3/iMGNwp9ix6/xNJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4zr2gD9M15r7mfOqcpc/D2A1AQ9B6t8ee10FVTovrFpUmnzGl93Cha2SoCNwbUeg
	 UbNpL0kUgpG6bMrbthKGj5ya+ICdxRNWrOgjNIDH8sku7wvb85oL8mPlrt8vLb1+v3
	 xvSwjBF4ahaIT/56YusnTSexFo4z9+WCjEQcFlDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0997/1887] smb: client: prevent races in ->query_interfaces()
Date: Wed, 28 Oct 2026 17:51:33 +0100
Message-ID: <20261028170522.102162026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit c3c06e42e1527716c54f3ad2ced6a034b5f3a489 ]

It was possible for two query interface works to be concurrently trying
to update the interfaces.

Prevent this by checking and updating iface_last_update under
iface_lock.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a59df97b55282..590f8d44279a9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -590,13 +590,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	/* do not query too frequently, this time with lock held */
-	if (ses->iface_last_update &&
-	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
-		spin_unlock(&ses->iface_lock);
-		return 0;
-	}
 
 	/*
 	 * Go through iface_list and mark them as inactive
@@ -727,7 +720,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 		ses->iface_count++;
 		spin_unlock(&ses->iface_lock);
-		ses->iface_last_update = jiffies;
 next_iface:
 		nb_iface++;
 		next = le32_to_cpu(p->Next);
@@ -792,10 +784,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
+	spin_lock(&ses->iface_lock);
 	if (ses->iface_last_update &&
 	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
 		return 0;
+	}
+
+	ses->iface_last_update = jiffies;
+
+	spin_unlock(&ses->iface_lock);
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
-- 
2.53.0



