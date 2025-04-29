Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AD6213E67;
	Tue, 29 Apr 2025 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946790; cv=none; b=n4en3Nbn2mwrh13AX1p5uSNOyAo017h27K2HMmXd6wjuiY3ExqQHd9r8wQd7MUCVbv5W9dbnKOt4t5md+1ivR6/F/wRFgbn360BFAgDR6C+pcXsPw/2VnCJgtIpXPrFTyDWI6U/459zaa++I9rqDU2rGOjUsscj8E9UZnsDSoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946790; c=relaxed/simple;
	bh=pleTXwg1DcIFyn2LRd+MfbOW5eTjpPtb5b2DPrk4T98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LpCk6YuRQVAWHaHnAofFAa4Jipm8/Qv8hxIKFKhbS3dcOldQS9q77CPMUe/T2KvnjNxy8R1wGW+U3Ko/Wqss9Vc+AzZNfbUXCHD2NdBL4V9JHjzdyp8qo7IpJEalAmYKuMnryC2am0fxUFjg4fFSM2O+SoFWVd2ADKRHP3XFGmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVPi3cUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVPi3cUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8F0C4CEE3;
	Tue, 29 Apr 2025 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946789;
	bh=pleTXwg1DcIFyn2LRd+MfbOW5eTjpPtb5b2DPrk4T98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVPi3cUfxedHP8YeSwPKjFj5OqSwpADvd/akO+nbwYafQyJf0ISvqlIvTNZBji1n0
	 BEWRewKK0Vt4oApAXhuXtohewolUde2e6P5ClvUCKgU5TCLiHW1Z/sk30rZZLDR971
	 yGiaRw5TyNaR4Ah9BypuS5vriOPJD49c4Ohf0czk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/286] scsi: st: Fix array overflow in st_setup()
Date: Tue, 29 Apr 2025 18:38:55 +0200
Message-ID: <20250429161109.137769154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b819c6b15a56..465fe83b49e98 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4144,7 +4144,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5



