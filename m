Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028375;
	b=upS6Tg6gjfBsdfDw6vrwpOeibAsgaEfIj4LmOSyJ3CHemq4ibXPzNsTozSXeAfPuYNHw
	 CSDLaVWDFdhf16Lb21PCE+/GbDo+T2zNdmCMhGqYd0PDB7So9HKBfMRzpJZ4QBnAv4WKc
	 zzbmRYpy91PfkMxKLUpINiI6BG6Heo/chWN++OBgwPkC6ojxKZInZD4M9pRXvvDGg0Mhn
	 HctWvlkUOJP/JE6HJMbG2E/T1targy9XvdBjmlfvEpKLmV0OaFQpa6KIDhBA0kaIT3s6I
	 U6iVMrY4dofgoTdHYOwX/r45yG337LJKYJQL4GCLdhNO6vEyNPLDQq2a3dWZzt7xFzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7LeWEsFEDZh0T50idPxpBtdpuIneCmvAqF3nELdhf8=;
	b=CYlghYzBc5SgbZhldJtTA9aUyOSg9ZcT8Z5ilGsmq3t0Kjnd0duJgmy9OvkFCA2FHT1N
	 nHTXEAXSRxAukQFY1GXyVWRo7Xe2HJIzoCQTH5GBCocrrwzxJbDHSyeBIYPkQ+7qtq8U6
	 tClcuZNaqdOWC7UGDtxNEN99VfcDAwWY87X05z1wFNLzM9zvsvfvd5yk7NgvjeipAq09e
	 vrsiFQkypPNCCfqY0PST33DGCi8PbBX6ytbGgS75XmdAcfwLrDdRAtC372NYFi523FauJ
	 wLw+tTwyB3TZHk0KMe9YdKBUdkuPHGG8xRImIFGbsf3hKBqfbzOpeu8LA9PvYfHCn0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFXAleMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264C606A325;
	Wed, 18 Nov 2026 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFXAleMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD6A1F000C5;
	Wed, 18 Nov 2026 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028375;
	bh=c7LeWEsFEDZh0T50idPxpBtdpuIneCmvAqF3nELdhf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFXAleMT6ngcyHnAIv9JUawwSwMDtmWXKuV8YgwEC2ZWoDqMdosGxvcfS1devAY0p
	 koXqKxICcfmq5g/kZmrMrVaNv754/MA+4SNuC3XuQXoXR+IH7axMgtWVZ+EZW+sUeD
	 PEhC5XLDa3XNtsz8xor0Noo0un7vlNMzE91yD/lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2122/2151] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150238.989269886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 5cbf1553658ea..56d5566477942 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -279,9 +279,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



