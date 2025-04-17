Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E7F3770B;
	Thu, 17 Apr 2025 18:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915394; cv=none; b=MPwkRcPTQ2RGSKmnlpRUIXA+qbdJYycLynNOuk9iha6z1IoIywmjPTw4LQZs66PTP3yAAGeBM7whXShaGwVaRw+oHf7jigYFfLa1AHmXIuXKXzyQnzP6sMdYj0OXu33RlW6n3+rMOcQr8psm9EDOyev+8NfdhiTbKlUM2bishM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915394; c=relaxed/simple;
	bh=x3SywuuiKMNf1nLBpZ/WZYQR4Dlicq8MbHa/rlkAqDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rafUSyUdzwo6uHFtXy1ejcP66lBjCHEfMPGz5GESWJV1xitSbXkXmPSqih1xn0X9QmF4ks/CBejTVantaqYSpPHi3fCNJ0rFngsrhlXhchIu/JIvkMIz1kdQ0SfF+6IjPBDTLguoktI+EutHTTGzXtRtWWcJ7opKB7qgsy8r804=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyS/eY3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyS/eY3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E055AC4CEE7;
	Thu, 17 Apr 2025 18:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915394;
	bh=x3SywuuiKMNf1nLBpZ/WZYQR4Dlicq8MbHa/rlkAqDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyS/eY3wpNLv0XJDBlJ2wPVgZd4gfdQoaBwvrAUY2pgyy0re5M+p/khTf7zRmWoV8
	 9Tgk2DH8itWB3l3PfEZGnrTT9+3WcHGkY+NkLZSIqGFw+C9BAWyM2Q5k/u7fvKqsQ0
	 4ymsuHyq4diHnrGtMUbwvfDsqLUDCKik23S5eZWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/393] scsi: st: Fix array overflow in st_setup()
Date: Thu, 17 Apr 2025 19:48:42 +0200
Message-ID: <20250417175112.131681758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0dc37fc6f2367..a17441635ff3a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4119,7 +4119,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



