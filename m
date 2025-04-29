Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B0D23C8D6;
	Tue, 29 Apr 2025 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945266; cv=none; b=VKdZcU9JVsCAdxCuKZZvXJyL1raBFKRDaJpwIzt4lolr7p/vmSdkolhLtrWNeu4qhdPsWpoC8/EvzHSshnfHlFFSo63zhjH6fCvIksDIriYKrvurl9GHfBYbvFIiuJxyrIqw6hAvW69xjkf7hmHHlbwMCUoA1CiTdu+XtqJVXHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945266; c=relaxed/simple;
	bh=8IRjGLWMKnyLArvctRDAF/NCTvmLA0Z1c5Zae48Wdlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfLYFN6Ij9nmFoizwhwIkn0VIso5boxgSxBVSwi3fJUjtQOB4OZqhVyi28Otnt0YMftgoOy21uBRIXIO+bsdxhBvIvWhhZbgM1PQIL2gzQSQqfrBmGrkDiEeRaDJzhQGC9IEKGkPXB+uVOckoQwmlkRGLXjRxQiD85ZDOFrMP5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp+Id2Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp+Id2Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEEDC4CEE3;
	Tue, 29 Apr 2025 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945266;
	bh=8IRjGLWMKnyLArvctRDAF/NCTvmLA0Z1c5Zae48Wdlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp+Id2Md3/HnEH+X3hRFbehaFPmK2rOCcmvHqo7IFIp3LWkTqa+F8g1OvsBRIQnN8
	 YFrIw/fNSHiW6B9Cn0mXSjpBSaoceKd/CjvfPr+SKFUR7TFnw4e9WEUs3gV03I2IkS
	 RchgcYb4CMt/ugaUtUVW7g7pPW7oz1M9p5bLf0O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/179] scsi: st: Fix array overflow in st_setup()
Date: Tue, 29 Apr 2025 18:39:26 +0200
Message-ID: <20250429161050.429884961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 49e149d28954a..2b5e3e2ba3b8b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4124,7 +4124,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



