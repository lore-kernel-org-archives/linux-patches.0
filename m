Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3D733290A;
	Fri,  9 Jan 2026 11:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959533; cv=none; b=UjBsSUKscFZllG5nscFfSJuhDd1tcpGuJ9I8teiLBZvPMc3EJ6pk1yIJF+ZGcAJeXWlWRI3oaupImnW2JO1avdTOcR90ZsgZevVUhbswBTURRAy2OoEsLVpwarh8UWnQr0LzZOjRTpiutVr5Kq12p5ttckzHX2+Qo3MbBxu4RlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959533; c=relaxed/simple;
	bh=8db0xFfNODmTqybp0TOTaR96BWqiAmAJZqo+Nj8Gltk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULey+CzEHwxZkgeVTM7UUlgV0v0wQC1ih8B23cYRyiRg9pp9QtuMAcyqY36i01QIvZRRaHz9ZcTvFCuA01SMtdoSFOgKxvHRzvPvu3i0eHnj0DEtQURqPvc9kQwzcmPjZ5msZhBAJYqxVeOI4PvDi4HRP1qgck3D66IobEmEa0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFcAy5//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFcAy5//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16118C16AAE;
	Fri,  9 Jan 2026 11:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959533;
	bh=8db0xFfNODmTqybp0TOTaR96BWqiAmAJZqo+Nj8Gltk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFcAy5//JPW1hLFT+GQmFj8GpT1kl+J8kZRTlmqDqPGi/ThytzVZQ24X0VG0M0kjp
	 54dPbJi18iq4rQmZk5GggTiMJrl88JsCBEBHGbSeIA3F/cbH2bPHvpk6BiPUmh8EW9
	 WoYz9TBZjBCATBF2U0qD1UAW2gyvi5JSzUappqXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/737] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Fri,  9 Jan 2026 12:33:45 +0100
Message-ID: <20260109112137.233215484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 020d5dc57874e58d3ebae398f3fe258f029e3d06 ]

If no AP instructions are available the AP bus module leaks registered
debug feature files. Change function call order to fix this.

Fixes: cccd85bfb7bf ("s390/zcrypt: Rework debug feature invocations.")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 93351452184ab..97cbf233a543d 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -2235,15 +2235,15 @@ static int __init ap_module_init(void)
 {
 	int rc;
 
-	rc = ap_debug_init();
-	if (rc)
-		return rc;
-
 	if (!ap_instructions_available()) {
 		pr_warn("The hardware system does not support AP instructions\n");
 		return -ENODEV;
 	}
 
+	rc = ap_debug_init();
+	if (rc)
+		return rc;
+
 	/* init ap_queue hashtable */
 	hash_init(ap_queues);
 
-- 
2.51.0



