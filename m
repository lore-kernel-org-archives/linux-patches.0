Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040018;
	b=OspiI25N8+zCw43XrX5lgr2APKvAg6aI6RdAjtpf4/HJ4EB83X8CYNf0cPLFTM5IOiE5
	 ETupkakhQoLpRD1h3rRzOAYiS6IVNxeI+ay8OKGmDK6YAJvtXBAModl9rs9fjZV/4s+TS
	 yIi8uWNAHdZdr6sdMCPdPBOSbOe4/Y6BS/Bluf2uEfRGbefLqZn7NNe4IkY7FBC00NLdu
	 9vzkghEA5/T4uR8sZ8wq8/vxYMnjTGb+LWu7JG05dk5On6+q84/KvKL5aIrpN9Ulayzu7
	 V0WQY4ia9pSC2+ht/nyp9hxcrMzdhQY/pqKCRaCPCtaITwnoA961qysBns88JZxrxJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JSCKW8yJjHcruNRBJQhw/RUkRm66vNApnDOZHHtwhc=;
	b=bh3OPRV1bOURPW9YOu3b9Vfr4aqsyZeDaKHmN2xm09K+msMBd7Lb1nsZbgjCZgtIYqro
	 dktJM0vrohd+ElKJp+svLd5FeDYH/pUb/HAFE2HKWQQlksNzchlsRIaWGD84gAd0GUrJV
	 wkmg2s3+REW4ZVH07nR/aPSIuL5DWfimmjgkpn0PM96JTz1+cI3DECtP2ZOHhVAP/Q8hQ
	 zPX1EBE2PR/law/CEpI3X2k+ev1TBMJcTk4aoiu3eHvZEj5T/a6GOZUpsjAUqtSCjc6Ik
	 xW6EbWrTPMCWnN86iIxS0+knSpK1aoRYFcXMDx7vXm8S8W1GOj3IQenTuj1iLi5Unvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQuL9X6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390A6606A320;
	Wed, 18 Nov 2026 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQuL9X6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED551F000C4;
	Wed, 18 Nov 2026 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040017;
	bh=6JSCKW8yJjHcruNRBJQhw/RUkRm66vNApnDOZHHtwhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQuL9X6cD5GCEdq4eqRbEdNAh4uRW3f8BVqWygDV7fn95T8w0uN64rolhYHLmyWie
	 ArmXsutuWJ2sVf8FOx7z+AxHTZ0eozobPAT35xeF1gV9e6L1FN/k8GIAOShRaz+Rcx
	 ymALFjC5lMmqXeXkkUcjdABoIajk4cG/gO3bEvUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2306/3318] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Wed, 18 Nov 2026 15:48:48 +0100
Message-ID: <20261118150430.878083945@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 193aaf5b57f05d9f0403cfdaff3eda3b8d11ec13 ]

The steering anchor resources are shared between anchors with the same
priority and are protected by rule_goto_table_ref.

When steering anchor creation succeeds but uverbs_copy_to() fails, the
error path drops the reference acquired for the new anchor. However, it
unconditionally calls mlx5_steering_anchor_destroy_res(), even when
other anchors are still using the shared resources.

This can destroy the shared flow table, flow groups, and rules while
existing anchors still hold references to them, resulting in a
use-after-free when those anchors are subsequently cleaned up.

Only destroy the shared resources when dropping the reference makes
rule_goto_table_ref zero, consistent with the existing cleanup path.

Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steering anchor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260917085419.1792-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 520034acf73aa..186085cfb4e9b 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2466,8 +2466,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	return 0;
 
 destroy_res:
-	--ft_prio->anchor.rule_goto_table_ref;
-	mlx5_steering_anchor_destroy_res(ft_prio);
+	if (!--ft_prio->anchor.rule_goto_table_ref)
+		mlx5_steering_anchor_destroy_res(ft_prio);
 put_flow_table:
 	put_flow_table(dev, ft_prio, true);
 free_obj:
-- 
2.53.0



