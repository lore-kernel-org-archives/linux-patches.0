Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E62511235;
	Wed, 30 Sep 2026 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792323; cv=none; b=gimr2Z/6UePmZwt3M6ZoMUB1dcmkdBig2OegYJQaJ/qb99GU4B11zvB5lZPzIIhuXwVOjTBXbZ9bPRfmlnnLEP8vXMV9IDI/pboVfok8TCpZuRdIGvkYsjtKq0TIRuCq7CFqXmqCbbcarotSdXfFVploOFwaCnRiGfGXA3FLJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792323; c=relaxed/simple;
	bh=b26H8Vs3HAfz5coakXacCLuCvvekXyMs6MS2l3wQDck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcD/MBROAwGGQ7Ry7FprvjDcqbRvmGZjRIxrCx+jWR0o49elQ94BCBLmqJdphMsfUNc0H9YvG7I19tGPKoyqCXvONj6iot9XwK8BQfDsjrAzNVR07nz2OnNKAEKRcoWJM9Y/vUdL0cJQzx/TMCsVAZRlbjlMkANqPA4+edmNX2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0A4aJbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0A4aJbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38061F000FF;
	Wed, 30 Sep 2026 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792322;
	bh=LocfELKyubiOVI27K4jo2+Mz+DB+XMyuFuwp4EUxYQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0A4aJboekK2f87W7AqJ3ciJuS9QrnglRTfMtI1zS8Xx/yEIcduwBev8YYPb82dHx
	 IibqrwSndoC2+Qx7434Zg8H7+j1/LgnAuXsd5GbjujpiWZNdVlTpSr7bbA3gazAsdT
	 NNXDYF0Z42jSEgrbmYJWDZXu17/X180y3ejc2hEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 615/752] netfilter: flowtable: publish HW_DEAD after worker is done
Date: Wed, 30 Sep 2026 17:28:05 +0200
Message-ID: <20260930152411.589882430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit d644b23afe1ef509c9961a6d84a093c2587edf02 ]

flow_offload_work_del() sets NF_FLOW_HW_DEAD before the work handler
clears NF_FLOW_HW_PENDING. Once a flow is both HW_DYING and HW_DEAD, a
concurrent garbage collection pass can remove it and schedule it for RCU
freeing.

The offload worker holds neither an RCU read lock nor a reference to the
flow. If it is preempted after publishing HW_DEAD, the RCU callback can
free the flow before the worker resumes and clears HW_PENDING, resulting
in a use-after-free.

Move HW_DEAD publication to the common worker epilogue after the pending
bit is cleared, making it the final flow access by destroy work. Order all
preceding flow accesses before publishing the bit that allows garbage
collection to free the object.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ffcd43ed1fc9b..60e9c03d697f3 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -980,7 +980,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -1043,6 +1042,12 @@ static void flow_offload_work_handler(struct work_struct *work)
 	}
 
 	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	if (offload->cmd == FLOW_CLS_DESTROY) {
+		/* Publish after the worker's last flow access. */
+		smp_mb__before_atomic();
+		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	}
+
 	kfree(offload);
 }
 
-- 
2.53.0



