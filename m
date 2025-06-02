Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25531C5D72;
	Mon,  2 Jun 2025 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876005; cv=none; b=tBcYjlINddmmkuTl9pl5wg3Zlk+P+6kR/aAquAyYVtwWa01+t7iadPcD5nsAI1jCOrxuoeXdFv2fY324dSkBxvjVYR/kPuDWAyIjdhmbP+yosAV63ch4heWDLnqQOr8R/x8epgSrP+30RPUPklVkUkB1Ihqgn+u7R3RqQTURJzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876005; c=relaxed/simple;
	bh=zFLiObP3mxFaW1jAR4ObN1g5d60HSCZns6tZWOS/Gmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUmfixx+pOgrfcdxK3w4f/1iZEpHLaD8doNZpnp5hLO2FnsnjEQS5XJWMiRDYpNLlZzso/bXxh2lJijPfFIuyzzfGfdtDJNcnvFdOlEy6z7TTaUo2PFaWx3n12SEUAefh4HnkxgqAJnn83hh7xseMXzuehwg9yIlk0iTJCLX8EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STa7L9TN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STa7L9TN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F65C4CEEB;
	Mon,  2 Jun 2025 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876005;
	bh=zFLiObP3mxFaW1jAR4ObN1g5d60HSCZns6tZWOS/Gmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STa7L9TNRnlrEL2cq3ptgc92KawWE0lP9EPgQaKjJ+t4UTMyTJa+cpHjBxJfmVxlP
	 1/b8HtlDwgVnmmbfO7fUy6uVrU5Hdrq7HHRLej5aRD2Pvko/fMoewqqHcHkMhp7AK8
	 P4jBKvnCc+tBXdr6XQkTpy4gPADy04sb1X142/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/207] scsi: st: ERASE does not change tape location
Date: Mon,  2 Jun 2025 15:46:53 +0200
Message-ID: <20250602134300.368970835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a58cb2171f958..26827e94d5e38 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2884,7 +2884,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



