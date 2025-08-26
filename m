Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632D35AACB;
	Tue, 26 Aug 2025 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219188; cv=none; b=pOG334DeJSOIbYkSbSSboLjQLvRtyapGHyUNVqDi+KEGE1aaR9kJpTOpR3S9jQs0vJ1OCvFMl+JLCN528VPyeMGR6jygdT4SvspIp85Mjf4E5wxTiV6TNIOkH8VpSNDgbUlO/L2HMcuuCUXvcxIj+pI7N7kDnbH71ACCXcNpoMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219188; c=relaxed/simple;
	bh=OyMrv7rlG2ZQxbYd3dthhSYzG0argWLliQ6AZ0clRW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB+ihfJmq3pLAsDFlDbHq+cNH7LvsLZXmw/ggxym2oVXKBtt4WyjWBpqviPvr+ZhT2uwarQF637+yAozAqlgi9BYpQjOmv1opi8mi1ivQeosTHmvt/gq/OWa8D0vOWe8ME9Ml0cuAB/VabO2Eji60QDa3laUWuHMgyHF3e96c44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi2audQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi2audQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABCDC4CEF1;
	Tue, 26 Aug 2025 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219188;
	bh=OyMrv7rlG2ZQxbYd3dthhSYzG0argWLliQ6AZ0clRW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi2audQ5b+NxV+YSFAGO2nxBN8ioypRkt2eJzHetct0i5lEAMuM5hlGFo51ISVkup
	 c5aX1NuATcNVAxWt7gY2L3EHgG2P7w4c52aZxRGCOMw8kvZpYtGsAGeS3n8saKpB/M
	 nyQdfG5QoaRW1zhPx97TRrQGLAKC4eQvbph20PEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 256/403] i3c: dont fail if GETHDRCAP is unsupported
Date: Tue, 26 Aug 2025 13:09:42 +0200
Message-ID: <20250826110913.895986309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 447270cdb41b1c8c3621bb14b93a6749f942556e ]

'I3C_BCR_HDR_CAP' is still spec v1.0 and has been renamed to 'advanced
capabilities' in v1.1 onwards. The ST pressure sensor LPS22DF does not
have HDR, but has the 'advanced cap' bit set. The core still wants to
get additional information using the CCC 'GETHDRCAP' (or GETCAPS in v1.1
onwards). Not all controllers support this CCC and will notify the upper
layers about it. For instantiating the device, we can ignore this
unsupported CCC as standard communication will work. Without this patch,
the device will not be instantiated at all.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250704204524.6124-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 8604c9e7b6ac..07478ddff622 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1243,7 +1243,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



