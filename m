Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623398;
	b=GL++Sn+EFwOoBYpZdCSYBBGCk1SRBOQpp+QQTb0J1XLiruqpo0JgwY/A7h4h8BNzkjNW
	 Xwl5phIF+lIgq4BgZ+IdB/r1ZYutkSxFYME15Cj7V8uKXrzbO/pQX5Svb8Lj/W6o+/Jim
	 GwllSLNkK2yn97CVDjrMIltNTxEjojeoOdvrI4xGt7TGqkPRgFfEwY8YCDY8ll+QOBgu1
	 J4ZpFsFbklxLnq5sX6UUo9pINg6zzBNljW2hE0l64Bh4u9XpuLgRpXJh/TtMUDIARDBje
	 HhLopsTe+tqghoDDvesDGWIav4Xu3U8qh2ipRBFJVTIPGOhNwUGpd/gt0rHE3xYkTiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUrZ0aRiGLWv4DFECgni3rgNZkEnpi7iSyWBZAddjMo=;
	b=SoHKShTjpohUNxGR3guxpshiDZOqdAI3H2W72pToGt8JGPt39IcIYL2DtSU8O+c4HZil
	 iQp2fmKlnA7nDcjsHAi6nWozSnklFblDa7A47BvFbZEdnf8Yni/bk3nAxPXeIgzB2QAZn
	 r4bJqPT15fmChm39TbUSSaU6rZca4k96eHd3P08JCm/zaHB2SkYaUv9MkqOwEGyiP0I65
	 ShuU0iZy7b1t5lHLU6UDuRX6rnq04eXn6Xf3CGaTS0Ko6o/o05H4JuP/6jcUJFZ4yPguJ
	 25QnnV6Jvp5rOZ540twjqYke3x92KR45T9uN42ftfZaFrSih5WCiKAgiDEhP/rr8gsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4agWOmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4087606A31E;
	Wed, 25 Nov 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4agWOmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403811F000C4;
	Wed, 25 Nov 2026 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623397;
	bh=XUrZ0aRiGLWv4DFECgni3rgNZkEnpi7iSyWBZAddjMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4agWOmV1wNB45t4DynZ3tX/X3ZoW8sFwybONnYr5sgpYhBHnb/4hJ55TTzaTUdwp
	 HQTZAxq3ipIOCuMWC/DAgPJSUoDYrdhWx3aZGYO/8SGNrOJdLghfc4HxSkvK91lqO6
	 lS/BHXiYIghS36jrFTAyKllnC0WcnjWrtwcbvu60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 847/990] smb: client: skip NULL channel in __cifs_put_smb_ses()
Date: Wed, 25 Nov 2026 15:36:54 +0100
Message-ID: <20261125143841.871970369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 8deaf64a59a263161dfc5128f8398fb3dcba4fac upstream.

cifs_chan_skip_or_disable() clears a secondary channel's slot in the
session (ses->chans[chan_index].server = NULL) without lowering
chan_count when the server stops supporting multichannel.  When the
session is later released, __cifs_put_smb_ses() walks every slot up to
chan_count and calls cifs_put_tcp_session() on it, which dereferences
the server pointer immediately, so a slot left NULL by the skip path
makes the release crash with a NULL pointer dereference.

Clearing a slot without lowering chan_count is older than
cifs_chan_skip_or_disable(): cifs_chan_update_iface() could already do
the same since commit b54034a73baf9 ("cifs: during reconnect, update
interface if necessary"), and the release loop has been unguarded
since then.  Commit 12d1e301bdfd1 ("cifs: do not let
cifs_chan_update_iface deallocate channels") later removed that
trigger, but the crash is reachable through it on older kernels.

cifs_decrease_secondary_channels() already guards the same put with
if (server).  Add the same guard to the release loop so a skipped
channel slot is left alone.

Fixes: b54034a73baf9 ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2178,7 +2178,8 @@ void __cifs_put_smb_ses(struct cifs_ses
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
 			ses->chans[i].iface = NULL;
 		}
-		cifs_put_tcp_session(ses->chans[i].server, 0);
+		if (ses->chans[i].server)
+			cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
 


