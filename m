Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0FA222581;
	Mon, 23 Jun 2025 22:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717681; cv=none; b=ZYo/OqT5E30ODqFaNqzL7Aorh8KdjWxpq5PoNqxwn8uD0IxIqrjmEWeMK+PQ+xcJTrxWHGwnAfZr6zO4DcT0WR/81gjqJTRJSe73sx/XCITZrhQ/U7qZyypXJS3dik71dou7FtnWqJitUttIAU/nfS3dJuIfh4XmLJbmdtLdtnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717681; c=relaxed/simple;
	bh=ZHPUfd4i4Pyn++jfnjY6C1dq5dn/GirV6owrXFys0ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1ZWfdaXn2BxodKHHQyJP+zmeqYs8BllZZG+BdGBh9GmYd1vJZFlMm5RY/D6mbWiGU4ZodWi30lo9kPcmlCwGaEOsGRjUT5vm8Zgj1pZn83Un/D4U4zlZybpUDo/5PXvIATurLCQmf2C21JSMuPghMtiJKPkDkCF662b2IRPAWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+jnoAbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+jnoAbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E24C4CEEA;
	Mon, 23 Jun 2025 22:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717681;
	bh=ZHPUfd4i4Pyn++jfnjY6C1dq5dn/GirV6owrXFys0ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+jnoAbAQDPcXT03W0iCQjj65RDQCwrdhHmrJ06/BDGC0NlIB4N3mLCCGNbSflB9o
	 S3HjgYHTuZ8a3MZTlHWr67OUNufmcjshpf43vSAZUaMTVvRUkOUxU1pn3Uyjs6KHTW
	 UJmLauRLv4VMlslw9FTFMXoNgbdu210bNTGdHyeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	zhangjian <zhangjian496@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 501/508] smb: client: fix first command failure during re-negotiation
Date: Mon, 23 Jun 2025 15:09:06 +0200
Message-ID: <20250623130657.337324070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhangjian <zhangjian496@huawei.com>

commit 34331d7beed7576acfc98e991c39738b96162499 upstream.

after fabc4ed200f9, server_unresponsive add a condition to check whether client
need to reconnect depending on server->lstrp. When client failed to reconnect
for some time and abort connection, server->lstrp is updated for the last time.
In the following scene, server->lstrp is too old. This cause next command
failure in re-negotiation rather than waiting for re-negotiation done.

1. mount -t cifs -o username=Everyone,echo_internal=10 //$server_ip/export /mnt
2. ssh $server_ip "echo b > /proc/sysrq-trigger &"
3. ls /mnt
4. sleep 21s
5. ssh $server_ip "service firewalld stop"
6. ls # return EHOSTDOWN

If the interval between 5 and 6 is too small, 6 may trigger sending negotiation
request. Before backgrounding cifsd thread try to receive negotiation response
from server in cifs_readv_from_socket, server_unresponsive may trigger
cifs_reconnect which cause 6 to be failed:

ls thread
----------------
  smb2_negotiate
    server->tcpStatus = CifsInNegotiate
    compound_send_recv
      wait_for_compound_request

cifsd thread
----------------
  cifs_readv_from_socket
    server_unresponsive
      server->tcpStatus == CifsInNegotiate && jiffies > server->lstrp + 20s
        cifs_reconnect
          cifs_abort_connection: mid_state = MID_RETRY_NEEDED

ls thread
----------------
      cifs_sync_mid_result return EAGAIN
  smb2_negotiate return EHOSTDOWN

Though server->lstrp means last server response time, it is updated in
cifs_abort_connection and cifs_get_tcp_session. We can also update server->lstrp
before switching into CifsInNegotiate state to avoid failure in 6.

Fixes: 7ccc1465465d ("smb: client: fix hang in wait_for_response() for negproto")
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: zhangjian <zhangjian496@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4217,6 +4217,7 @@ retry:
 		return 0;
 	}
 
+	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	spin_unlock(&server->srv_lock);
 


