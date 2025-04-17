Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7F01CAA7D;
	Thu, 17 Apr 2025 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912923; cv=none; b=ZaF1CAESgMYSVR+Ax4acAIFavuujzX5Q0EyDCs0WhPTOGA7at2cQFVWXNtiGhtgkxN6aRhZcSeh0g3yd4yATHGBYjPstSKqg76xl51W4Zzp1qxeDjXBpMa+gU9f3zdTFPZA5Z5U3/hsUqIFFXREiWnYTSGQzFbMwr+TKsshhJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912923; c=relaxed/simple;
	bh=wCCmnBdXtD064ArHqWI8Tc9gcpetofPtSlcTvZGuSkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eq4FxBV+9ddlP6yFJpWTyJjPB052TwITiVt1PA9nKLYNqubtjRCouUYS1P8hC2e9BMfXzdo4lUBtj3jJjuUZsEZBoQT5PLE5VAz3OjT/tnb4CWpcQ+GDvxXWmL/8fEBPy9nhcF8YZW0ZWyeeTm7eavEJUaRW78d2fOUldEQAqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kt/wqyZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kt/wqyZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44588C4CEE4;
	Thu, 17 Apr 2025 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912923;
	bh=wCCmnBdXtD064ArHqWI8Tc9gcpetofPtSlcTvZGuSkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kt/wqyZE1kGH3WnnuValiP1LoyxxjAcIK8Owi2VOMhdMqsthH2yTfx2IkhbP6Abua
	 WU5v7pMZikoHsxZ7NDTQ9yVmBCLEgemch4tbjN3CWK2DXggudF/bMZFsJFDuAb1Eq5
	 Axl9ucNIL8+hhFjOWBX09l6FtcFmAyrDEVlF8m/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 130/449] scsi: st: Fix array overflow in st_setup()
Date: Thu, 17 Apr 2025 19:46:58 +0200
Message-ID: <20250417175123.200893439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ebbd50ec0cda5..344e4da336bb5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4122,7 +4122,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



