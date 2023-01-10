Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA956A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EFEC433F0;
	Tue, 10 Jan 2023 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374444;
	bh=8N9IoaFFPEWKDahZmRc4MIX/AxAv9fs11GFAWzj2gWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGlBYFIFTOloiT/4pHayFz8lS8CSerSsM2F5wNaIl7Mn/g0qrfrnjRsAogzWf3XZc
	 PppRtAvoNc54Q31ko/qfjG9rGkIT8GwoktN6T0U/vZGHLhBixlWGmnSdmysZabuX5x
	 XpsYQ79h23BlM7BQzEykVVEJ2bAYv4+g+lLXk5mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 003/159] cifs: fix interface count calculation during refresh
Date: Tue, 10 Jan 2023 19:02:31 +0100
Message-Id: <20230110180018.402708055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit cc7d79d4fad6a4eab3f88c4bb237de72be4478f1 upstream.

The last fix to iface_count did fix the overcounting issue.
However, during each refresh, we could end up undercounting
the iface_count, if a match was found.

Fixing this by doing increments and decrements instead of
setting it to 0 before each parsing of server interfaces.

Fixes: 096bbeec7bd6 ("smb3: interface count displayed incorrectly")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,7 +530,6 @@ parse_server_interfaces(struct network_i
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	ses->iface_count = 0;
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -540,6 +539,7 @@ parse_server_interfaces(struct network_i
 				 iface_head) {
 		iface->is_active = 0;
 		kref_put(&iface->refcount, release_iface);
+		ses->iface_count--;
 	}
 	spin_unlock(&ses->iface_lock);
 
@@ -618,6 +618,7 @@ parse_server_interfaces(struct network_i
 				/* just get a ref so that it doesn't get picked/freed */
 				iface->is_active = 1;
 				kref_get(&iface->refcount);
+				ses->iface_count++;
 				spin_unlock(&ses->iface_lock);
 				goto next_iface;
 			} else if (ret < 0) {


