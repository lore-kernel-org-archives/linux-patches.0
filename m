Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A620F2745E;
	Fri, 21 Nov 2025 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731886; cv=none; b=bLa2xJk5f6/ZQXxPe9byBvShkCqfLPwuzCEvcMu5QRV5bGUHGlRf4EA5sl6CyBLIOrlpiar4Zsn8h4nr5fKpSDHmaB8p8zsUFr3ayr7gMHfz2WeEMuPe/jNkEGsNrsKl7qRxB4afUYcpqKdDd5bJGBWoxY5OQJ6eys+y1dH4MSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731886; c=relaxed/simple;
	bh=EhcHgjU6NjS2c2SgXSWjVWU5nDZzafdPVaSoSmOXHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+V4oQdjOg3yA+AFpGooMMA/OMqOKo/RPWzx6DA6txpA8KKk0jGjJNdhAQY7ZE7TSCHSybku0PSwBdfXN5rDrU7+qJPlCOPeyZyjkYYoKk5+x5yI2y9+/FuyYZFOMpDMvLRvoWTJhwJAarskYvSC91KBRvuwtSKuMCA5mnFQPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLZKNxAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLZKNxAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29267C4CEF1;
	Fri, 21 Nov 2025 13:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731886;
	bh=EhcHgjU6NjS2c2SgXSWjVWU5nDZzafdPVaSoSmOXHQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLZKNxAfmbc4hMCCjkKdeJnpKs4coDzrXNCXkV4LaW7rC1oITTui27Viw/tMy0u2I
	 L2qqT48I3a+h3k0wddEg59df1kDoSHTKLfsH3ogqqBfYntAwEHSzBU4PfhHQ4k+jdz
	 SgeSuFBFeSWaxbTHQg84np+uou/TveoxAb8UPV2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 114/185] ksmbd: close accepted socket when per-IP limit rejects connection
Date: Fri, 21 Nov 2025 14:12:21 +0100
Message-ID: <20251121130147.988504157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 98a5fd31cbf72d46bf18e50b3ab0ce86d5f319a9 upstream.

When the per-IP connection limit is exceeded in ksmbd_kthread_fn(),
the code sets ret = -EAGAIN and continues the accept loop without
closing the just-accepted socket. That leaks one socket per rejected
attempt from a single IP and enables a trivial remote DoS.

Release client_sk before continuing.

This bug was found with ZeroPath.

Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -286,8 +286,11 @@ static int ksmbd_kthread_fn(void *p)
 			}
 		}
 		up_read(&conn_list_lock);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN) {
+			/* Per-IP limit hit: release the just-accepted socket. */
+			sock_release(client_sk);
 			continue;
+		}
 
 skip_max_ip_conns_limit:
 		if (server_conf.max_connections &&


