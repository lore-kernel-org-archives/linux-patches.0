Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8B0194A67;
	Tue, 27 May 2025 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365146; cv=none; b=ggduwnbIsiNsjDarC8lL6/7w/6xFjaD5MBP7COAfTzh7PCu5uEYl/qsh1yIjax7l+GHGYsFG0/MT9QJ0iRADa+pMUSPHGfR083chd5NkMdLRBcUKqMVEc9b1ckxVm91jc9sAFK+cE9FnJX+ALrdmv7Ma0yyRG/113uzXN6LkTyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365146; c=relaxed/simple;
	bh=p0TG0WjJD1NN7lweds6J9FDVGjFC1Hvyugb31wwy5jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1729Jqpig8jgpw0vsMt9ha7SU00FJoRGJvHdHiAU8BnxkIFIWcYX1oei1vONTbMNppb6pPe46Zs712sxvbAxuAqJWfOtsObS+v3DuUtoqGL/D96TlkFG8vi5Sq+iujZRDXJf0oOaQBlfjj0iPV3ieFJ/ppF8nAMLirIORkjgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H10p7Kv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H10p7Kv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16333C4CEE9;
	Tue, 27 May 2025 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365146;
	bh=p0TG0WjJD1NN7lweds6J9FDVGjFC1Hvyugb31wwy5jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H10p7Kv1an5ODEXZU0pqxHX3zURea3HzukAwIXV+E4O/NUho1oCeZUmEXn1d7Y4Oh
	 nqbdxGhmUHGGQdsejtDL9DEc650Zr/7UDO1xZhyKUEtbFeLphUfAs11GjXmN5v7PVs
	 G42/UcrwXu2Af0ONwoXgSzBrDIWuZhnHQN7KJ6mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <joel.granados@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/626] scsi: logging: Fix scsi_logging_level bounds
Date: Tue, 27 May 2025 18:22:24 +0200
Message-ID: <20250527162455.208841662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 093774d775346..daa160459c9b3 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -17,7 +17,9 @@ static struct ctl_table scsi_table[] = {
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



