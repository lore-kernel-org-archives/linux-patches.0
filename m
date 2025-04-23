Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6727CCC7;
	Wed, 23 Apr 2025 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420695; cv=none; b=fOIqpSUM+8Gm/auRXVrgBCuC5GWgWFCfm73+Qg+pqnuls2TgDVW0QqD4HTY6WKTQB4IdoT0yGxiLwtiFZ5EJmc2WEImX4tlApWLrKNjcU0LsgIlmYz4YiAF8Sc+Kd/3L2R+2z+4HLvR3jG00fSW8rvL0Xl6IJFVvb/rd7uS2+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420695; c=relaxed/simple;
	bh=XFY5QULVPeScLWnp8gJy+pvYlDU79LOFdl8CPa5gUoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPkk9vrhKvIKJJrwfbz4r5xE8/snqt+xRQ/y6SC4DppdhWC3Exn80l1YM8wIP53f0BESILaUwGe4QM5WMLe9o110q1SBFBC86lFqdn+o+6bFYD0GmKB6je7hWkBzZApFW/77KYAATtP38F79oTNAXFwBBh8XysZ0VC+hdngsqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUsR4p58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUsR4p58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380B6C4CEE8;
	Wed, 23 Apr 2025 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420695;
	bh=XFY5QULVPeScLWnp8gJy+pvYlDU79LOFdl8CPa5gUoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUsR4p58uEFUSS/QXrorCytn7n7BOcvzCpCH7xxBDz39FUCEA3oq6TAo+7AVYon+m
	 9yBdT4t8efouYSJPo4kTHgfr7wF8O5c60Y0vRwn3jtQ3m5GpxEcWUfgd+Rf6uxN1fN
	 CxG5WcdAvsvtSCi7YZHAkIkzBKEi1quzFNZUwU08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/393] scsi: st: Fix array overflow in st_setup()
Date: Wed, 23 Apr 2025 16:39:41 +0200
Message-ID: <20250423142646.807736010@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bdbe94f30f070..900322bad4f3b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4120,7 +4120,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



