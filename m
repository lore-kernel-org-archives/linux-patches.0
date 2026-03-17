Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFF62459DC;
	Tue, 17 Mar 2026 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768288; cv=none; b=ARihBQcXdXuFE4QkWrMvfk88IjWoMS/bNTXszDOPMMvIsS8/Ef9Ur9uRn+s0QgbXmb3NDFDMdxZJ+DJaibutTBv17M5gcK78VujMaeJyJtUpK3kqYbBzVOsW7MdFano47tOfA9I5Cys3UmVN1Ue/0L2X20U+a5MXLbAWiOYbRpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768288; c=relaxed/simple;
	bh=IbUc7weamEA7zpS9PlQn3aHS9XFc+zBXGNPCOcCmKoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbjOkUsBsVPFMeomKOErhtjat/D6WnwFzAMWPV2bDkAW4VteJHBveESfIl19XL3dYQSaxEzjtydW7Y6Y0hHFGeEBSU1k+AqUjD2HBzoe/I5LTRofexoje++QKUAZypfFM8oXu63BfphqopnAD/QvZRj12JAOfcYshufuv0cy03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yluU908K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yluU908K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AF2C4CEF7;
	Tue, 17 Mar 2026 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768288;
	bh=IbUc7weamEA7zpS9PlQn3aHS9XFc+zBXGNPCOcCmKoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yluU908Ke7EOHfzHZ4c4s4etb4it1Q3jYUXIlF3Re7Y4t7Ewb+nugGMDdAuQjkTof
	 6mlxO+6o3ixbtKERVrpBfK+4WOP1PT0pB9jFRVZVrgIjrKjjgmJi/ZxStD6P3xWMdh
	 +7dZ3mUiyw2JVDmAt+oQqA4bI0iRGaYKPhd5J1uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 275/333] powerpc/pseries: Correct MSI allocation tracking
Date: Tue, 17 Mar 2026 17:35:04 +0100
Message-ID: <20260317163009.595320386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 35e4f2a17eb40288f9bcdb09549fa04a63a96279 upstream.

The per-device MSI allocation calculation in pseries_irq_domain_alloc()
is clearly wrong. It can still happen to work when nr_irqs is 1.

Correct it.

Fixes: c0215e2d72de ("powerpc/pseries: Fix MSI-X allocation failure when quota is exceeded")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
[maddy: Fixed Nilay's reviewed-by tag]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260302003948.1452016-1-namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -605,7 +605,7 @@ static int pseries_irq_domain_alloc(stru
 					      &pseries_msi_irq_chip, pseries_dev);
 	}
 
-	pseries_dev->msi_used++;
+	pseries_dev->msi_used += nr_irqs;
 	return 0;
 
 out:


