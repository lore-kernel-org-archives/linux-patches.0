Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9B3B38A4;
	Sat, 12 Sep 2026 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239487; cv=none; b=kGqE/CeWNFwipNopcnPgNbSM+tkWf25u4HUbN/822BbNDYYYBkJnCCH2tffEc6tj1fOz68UbLu2frukP+GgM6UH37qWZRZBmlST3y7NherdPG7Dyk2wtSphk23TLW3jike2EdEPsd6Jq/P2U4BTLzzIYcH9NDjAFN7IRPqMQodk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239487; c=relaxed/simple;
	bh=qBUffGz2IShr/qmGNZYMBvzI6i38UwMfbmABB5R5+AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS6zEss0FZcHhrzFYBC35z7/AkEfaB2cy5azGOP25hhf95z52tnFf4eYmycG/Pm3fMVymE+nxSNqN0UjAbvlot8a580SM2lnEZ+LRnitZp9s4JSAx3xekt6ekaDeEnDP85Z+XnojGBMAlh1hkQAxKMUUNnWfLeod2HFU7EVhGjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqsoi8Mu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqsoi8Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D181F000FF;
	Sat, 12 Sep 2026 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239486;
	bh=Ho8ktWHgB7gdRUaQ9MrbPBfeRId3yMPo0VkowVg/Y+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqsoi8Muj2DMvDR5MGehmeMes2YWIxNMwQzrztWdoA/8lptJR6g4X3stsSitz66NF
	 LkgC7PFcs+gXuTY8YzfnFAdmDLScXYewpRdT6ht+0L09zTEm4CGLdNWjFIVugsPrPj
	 jvY8FwFYbnRD034sCpVB1RMyJNP4RgdoVX07fuQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 632/935] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Sat, 12 Sep 2026 09:01:02 +0200
Message-ID: <20260912065541.335399716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sajal Gupta <sajal2005gupta@gmail.com>

[ Upstream commit 371f7a1b392edc8b7cf449cc7713179b588f2d0e ]

The loop in ppl_do_flush() continues iterating after calling
ppl_io_unit_finished(), touching io->pending_flushes and leading to a
use-after-free.

Add a break statement to stop the loop once io is freed.

Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260622142146.56637-1-sajal2005gupta@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-ppl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 3ddc2aa0b5306..b21aa32dd6c49 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -654,8 +654,10 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 	log->disk_flush_bitmap = 0;
 
 	for (i = flushed_disks ; i < raid_disks; i++) {
-		if (atomic_dec_and_test(&io->pending_flushes))
+		if (atomic_dec_and_test(&io->pending_flushes)) {
 			ppl_io_unit_finished(io);
+			break;
+		}
 	}
 }
 
-- 
2.53.0



