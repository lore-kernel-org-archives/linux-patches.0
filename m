Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272F26B0A5;
	Thu, 13 Feb 2025 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459601; cv=none; b=g/6C6uXecgWgXXkCuCCxG/meo54SFQkFI42azEzBJgxyyon4wP266/lo6nO+k7e2WXBAN4EmOZ+5eRDi5aCiEQCYxaTxTIlQyTXaIkyzKjYoViEgJakKdDDvWbXJvgnt28UItJdSFqeuP8h1eAiBr6uka1Fqgos4wCrGqTbUp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459601; c=relaxed/simple;
	bh=rNLptWm48h+b9NfvnWye+7PmzJGtRjX3Cl6xID/chTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjYbqzQRJZJtE/oXMds/XZLgmZcq4jPy7cqIp+9FyhW6k6LGaCEWthLuI3eEHv2LeUtwGdPoLziNzJPgry68/QqWs1dRoj+zVVvdrYPXTq7cbHHb+2TgP3YiBWbLAPh4jFrgBJ1albayr/JsQoaTozkKPFoASX9t87ztfmV0Mx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alR9xIQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alR9xIQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8060C4CEE4;
	Thu, 13 Feb 2025 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459601;
	bh=rNLptWm48h+b9NfvnWye+7PmzJGtRjX3Cl6xID/chTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alR9xIQUSbs3HOZf5ngYCR90OEIDiJpQFMYfamjj/YmkmtcMEne+x3JVJatOr0QiI
	 pFt149B0Ko5cT1S/GeVkzkBVf0uiyERu9mQnuDD/NtNnjqMYmWqsWrSqGP24BUbbRl
	 cyHAvJGw7bRKwC+y9sy8hEri4UacxpqTzv2XUnZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 280/443] scsi: st: Dont set pos_unknown just after device recognition
Date: Thu, 13 Feb 2025 15:27:25 +0100
Message-ID: <20250213142451.414569996@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

commit 98b37881b7492ae9048ad48260cc8a6ee9eb39fd upstream.

Commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling") in
v6.6 added new code to handle the Power On/Reset Unit Attention (POR UA)
sense data. This was in addition to the existing method. When this Unit
Attention is received, the driver blocks attempts to read, write and some
other operations because the reset may have rewinded the tape. Because of
the added code, also the initial POR UA resulted in blocking operations,
including those that are used to set the driver options after the device is
recognized. Also, reading and writing are refused, whereas they succeeded
before this commit.

Add code to not set pos_unknown to block operations if the POR UA is
received from the first test_ready() call after the st device has been
created. This restores the behavior before v6.6.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20241216113755.30415-1-Kai.Makisara@kolumbus.fi
Fixes: 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
CC: stable@vger.kernel.org
Closes: https://lore.kernel.org/linux-scsi/2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi/
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/st.c |    6 ++++++
 drivers/scsi/st.h |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1030,6 +1030,11 @@ static int test_ready(struct scsi_tape *
 			retval = new_session ? CHKRES_NEW_SESSION : CHKRES_READY;
 		break;
 	}
+	if (STp->first_tur) {
+		/* Don't set pos_unknown right after device recognition */
+		STp->pos_unknown = 0;
+		STp->first_tur = 0;
+	}
 
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
@@ -4328,6 +4333,7 @@ static int st_probe(struct device *dev)
 	blk_queue_rq_timeout(tpnt->device->request_queue, ST_TIMEOUT);
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io;
+	tpnt->first_tur = 1;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -170,6 +170,7 @@ struct scsi_tape {
 	unsigned char rew_at_close;  /* rewind necessary at close */
 	unsigned char inited;
 	unsigned char cleaning_req;  /* cleaning requested? */
+	unsigned char first_tur;     /* first TEST UNIT READY */
 	int block_size;
 	int min_block;
 	int max_block;


