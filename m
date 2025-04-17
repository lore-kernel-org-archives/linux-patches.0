Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950532566DA;
	Thu, 17 Apr 2025 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914217; cv=none; b=pCP4a0cxSnpchMdWitChAHAR51gdh99X6RlnA1LGTYvQEbYAfv4mLoRB+Fkx2hsnwhMsCTBIcrdeNd03IEpwDpYx5CUBEEMqxWzQLXDHNraoG0esKrzZLBSGQNcAFKBVGCPrS627GJQDQYbaWdnqjP2NPR71trY67t3WMh5ZYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914217; c=relaxed/simple;
	bh=GLTMjoYxtPT/aMHxES47kaPLhc2OUrb5XcYCiGWW3qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mp/RvX3m4VwKCQVB/jZ0epjSCXgkJAU3WZNNN358M1agENL4IA2s9uwdJhkKKbBwSSGwqL92f2JYEiTHto5ziIm7bVppOWM4+MvxQ+5Cajmi+INjFP6oHuJB82oGN2B0UdbUJrpUFHcDWCE77wMeT/PshocqZWO8mzh/FXsfB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpjxtHrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpjxtHrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2703CC4CEE4;
	Thu, 17 Apr 2025 18:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914217;
	bh=GLTMjoYxtPT/aMHxES47kaPLhc2OUrb5XcYCiGWW3qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpjxtHrDvul9NarIWhNvibygnW5JS8InY8XQxK0b7bViaB+aqnV53Juugjl+3vjg5
	 xhKjR5L4gBraX+YUIhzXIg1OE2gwRjJQJnDwNYi2y8MAt03jUCBNDf2N8WsgcKzsGu
	 9qR/jMJCH/xEnfnSyyaYRKmR7IRH4FQ3eqC9mcSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 114/414] scsi: st: Fix array overflow in st_setup()
Date: Thu, 17 Apr 2025 19:47:52 +0200
Message-ID: <20250417175116.021909848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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



