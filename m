Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A963C3;
	Sat, 13 Jan 2024 10:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7WPbv3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0336BC433F1;
	Sat, 13 Jan 2024 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140014;
	bh=rqptuo3T52oxadtzlQ/WawZuS1I5bvYVmyAvYwW4daU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7WPbv3yN3+m04d8E1vVRTGeCUwHFPNgTEg3C7C2o/3BUZx5+sD4jRAzfbuF0eVV1
	 +RC0n3m6pJ6mMTnVd8ETmc6PjBYyvHSN0yvnD2udCHC0sLoABod74nJlmePmKY+ug5
	 atnKC4rYaqbHZLmrootRlO51SVf9vjjQ2KQfdiIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Siddh Raman Pant <code@siddh.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+bbe84a4010eeea00982d@syzkaller.appspotmail.com
Subject: [PATCH 5.15 07/59] nfc: llcp_core: Hold a ref to llcp_local->dev when holding a ref to llcp_local
Date: Sat, 13 Jan 2024 10:49:38 +0100
Message-ID: <20240113094209.531881831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit c95f919567d6f1914f13350af61a1b044ac85014 ]

llcp_sock_sendmsg() calls nfc_llcp_send_ui_frame() which in turn calls
nfc_alloc_send_skb(), which accesses the nfc_dev from the llcp_sock for
getting the headroom and tailroom needed for skb allocation.

Parallelly the nfc_dev can be freed, as the refcount is decreased via
nfc_free_device(), leading to a UAF reported by Syzkaller, which can
be summarized as follows:

(1) llcp_sock_sendmsg() -> nfc_llcp_send_ui_frame()
	-> nfc_alloc_send_skb() -> Dereference *nfc_dev
(2) virtual_ncidev_close() -> nci_free_device() -> nfc_free_device()
	-> put_device() -> nfc_release() -> Free *nfc_dev

When a reference to llcp_local is acquired, we do not acquire the same
for the nfc_dev. This leads to freeing even when the llcp_local is in
use, and this is the case with the UAF described above too.

Thus, when we acquire a reference to llcp_local, we should acquire a
reference to nfc_dev, and release the references appropriately later.

References for llcp_local is initialized in nfc_llcp_register_device()
(which is called by nfc_register_device()). Thus, we should acquire a
reference to nfc_dev there.

nfc_unregister_device() calls nfc_llcp_unregister_device() which in
turn calls nfc_llcp_local_put(). Thus, the reference to nfc_dev is
appropriately released later.

Reported-and-tested-by: syzbot+bbe84a4010eeea00982d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe84a4010eeea00982d
Fixes: c7aa12252f51 ("NFC: Take a reference on the LLCP local pointer when creating a socket")
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 92f70686bee0a..da3cb0d29b972 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -147,6 +147,13 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 
 static struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local)
 {
+	/* Since using nfc_llcp_local may result in usage of nfc_dev, whenever
+	 * we hold a reference to local, we also need to hold a reference to
+	 * the device to avoid UAF.
+	 */
+	if (!nfc_get_device(local->dev->idx))
+		return NULL;
+
 	kref_get(&local->ref);
 
 	return local;
@@ -179,10 +186,18 @@ static void local_release(struct kref *ref)
 
 int nfc_llcp_local_put(struct nfc_llcp_local *local)
 {
+	struct nfc_dev *dev;
+	int ret;
+
 	if (local == NULL)
 		return 0;
 
-	return kref_put(&local->ref, local_release);
+	dev = local->dev;
+
+	ret = kref_put(&local->ref, local_release);
+	nfc_put_device(dev);
+
+	return ret;
 }
 
 static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
@@ -968,8 +983,17 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	}
 
 	new_sock = nfc_llcp_sock(new_sk);
-	new_sock->dev = local->dev;
+
 	new_sock->local = nfc_llcp_local_get(local);
+	if (!new_sock->local) {
+		reason = LLCP_DM_REJ;
+		sock_put(&new_sock->sk);
+		release_sock(&sock->sk);
+		sock_put(&sock->sk);
+		goto fail;
+	}
+
+	new_sock->dev = local->dev;
 	new_sock->rw = sock->rw;
 	new_sock->miux = sock->miux;
 	new_sock->nfc_protocol = sock->nfc_protocol;
@@ -1607,7 +1631,16 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	if (local == NULL)
 		return -ENOMEM;
 
-	local->dev = ndev;
+	/* As we are going to initialize local's refcount, we need to get the
+	 * nfc_dev to avoid UAF, otherwise there is no point in continuing.
+	 * See nfc_llcp_local_get().
+	 */
+	local->dev = nfc_get_device(ndev->idx);
+	if (!local->dev) {
+		kfree(local);
+		return -ENODEV;
+	}
+
 	INIT_LIST_HEAD(&local->list);
 	kref_init(&local->ref);
 	mutex_init(&local->sdp_lock);
-- 
2.43.0



