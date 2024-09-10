Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CECC18A6D1;
	Tue, 10 Sep 2024 10:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963015; cv=none; b=r5OUVCIynO+gLJqn14cj2Yia82H1Wnh2hqa0itJpLhxdAdCdrAtgvft4s8fludrCKAwd2zG7h24cMCp5ElGSF8l4PQE5MebXQ4gXUz+VymlpsH/Ov40ZMlk+BbqOA4BFvqp0GDqRv4hHfRc8qsl6vfMNY0xkm6BMrcH324UlYwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963015; c=relaxed/simple;
	bh=EyjnZiJYdSSHClv7YERA39f23wy6GGbkJHxdOwXZM+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLSIvyoxAhO6CsQ3QhAbSVE8pGbf4Gd9aVmnphR4U4gRoeAOTHrUTCjSDIwJ+sfriY8PxcZUqMeFSfTj+JGS2oHIGFuLfb8N8yjCRAbzpgZuG19mRzjxQj+4enhgeE4tF0O9RScoo+9N9VwXRUnXVEYxmSuEdBpu2B2wleq3fNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12DDV7Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12DDV7Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F21C4CEC3;
	Tue, 10 Sep 2024 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963015;
	bh=EyjnZiJYdSSHClv7YERA39f23wy6GGbkJHxdOwXZM+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12DDV7DkELXMUANaZyYAfwYy04fKMXCebkQsR9lZhABmPfTs1rWgSWzydHkNuRGiZ
	 Cqf5i0O0cyF75llWYT7YSgBzmXMH0kXFOLjjybT+bodqR3IpkpnBWM6U81S+UpTn8V
	 aU8Yh+Q0pSQjXBIsdkp/hRZ+i0K2thSXuLH8Hj3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/192] igc: Unlock on error in igc_io_resume()
Date: Tue, 10 Sep 2024 11:31:43 +0200
Message-ID: <20240910092601.244305914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ef4a99a0164e3972abb421cbb1b09ea6c61414df ]

Call rtnl_unlock() on this error path, before returning.

Fixes: bc23aa949aeb ("igc: Add pcie error handler support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 39f8f28288aa..6ae2d0b723c8 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7063,6 +7063,7 @@ static void igc_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 	if (netif_running(netdev)) {
 		if (igc_open(netdev)) {
+			rtnl_unlock();
 			netdev_err(netdev, "igc_open failed after reset\n");
 			return;
 		}
-- 
2.43.0



