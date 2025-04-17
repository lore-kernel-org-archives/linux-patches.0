Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04F8462;
	Thu, 17 Apr 2025 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915422; cv=none; b=By+RvX/cz8PEBJ7MXu9FHlKtiWli0EfLt+EvNJzkQVEhNkDkvcd9ZpcSR2qdl9/TEDqOV8+hteKDTa5OlwR97Rf0xNHQpmqKFo012bKya3Zft8FSkDOJ2qxKkXgyGryq9iFYPs9Du6eycNAYkq/xTpQPrEOcU3e27EkblEXvIE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915422; c=relaxed/simple;
	bh=l2V+SjU8GiGSPyNuvFNu8fDG20c46xIBqP+GK3e97eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARVpaaZJUYwrtbejnzcUa5UGOBdiAUMaOdCDJWdrFzUqPvqzkG/VW2va5bWY8eQ70YPCYlQlCePsqtHyu8RJYanJq4ARzqBT8k+RPecq0Ly0nU6WjZu7/ykJg9YKKRR6/BKFeavdwzqLocZjgBuTJ6u4QnadSmt9GN+TcPb96mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcw5rUMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcw5rUMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B1AC4CEE4;
	Thu, 17 Apr 2025 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915422;
	bh=l2V+SjU8GiGSPyNuvFNu8fDG20c46xIBqP+GK3e97eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcw5rUMQCoE/90yv698ssxZli4qytiz8CtpquKBMu0tyu9kDiIjPhDLE6B0oJ91Aw
	 38OetMjib+nBSEyNwjCFrt4IO+/0/XTgIbrb+80wq592X7aup/EvM6eqTzAAwEbHG/
	 RayYxdRhmuybykjpRtoNQ0tpXAaLXhHwXI0IokUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/393] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu, 17 Apr 2025 19:48:22 +0200
Message-ID: <20250417175111.335628686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaohai Chen <wdhh66@163.com>

[ Upstream commit b50532318793d28a7628c1ffc129a2226e83e495 ]

The SPC document states that "The COMMAND DATA LENGTH field indicates the
length in bytes of the command descriptor list".

The length should be subtracted by 4 to represent the length of the
description list, not 3.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
Link: https://lore.kernel.org/r/20250115070739.216154-1-wdhh66@163.com
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ea14a38356814..61c065702350e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -2243,7 +2243,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 			response_length += spc_rsoc_encode_command_descriptor(
 					&buf[response_length], rctd, descr);
 		}
-		put_unaligned_be32(response_length - 3, buf);
+		put_unaligned_be32(response_length - 4, buf);
 	} else {
 		response_length = spc_rsoc_encode_one_command_descriptor(
 				&buf[response_length], rctd, descr,
-- 
2.39.5



