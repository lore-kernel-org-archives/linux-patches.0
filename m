Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037054;
	b=pa6gBTL4ApznvExO1SqAWJEzZrOuhFE18TcRHtHeKmKkwCJ5kaIDSXD4uMl7IyJEAFGs
	 1Hd435bVsrxhUHK7WnomT49paZr3qXFYzPU09EVwcx9PBvElCYA94AMGabN4iaaa2MRkd
	 fXQjf3TOjaqAEvvozF5XCnghgoHLEBJ6F3mQGkYqCErtwe7JYqgkPLG2tIYzXHNc2Krd7
	 PPYeC8vC8vXwfgWqRblW8NpKDIg9LOhUW4Pd6ITSbD6QL1kdqHAH+Ns9Xx5j1PZ54gRFU
	 T0cGa+0zzQALb7TeUblOYPN32HR3vtoyjVDNLoTQGkfdLxBW+5MzeivlqvLqBkokiVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xOlNb3K90lwoR+bGSlPoeWihdEfJrwGhAADPGEicHFU=;
	b=1DsTPIMKYxOAkthVjr1d9HRXEjL7XiySIV16UUnLrD2HdGYTeq4sIr06p52w6TjVbe63
	 bZowjXjjtB1OBxzJo9LFKurxiQM9B4TTR/Uu87IiIW9BpDGEK9REBLJFmXzYjJ6gXSCyk
	 QUmepFBe2dVvuPZ40w85pLLdOSXu0qkpkP9DNy9GoBrNJX8FK3HCH8a9LScLrBltNwzRA
	 e05VBJVHeLog5ZDua1mzi3/Cu0Xm0z9qpy2Ztsgwg2kqkCkWDotM7UNW1rXrgZtV0qtUf
	 aDWgjkvWxLMu3Hu00Wz/8ShfZXBtBHCt2/+XJzgyHm5JIvzE+U/PpGPNAwePtuwP2kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgkcuPiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC30606A33B;
	Wed, 18 Nov 2026 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgkcuPiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB391F000CB;
	Wed, 18 Nov 2026 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037053;
	bh=xOlNb3K90lwoR+bGSlPoeWihdEfJrwGhAADPGEicHFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgkcuPiBH6KRjQcLOKtYJmDStMrUUcMDMqdhAb9Wohb6ewJA/0EgGub6T7JzSiUZN
	 p6SnuvfmXqlgLtvBG8emlKS0gnh44fnOJ9a3XDkQWdLhyL2O7fKCZcTca4I79pv8Ze
	 Seg/98CrnB44PxQlsP0TfQAg+/K1fhBKCeNEcyY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1276/3318] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Wed, 18 Nov 2026 15:31:38 +0100
Message-ID: <20261118150358.516687395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 11db8ab55e1a7533e9cfe57687ab142ba67d3c84 ]

When the initial admin queue allocation fails after a new association
was created, nvmet_fc_ls_create_association() only drops the
association reference, which frees the association.  By then the
association is already on the target port's assoc_list, though, and
removal from that list only happens in nvmet_fc_delete_target_assoc(),
which this error path never calls.  The freed association stays on the
list, where later lookups and the port teardown can access it, and the
target port reference taken at allocation time leaks.

A remote host can trigger this reliably with a Create Association LS
requesting a queue too large to allocate.

Schedule the regular association teardown instead of dropping the
reference directly.  The teardown removes the association from the
list and releases the target port reference before the final reference
drop frees it.

Fixes: 0cab4404874f ("nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 217637d2f8ae8..224287ca9039c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1681,7 +1681,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
 			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
-				nvmet_fc_tgt_a_put(iod->assoc);
+				nvmet_fc_schedule_delete_assoc(iod->assoc);
 			}
 		}
 	}
-- 
2.53.0



