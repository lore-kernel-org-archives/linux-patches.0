Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71A31FC7E3;
	Tue, 15 Oct 2024 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998464; cv=none; b=EFsAdHSkWA7ecMMcv4oouOjp2dBIBSskZ/9ZYaDcu97yo2wfuV0/65hm8zwXEhGA56EQg2yg5DWloW8AJk++4OWLU6eG7ns/T5JeTJWWnumgIK3U4/15LaoQXxFNcs9dgHv+DFnbhMh2ZZpOLnuZI6JWZX31NuDEYVVScmCCGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998464; c=relaxed/simple;
	bh=T7ADiyXwX/CE1sNXOBpMNW/THlVXeHCiMyq9Q75dF8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9FR2Bsa9pjitqHCL21jzlgEYqQzNrN6Lj10jXh7WYQkF6Fb9w/KDdHGPav1QyckTXhJKnOPZu7gVH94KW2KpjuHtGeVzN8Hb6bVlcxh4DXSh1DOPAJlvez4bZopIzPTZCKsxSqhiPUcoYFckf5QQrTdRWZ+eokNn7nLwng3YNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWklBvW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWklBvW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC17C4CECE;
	Tue, 15 Oct 2024 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998464;
	bh=T7ADiyXwX/CE1sNXOBpMNW/THlVXeHCiMyq9Q75dF8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWklBvW3U5FLqvl5kEKil7t3HGqXqzeEJOe9kX+ruaU0vKz20bEl70N9/A6CE7uaA
	 2baiFje3YsI6ACeSZN05URHrP5J4JJkhRPMLZ42MI4edoAvcSwdUYLBkI6ASIg0Xs/
	 kusXgf0Ik7csFwYbZ49mrlE46eTHWpB3e6SSfGnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/518] net: dsa: b53: allow lower MTUs on BCM5325/5365
Date: Tue, 15 Oct 2024 14:46:29 +0200
Message-ID: <20241015123935.718800890@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e4b294f88a32438baf31762441f3dd1c996778be ]

While BCM5325/5365 do not support jumbo frames, they do support slightly
oversized frames, so do not error out if requesting a supported MTU for
them.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index eea4d61a354cf..459caaf6aa613 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2182,7 +2182,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	bool allow_10_100;
 
 	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
+		return 0;
 
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
-- 
2.43.0



