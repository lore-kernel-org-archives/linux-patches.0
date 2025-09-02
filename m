Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA72E305E32;
	Tue,  2 Sep 2025 13:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819592; cv=none; b=Va9I+Xy4QhOqULVymQOSPK8JH2XwC4zzp3WK9HUy8RaCFxSgGM75LZACHLFMzW89MERe7+WgQKYmviCnsRl2DT3prHz89dO42oViMWovbV5KeH3M0REX4u2Fhe0Sm8d+byvcsPvRqQ0V4A746sgC1lKIqas8fhXYpw3yXFhrDo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819592; c=relaxed/simple;
	bh=HJ5xyRA7t8NKcTXO7mof2kLi0vyMm4/Rf58cGMvdUbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGblqPos1E+1QuKuB9XqNo+zEzAP0BD8NGDA+R6J6JSvhB4PV+rB6f6wX85lJTY+XcoHatMhput4vcBGt4YznCao9zpIYDxF/HPB4HJ/plc5YrYwjbDzUEu9ZfwHPVtNza02FhMWmHOt6Xp1sylK+oN4w2Eh3PTIQaFF0TotEJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw67oj5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw67oj5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328FAC4CEED;
	Tue,  2 Sep 2025 13:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819592;
	bh=HJ5xyRA7t8NKcTXO7mof2kLi0vyMm4/Rf58cGMvdUbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw67oj5/q6yN7kk/crEOtTfk3EnUq6mmxmQ9fMzE78P4VcKgyjPb1Y7GYHNbfRDUu
	 LZ/Y4yeaS0UQGH8vSNIRJHKpgadk230dTw5izsVjiSr7eYqYw5OVBtRVBTzqbzuwG9
	 +TtBNwacTEaC6foqDY4SqF35x1TOao+BeJNZEKAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 080/142] net/mlx5: HWS, Fix uninitialized variables in mlx5hws_pat_calc_nop error flow
Date: Tue,  2 Sep 2025 15:19:42 +0200
Message-ID: <20250902131951.333867526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 24b6e53140475b56cadcccd4e82a93aa5bacf1eb ]

In mlx5hws_pat_calc_nop(), src_field and dst_field are passed to
hws_action_modify_get_target_fields() which should set their values.
However, if an invalid action type is encountered, these variables
remain uninitialized and are later used to update prev_src_field
and prev_dst_field.

Initialize both variables to INVALID_FIELD to ensure they have
defined values in all code paths.

Fixes: 01e035fd0380 ("net/mlx5: HWS, handle modify header actions dependency")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index 51e4c551e0efd..622fd579f1407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -527,7 +527,6 @@ int mlx5hws_pat_calc_nop(__be64 *pattern, size_t num_actions,
 			 u32 *nop_locations, __be64 *new_pat)
 {
 	u16 prev_src_field = INVALID_FIELD, prev_dst_field = INVALID_FIELD;
-	u16 src_field, dst_field;
 	u8 action_type;
 	bool dependent;
 	size_t i, j;
@@ -539,6 +538,9 @@ int mlx5hws_pat_calc_nop(__be64 *pattern, size_t num_actions,
 		return 0;
 
 	for (i = 0, j = 0; i < num_actions; i++, j++) {
+		u16 src_field = INVALID_FIELD;
+		u16 dst_field = INVALID_FIELD;
+
 		if (j >= max_actions)
 			return -EINVAL;
 
-- 
2.50.1



