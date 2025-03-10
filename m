Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD86374EA;
	Mon, 10 Mar 2025 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630821; cv=none; b=S/RjKXo817dwSDmKpWLunu7MY0G9ksypH1NQQxjCeTbkH/EF4Tp5oanitRh4NjcKcaIpAzrOyoc0hkue8PADPMvJQBNDvRaP1ZxIgpXZDmUjQ3JRJiqqaaawaby50FbE3ILBaPPgZ6Fj5KJZytHFuAM9oxnI+cpOdXm8i4IEbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630821; c=relaxed/simple;
	bh=UjHYPE1jE8CHeqKeSZIBq0JDtfM2vwCe/x/cXVqCwTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKhz6w2ekdR2wJivNcKUy11ERTf8i2N6HaZKUM0SDOSbnB0g/ljJcF9PAuAWr5JCq92PCmBHeQ+JuX5bHfhm37GENTjXuw3vV901sKpCXLiEfAZM7Rk/dGUnXSIBmPxyKSMleh9IRePnZtNXaTNknQPkkLnZPoCoXPQcAm4C7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJuELDCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJuELDCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14967C4CEE5;
	Mon, 10 Mar 2025 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630821;
	bh=UjHYPE1jE8CHeqKeSZIBq0JDtfM2vwCe/x/cXVqCwTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJuELDCjtrE5cFl/gEC9dGKu6GnGJhMSqgGKbAu4IkFv9sz95pGNNRP5/AhczB0Ch
	 dKTVOJ2cm3590M1z3cfSKbIXxjeWli3phpU7IQ/BcX5k3kKcqSSQ7/tJykFB/3vNuy
	 rkLEAV+JFCqnigi+QWRnecsCYXhq/lV5M76bTxC8=
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
Subject: [PATCH 5.15 546/620] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Mon, 10 Mar 2025 18:06:32 +0100
Message-ID: <20250310170607.097428918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


