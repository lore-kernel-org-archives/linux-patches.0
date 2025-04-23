Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D02F2E;
	Wed, 23 Apr 2025 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420437; cv=none; b=TsRQpeQb0coadKc1sifvgn6USHygCB3nZf6DVgBGJEqfjxSCWqXccdR5AHYT5tVfr5QTA3sew3J1ljWDzYQN3c/PCQSWHIq+Onq3v3VDdcOJEc5L+gE1FIvpOH5oz+RMAW8SfnkZeJZShigmcLxhSMcLHkPGKP8AildN1VC+eJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420437; c=relaxed/simple;
	bh=ACCSwolwaN8u3mM9prov6X36cdd2Fas5ovPxOY3y81o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJX4DtLwDfGJI+E+dVAPM91gz2+iI/qf4rKOIHfaAArnwW7y2iiOtrF9HJHjWQMTCgPOGPisOF2Z1058/+//+wlwxHvdl75uudwoXcHpT31TsQ3FLU5D1h37DAqlYlBQxs8u+mby8b6pTEOPNhgOsoTWizlzUfiOIBSX1wX9/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V00nFNK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V00nFNK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1ADC4CEE2;
	Wed, 23 Apr 2025 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420437;
	bh=ACCSwolwaN8u3mM9prov6X36cdd2Fas5ovPxOY3y81o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V00nFNK7vHveZv1+NyTlKv9v/utArdKGG7SoIcJ6jjQtUIzYrhUyvuONogjuIawtA
	 8iiYRxw7VEE4IFf5hQYxvR0VJRM4tNfM8Y26wOHe6oyfAoIl3PqZLHnLlIb9SN5XVW
	 n94eZewkjZ2bRR9IKd1mmefTdmLBUqYF4sYxqDbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/291] scsi: st: Fix array overflow in st_setup()
Date: Wed, 23 Apr 2025 16:40:36 +0200
Message-ID: <20250423142626.315549883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit a018d1cf990d0c339fe0e29b762ea5dc10567d67 ]

Change the array size to follow parms size instead of a fixed value.

Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CALGdzuoubbra4xKOJcsyThdk5Y1BrAmZs==wbqjbkAgmKS39Aw@mail.gmail.com/
Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-2-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b3caa3b9722d1..7f107be344236 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4112,7 +4112,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



