Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF47461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3455EC433C7;
	Sun, 17 Sep 2023 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980711;
	bh=kKCcR2DTQVqK2i3uxtwBOCVcc82rD7ILRkoTAN/xVxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPHyjou2SdkirhcnpvJ98ltulnJhEDyJprsWyOFiPsprqK0lEo5WLB+kgXFvQh8BH
	 /M3oS6tmQrFlGdIic65uEx+akDnBhBDfXXwfVGQ4TNJ4uqP2sxHKEkVcIro0na1P3X
	 Hl9TZ92D8dJzExTvQZfdiCB1dbykQrAdaV3/KnfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 272/285] net/tls: do not free tls_rec on async operation in bpf_exec_tx_verdict()
Date: Sun, 17 Sep 2023 21:14:32 +0200
Message-ID: <20230917191100.584528253@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit cfaa80c91f6f99b9342b6557f0f0e1143e434066 ]

I got the below warning when do fuzzing test:
BUG: KASAN: null-ptr-deref in scatterwalk_copychunks+0x320/0x470
Read of size 4 at addr 0000000000000008 by task kworker/u8:1/9

CPU: 0 PID: 9 Comm: kworker/u8:1 Tainted: G           OE
Hardware name: linux,dummy-virt (DT)
Workqueue: pencrypt_parallel padata_parallel_worker
Call trace:
 dump_backtrace+0x0/0x420
 show_stack+0x34/0x44
 dump_stack+0x1d0/0x248
 __kasan_report+0x138/0x140
 kasan_report+0x44/0x6c
 __asan_load4+0x94/0xd0
 scatterwalk_copychunks+0x320/0x470
 skcipher_next_slow+0x14c/0x290
 skcipher_walk_next+0x2fc/0x480
 skcipher_walk_first+0x9c/0x110
 skcipher_walk_aead_common+0x380/0x440
 skcipher_walk_aead_encrypt+0x54/0x70
 ccm_encrypt+0x13c/0x4d0
 crypto_aead_encrypt+0x7c/0xfc
 pcrypt_aead_enc+0x28/0x84
 padata_parallel_worker+0xd0/0x2dc
 process_one_work+0x49c/0xbdc
 worker_thread+0x124/0x880
 kthread+0x210/0x260
 ret_from_fork+0x10/0x18

This is because the value of rec_seq of tls_crypto_info configured by the
user program is too large, for example, 0xffffffffffffff. In addition, TLS
is asynchronously accelerated. When tls_do_encryption() returns
-EINPROGRESS and sk->sk_err is set to EBADMSG due to rec_seq overflow,
skmsg is released before the asynchronous encryption process ends. As a
result, the UAF problem occurs during the asynchronous processing of the
encryption module.

If the operation is asynchronous and the encryption module returns
EINPROGRESS, do not free the record information.

Fixes: 635d93981786 ("net/tls: free record only on encryption error")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20230909081434.2324940-1-liujian56@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 53f944e6d8ef2..e047abc600893 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -817,7 +817,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err && sk->sk_err == EBADMSG) {
+		if (err && err != -EINPROGRESS && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 			err = -sk->sk_err;
@@ -846,7 +846,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err && sk->sk_err == EBADMSG) {
+		if (err && err != -EINPROGRESS && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 			err = -sk->sk_err;
-- 
2.40.1



