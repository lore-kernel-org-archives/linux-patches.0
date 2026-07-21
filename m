Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB844AB7B;
	Tue, 21 Jul 2026 21:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670578; cv=none; b=cDw4Wljkhjbh8vfLI+pXeztRe69h+3RShY0LLX0fakuyaNAhoevPP+YmTM724gM+5NXMBKcq+sd91O0UikT7HKbf6ll4J/TNaESxW19Ts7H67B5cGMggkYnmtWahrWBK0Lag+9opAxTKyko+MEQU2Vyto9pEWisS7I78uutR3QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670578; c=relaxed/simple;
	bh=j70iPoZfruD0tvhViAv+VUmwtuORek4X1NDFpB1Wup0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHEEjfKdA11HkMr1pTxVptQWYdaBy1BHwYonKLLnX6WhTkMd3nEIgvzvydPQzte3Y3wuFX2lC/jq+U5n3u0m2wm6nzb/lWzy72TYvnLvhmwzik7bf8/6yjy53KSNeg60Uycps0TpbBLCMkgpIYyRS/Yhobxa3lDDV/JqW9GE1k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY+38pTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY+38pTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1641F000E9;
	Tue, 21 Jul 2026 21:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670576;
	bh=aq0jTqT6h5AYc6+yKdJC9sSE8B2aZQgV12pN8/4wTwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PY+38pTcTZUrJ7qIqPwxZ27vhGS36otWls6sKdGY1POL2no0/89TJroVXarTDT57u
	 mBt+lvaDjaG3kYBfXfDrLVXerH03X1bIfAVadfggLiDbfrBnwHYKQPwwEZvht+Gb4X
	 WaXseXUe6J9lUe12BjHljkby3/O2NclYti54q7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0986/1067] Bluetooth: L2CAP: Fix slab-use-after-free in l2cap_connect()
Date: Tue, 21 Jul 2026 17:26:27 +0200
Message-ID: <20260721152446.614107833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 4d7b41c0e43995b0e992b9f8903109275744b658 ]

Extend a critical section to prevent chan from early freeing.
Also make the l2cap_connect() return type void. Nothing is using the
returned value but it is ugly to return a potentially freed pointer.
Making it void will help with backports because earlier kernels did use
the return value. Now the compile will break for kernels where this
patch is not a complete fix.

Call stack summary:

[use]
l2cap_bredr_sig_cmd
  l2cap_connect
  ┌ mutex_lock(&conn->chan_lock);
  │ chan = pchan->ops->new_connection(pchan); <- alloc chan
  │ __l2cap_chan_add(conn, chan);
  │   l2cap_chan_hold(chan);
  │   list_add(&chan->list, &conn->chan_l);   ... (1)
  └ mutex_unlock(&conn->chan_lock);
    chan->conf_state              ... (4) <- use after free

[free]
l2cap_conn_del
┌ mutex_lock(&conn->chan_lock);
│ foreach chan in conn->chan_l:            ... (2)
│   l2cap_chan_put(chan);
│     l2cap_chan_destroy
│       kfree(chan)               ... (3) <- chan freed
└ mutex_unlock(&conn->chan_lock);

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read
include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in _test_bit
include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-use-after-free in l2cap_connect+0xa67/0x11a0
net/bluetooth/l2cap_core.c:4260
Read of size 8 at addr ffff88810bf040a0 by task kworker/u3:1/311

Fixes: 73ffa904b782 ("Bluetooth: Move conf_{req,rsp} stuff to struct l2cap_chan")
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6fef032af009 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3985,13 +3985,12 @@ static inline int l2cap_command_rej(stru
 	return 0;
 }
 
-static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
-					struct l2cap_cmd_hdr *cmd,
-					u8 *data, u8 rsp_code, u8 amp_id)
+static void l2cap_connect(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd,
+			  u8 *data, u8 rsp_code, u8 amp_id)
 {
 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
 	struct l2cap_conn_rsp rsp;
-	struct l2cap_chan *chan = NULL, *pchan;
+	struct l2cap_chan *chan = NULL, *pchan = NULL;
 	int result, status = L2CAP_CS_NO_INFO;
 
 	u16 dcid = 0, scid = __le16_to_cpu(req->scid);
@@ -4004,7 +4003,7 @@ static struct l2cap_chan *l2cap_connect(
 					 &conn->hcon->dst, ACL_LINK);
 	if (!pchan) {
 		result = L2CAP_CR_BAD_PSM;
-		goto sendresp;
+		goto response;
 	}
 
 	mutex_lock(&conn->chan_lock);
@@ -4092,17 +4091,15 @@ static struct l2cap_chan *l2cap_connect(
 	}
 
 response:
-	l2cap_chan_unlock(pchan);
-	mutex_unlock(&conn->chan_lock);
-	l2cap_chan_put(pchan);
-
-sendresp:
 	rsp.scid   = cpu_to_le16(scid);
 	rsp.dcid   = cpu_to_le16(dcid);
 	rsp.result = cpu_to_le16(result);
 	rsp.status = cpu_to_le16(status);
 	l2cap_send_cmd(conn, cmd->ident, rsp_code, sizeof(rsp), &rsp);
 
+	if (!pchan)
+		return;
+
 	if (result == L2CAP_CR_PEND && status == L2CAP_CS_NO_INFO) {
 		struct l2cap_info_req info;
 		info.type = cpu_to_le16(L2CAP_IT_FEAT_MASK);
@@ -4125,7 +4122,9 @@ sendresp:
 		chan->num_conf_req++;
 	}
 
-	return chan;
+	l2cap_chan_unlock(pchan);
+	mutex_unlock(&conn->chan_lock);
+	l2cap_chan_put(pchan);
 }
 
 static int l2cap_connect_req(struct l2cap_conn *conn,


