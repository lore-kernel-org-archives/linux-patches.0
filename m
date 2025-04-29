Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301012522AB;
	Tue, 29 Apr 2025 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948521; cv=none; b=KLHg6RdBRjAltqojjPn3V1Cd49AU26VHFbdKR/oiOvxV62UGQyerT2FlXi8zjGUrC2vDuZRNEspILGarAmpegeYaclolk4y1sxxZ3KgZOFVEwsh79nFh75AMmhao5A5J9chPLm76uLuPlE83LCyGfOSMTRstEWEVr8BiZyT+ric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948521; c=relaxed/simple;
	bh=PRxmphH85S2+EbZPPA5P0MYi92y4l0htbSrpNjG7Ers=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJaUIh5pCQisfg7s9aNEliKkRHB2HRaxDwIh4u8XZm/DNKMedKOAfkNZzHtsBjXM/tM1SqSzwseROha0ITlS5v00wt2KtF7GQhirzg9YHdYFw+f2GZcwKX3ESsRxWn8/KoIuqzVBJhLpe4LoSTLRvaBu4vpcgTz+nskAgm0LolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Op9o72fX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Op9o72fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66D3C4CEE3;
	Tue, 29 Apr 2025 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948521;
	bh=PRxmphH85S2+EbZPPA5P0MYi92y4l0htbSrpNjG7Ers=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op9o72fXSogHxViFzV99JwuppX6gtIXpPPdr7hcy4Y2Z3XwaEfvOrBDX4LpQgXheZ
	 i9X1lzgiOrxD56R6XGBwpZC91ds4KIZUnbmmIjSuLCfAaDX0TSFfrpicvcbxsz9Sa6
	 3WNTCyiIxoZvX4yj227gbQsvpCdNGLIP/u2SOnAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/373] scsi: st: Fix array overflow in st_setup()
Date: Tue, 29 Apr 2025 18:38:31 +0200
Message-ID: <20250429161124.538476415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
index 1551d533c7196..956b3b9c5aad5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4109,7 +4109,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



