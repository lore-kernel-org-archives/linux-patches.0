Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E62110E;
	Tue, 27 May 2025 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367182; cv=none; b=JTaRkHPyx+EA59rduKamlarB8n4Gx8a5PREOwMcPbAVkRzCKaQkPuKOrN//rMg8vHR3bn43JoYNqcdT5y5NJr75/nHjCFZEfpOdfAfz+OpeVbpSNkK0sbmgq9J1tJQXlUoMVitycLjuP2+tIZks79lPC+V64U0uSiFpPHZz9ec8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367182; c=relaxed/simple;
	bh=gNrCATfimtWyQGHy7sASLVp2v+Q2OjOp7EzUOWOeMUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGJvfLrWVFm5x/RP9iZDQV5sPmvhcpxNre6YaUcvWCIZm+le+IQMbRVaIS4jqqw2+oxjIQce0+lLDf2dMOZVS2TTjVdjTUq71NYqg8oAekhXsIfxIg4lQXeHKfW1euczL0iX2XqRVlZYCOYepkkOXCNJqMoMhdvGjS5QZnlCnGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu4zjXKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu4zjXKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DACC4CEE9;
	Tue, 27 May 2025 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367182;
	bh=gNrCATfimtWyQGHy7sASLVp2v+Q2OjOp7EzUOWOeMUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu4zjXKsri4CNfnVpfik6yxoQ62mTkLQd9XXiIoO425xibM6DoCiVnDg35r88b6SD
	 Twas6FA2BUfatUNjp5nJtQKt7Olmg+6KpSus0PP1DIWR92J2Jvc3SNAKFN2xP+5MRp
	 iCN71aViabX2Wx8RWWXDtl6A78+4G2DOMC46Y+wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <joel.granados@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 304/783] scsi: logging: Fix scsi_logging_level bounds
Date: Tue, 27 May 2025 18:21:41 +0200
Message-ID: <20250527162525.452606306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 2cef5b4472c602e6c5a119aca869d9d4050586f3 ]

Bound scsi_logging_level sysctl writings between SYSCTL_ZERO and
SYSCTL_INT_MAX.

The proc_handler has thus been updated to proc_dointvec_minmax.

Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Link: https://lore.kernel.org/r/20250224095826.16458-5-nicolas.bouchinet@clip-os.org
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index be4aef0f4f996..055a03a83ad68 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -17,7 +17,9 @@ static const struct ctl_table scsi_table[] = {
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
-	  .proc_handler	= proc_dointvec },
+	  .proc_handler	= proc_dointvec_minmax,
+	  .extra1	= SYSCTL_ZERO,
+	  .extra2	= SYSCTL_INT_MAX },
 };
 
 static struct ctl_table_header *scsi_table_header;
-- 
2.39.5



