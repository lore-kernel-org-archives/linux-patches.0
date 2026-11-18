Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021163;
	b=m3GJCc05wW9lT9sEreNd7QMcx2E6HEknvn9qvYvyzBMUVyyqKXNGppPajBxX2AUQvrKU
	 vc6IJoBiwi3s3ORC7IgproPtSIc5vqgKBYwqg+Ub1rsXYAImshD1z7MiYoHapYDD0EU/o
	 pKotU4zO9qR0HkBcrcyXeOc8oM/OxyTas2ZgY5xhMJdDxyBuejWJyQD/zJlb4sGeyiuzn
	 PZAFgjgoNIIWOukcKnJN+9YgBQWbkGRrno5BQEWJSyrAJfYh5HVeb5atwHaJpZif4X7HS
	 1tA67SXvvcRggetwMosS1/emYoc59uppz/rUox1lD1zsuzXmFR3Xbwnoe8iRlh4ZFhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKVzbhmnkTFmU2yOdmg+ogElV2UM0itXcNPcWJ67Y/s=;
	b=4QN+eakQyBa8ApW1nSILhk2x5NChqzwdxLBwKzv70dSId60IIqspgN8aU0xsJh/owgRc
	 xuHpDlGUNAP1z6kynnG8fMwUV0XHU+AxLbT/7qlRUeu1SQOLZ4PBIDdugiV+V0b9qMUpw
	 /BIaQQRNcwtGnKxByWkxwmLr5paAcCxO/WSboy682kTSNh3kegLPNYt/n12hsnXJ/Q2hn
	 i66yX1RtpZr1zxOPqHMsDxdiqwSOEuRPH+8zJqvpbqXQs8Re9ygi2LpwVfFpQdPy1vts6
	 4n9lN7addZ2fO2NRL89Enec7xVDC2kAQ5Bbx2VbgFPCsHquzqSVbPROmX2qpRUperXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JizC7cSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556F606A31C;
	Wed, 18 Nov 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JizC7cSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5690D1F000C4;
	Wed, 18 Nov 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021162;
	bh=bKVzbhmnkTFmU2yOdmg+ogElV2UM0itXcNPcWJ67Y/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JizC7cSIW2BC224S69oL4Ja8Tq2d50ICGBlG57kaVXhR9sWnSJBDWiNGwHdk4uboF
	 6kjlCWVMQ3RcfOmL33d+UXIT6oEuNG2SnJ/zyWftdDQySJDsafZGo5gSUJCamvKYMx
	 qPkJeat0xXNoCO1EtV7xsCZUYvjZvETuDiaNTCSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pwngets <2605452642@qq.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2209/2651] ntfs: fix runlist marker allocation and count
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150405.185117311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: pwngets <2605452642@qq.com>

[ Upstream commit c1bd2f1c22c2fa8c5f0f51f82afad23f2dd1bcf1 ]

The marker path can append an unmapped element and an ENOENT
terminator after the merge helpers have already computed the resulting
runlist count. In that case, allocating ds + 2 elements leaves no room
for the terminator at ds + 2. The path also increments new_rl_count even
though the merge helper already accounted for the final runlist size,
causing a later merge to start past the terminator.

Allocate space through ds + 2, and derive new_rl_count from the final
terminator index instead of incrementing the count a second time.

A crafted NTFS image can reach this path through a normal read after the
image has been mounted and trigger out-of-bounds kernel heap accesses.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")

Assisted-by: OpenAI Codex:GPT-5
Signed-off-by: pwngets <2605452642@qq.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/runlist.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 89e13a452a845..76ba6ab72b8a6 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -702,9 +702,8 @@ static struct runlist_element *__ntfs_runlists_merge(struct runlist *d_runlist,
 				/* Add an unmapped runlist element. */
 				if (!slots) {
 					drl = ntfs_rl_realloc_nofail(drl, ds,
-							ds + 2);
+							ds + 3);
 					slots = 2;
-					*new_rl_count += 2;
 				}
 				ds++;
 				/* Need to set vcn if it isn't set already. */
@@ -720,11 +719,11 @@ static struct runlist_element *__ntfs_runlists_merge(struct runlist *d_runlist,
 			ds++;
 			if (!slots) {
 				drl = ntfs_rl_realloc_nofail(drl, ds, ds + 1);
-				*new_rl_count += 1;
 			}
 			drl[ds].vcn = marker_vcn;
 			drl[ds].lcn = LCN_ENOENT;
 			drl[ds].length = (s64)0;
+			*new_rl_count = ds + 1;
 		}
 	}
 	}
-- 
2.53.0



