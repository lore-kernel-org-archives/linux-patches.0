Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA0226D0B;
	Mon, 10 Mar 2025 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627996; cv=none; b=qC54pofAm4n7+fQaJGMbOfTtz5XyGhN4ljKzCURCGhjskEbufNF6ED6r/HEV2zICDJqH9paGZtKAtAFSTb2B6ebcKMgSXUAgqve/04OsEIEfe3eLUOxk2K0Z7JEjgAiXQ8yyEfVkaMrV+iBTnLZQ+HjUCAx/GqpkqwFd3gECXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627996; c=relaxed/simple;
	bh=ErflIqqbS0aE0EZ8D4MFhlTKh4ugIQ+O1fPxBdfN18s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P57LHpvr3hbG7aHYkDeRmcuoyGr04fo5P1GPH1+RXG5s6P89oNsbGoR8vDeD8cqEhwlLqnx+E1LJENMB2HqL2P28rH+dsMI2EIaCmL8KavV27FSUtSRwXw8GzvMPtvac8jSSb2S+HiqMWpOhFU5uh+Qq+NE9wxwk369am6QaDe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCrDk5cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCrDk5cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AB3C4CEE5;
	Mon, 10 Mar 2025 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627995;
	bh=ErflIqqbS0aE0EZ8D4MFhlTKh4ugIQ+O1fPxBdfN18s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCrDk5cNGFjyMZ5u4zOeqVihhRGh3N49QUX1RaqCdct6oY1AEitr70rkhgM/HLm8d
	 x74qN713UQLfkKenj/FgUnKQaKZIhlRM4ofb9Q7P7qSSYPYjTdnBeL9E68P+5UpCzy
	 WWLLCGKT5bxmOwSY7VBIF0Bl5iTpPcXEyFuhD6ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 051/145] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Mon, 10 Mar 2025 18:05:45 +0100
Message-ID: <20250310170436.796027897@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e842f9a1edf306bf36fe2a4d847a0b0d458770de upstream.

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -871,7 +871,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;


