Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01351AB53A;
	Mon, 14 Oct 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919172; cv=none; b=TN/czno7rMRaCTAG6zfvK0wfDybfTtHG+8m9nCaZOTOPJCwRaMbBAbNKjbGM+6oLrbjA7JoJrXIvk66RxGXa8GuNKfLjE3ukL9OGf2FubFkUArm9V/l2Tb5NQteF/mvKpNWhVTIUH7tudQ4C9iOEXhP8CYaIRrvPkWo5ypwdkgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919172; c=relaxed/simple;
	bh=wyqDaPuvNbVtzHttnYrdtY82+oAh/f53HYxkgElIjaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZJhRIy07KMgOQZgi81q2Hsx+tohdITG+swxQikrCOwoRzwMEgg0XYA610ugBTPMOsgNPNyyAc4UqY4UZ3/6HVslTwFj0AW5EsitXyqxmVR+bjKEp06OVYzGeiuvvIvRDONBT9B43TdbikKg7HVSX3W1seCRaqIiyxRQYY70d7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xcTeBQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xcTeBQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EA4C4CEC3;
	Mon, 14 Oct 2024 15:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919171;
	bh=wyqDaPuvNbVtzHttnYrdtY82+oAh/f53HYxkgElIjaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xcTeBQIlZX9Aifa1ZGKWHxvm++QVVMoZnWC17SB53r6Dn0qb8z7Ly8WTgE+m/IzK
	 WLWwrZsAc9MqWdxCASLwHvjrJ/hr/T8YHcT3ULr71v+k94F2hQj7Gb11wik7Rx+Ewr
	 BLTum+OR3QWGNwXu+3IY5ykmY7Rpd6q7o3ca5mz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 501/798] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Mon, 14 Oct 2024 16:17:35 +0200
Message-ID: <20241014141237.660047034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 1c71065df2df693d208dd32758171c1dece66341 ]

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index ecd24af4b3f29..196ee417d10f4 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.43.0



