Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FA62566DF;
	Thu, 17 Apr 2025 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912736; cv=none; b=JFKm95ocRaPb+sE7XoYy1gnCOvaqJ4VnQtgDSQSy37JTVYHOa8V/MG9NoT6tbzZ32n+BHWMXHolECcaHqMCoCdsyAlo+7SIATYGKlSbU5W43QHz7Rcq/IjrpxzoT8UBZjMxueQAPRLnuM7S6uQWc66dsuesEF72SvWAIoBgIjgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912736; c=relaxed/simple;
	bh=QLH/fqU1zpIFP2XCPF1VtneRWX5D4oA3Zho2GJGGb28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCbVBMFY/MXr6XZ2wAGcYB2wJ825BUah+VFNTLGSJ2EUEVIzel1qTTBIMM3ul0wE+Ti1W+021CdgWTUzEzHfxeAqdQXUuLZOq7Mp743RTdSucNv6OE/5r5qq8KNBtOcaGznbAy+cTRSiq8ouyNVccttpRRCBVhENWoCoY2KKnAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl2gU69Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl2gU69Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B344C4CEE4;
	Thu, 17 Apr 2025 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912735;
	bh=QLH/fqU1zpIFP2XCPF1VtneRWX5D4oA3Zho2GJGGb28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl2gU69QXjP34nH9Isw98mQXG/+bNLsh9CPQQd6MoHqT1u1fJnoEot0ztVHJEe70e
	 I88A85ymaegD/iCljoqcP9r3QnvzuwRHQPcjahtQ4R9CBHT4U5CpWYlFYsX5I6gYiU
	 XRZSPPd2BUta0vyzlY/ibEspMF48kkwtHWbhAiPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 108/449] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu, 17 Apr 2025 19:46:36 +0200
Message-ID: <20250417175122.311637253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



