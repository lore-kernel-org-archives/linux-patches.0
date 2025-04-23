Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FA21A23B0;
	Wed, 23 Apr 2025 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420366; cv=none; b=QyIADSqmY+iuLm69rrCVcbCAipNQTWttRrpR6ePKW+Fw/QMUaLJ7c+ieG4/N1LIhpRDgqCAItTnM9DTY8dQzNQA20GAf+X1d/vpUD0HeCU+yXHMA1JQncDNXitMaPbUqKs0TSDTnuipdvb/8h1ofg1pT6araPw7gux8PfhJ52jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420366; c=relaxed/simple;
	bh=tM1MdZGrRLfNyksT1fivVolahq/8BYijBnn4ijzN9eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWg1VlJOdWmXvUHVHHG9sGWNFrKPVIGmMXYBR6dpSTQ/J/obtvSL2XFuQ9C+AT3CIr3sA3aoj9kOy9bmzBwpv/dZtQB+AALeeMQweLYOR4V+JwnG/XVwFnemvHdl/KDFchQcTOL1iq2bERffdO/evo07jAyxU/taYhN0QECFkiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vxV5PoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vxV5PoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009E1C4CEE2;
	Wed, 23 Apr 2025 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420366;
	bh=tM1MdZGrRLfNyksT1fivVolahq/8BYijBnn4ijzN9eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vxV5PoC31XPxurwoPcVyl3wMFlKuE56tfHE+nj+lATut+zEBHY+GkVsfg5gt2w/w
	 bll4XdAoM5dFvOJEf4HcEex6yMvv6T1a4K8/rHTuLOYVvMugEFoC6O4tbgdAzQXF4P
	 VFeoOvQsUAOK+aO+MWSeBLrkTMsRAaEtxJaj5b0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/393] scsi: target: spc: Fix RSOC parameter data header size
Date: Wed, 23 Apr 2025 16:39:24 +0200
Message-ID: <20250423142646.116357730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50290abc07bc2..f110f932ba054 100644
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



