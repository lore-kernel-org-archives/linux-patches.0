Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7B421FF25;
	Fri, 31 Oct 2025 14:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919474; cv=none; b=r2t3c5G6cBf39UtuO1HyUb7Rzj0pF1fvfyu5JaoCKy8YmKN7A86O9wBdlr0PMBivTEWYjUBvW0O4MBcOh4hXLb7xCpqVeQyyPwbBRS7r+RzPaUV/neYTr7LKyz0oUARE3uX6LZoQsiFKWERmXYn1B3FFpdoU2cTg1jWihh9Q5o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919474; c=relaxed/simple;
	bh=Zgi5pdVgQLxH4XoQc78oG39wvTXZ4/l4fAPYgiSnzrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9UwqmHfT+5yOmCJHPfQIqzjuyK3bN/v4UzRyH7aREByyzPmZ22KX3vlzQKn7Cuk38X4/xeCEwoFYX/ezmfOEgJnk1I+ndRXDE46VqkIJFbPJREHOiOiqO/zPSyTapJkl03eFB2Kamsy1Etzz39QqSm6ujCF4vksibsGHm7hJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNX90bXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNX90bXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A6EC4CEE7;
	Fri, 31 Oct 2025 14:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919474;
	bh=Zgi5pdVgQLxH4XoQc78oG39wvTXZ4/l4fAPYgiSnzrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNX90bXqwB23yL5yiBjr0QYuWL3abpFEI+C8PqPmrc1egZyAtm0MhA6o+C9osw4jE
	 8PvMOqaMNuhrCVx6vwuVmJkke2Kh4cM95tAkng0JRgUtlBaYDozBrg4/9lxpXLEj0X
	 uST4osNV2mzkVQfcgxvu/6JN1Mj9lLT456ii4rRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.12 30/40] bonding: return detailed error when loading native XDP fails
Date: Fri, 31 Oct 2025 15:01:23 +0100
Message-ID: <20251031140044.749556932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 22ccb684c1cae37411450e6e86a379cd3c29cb8f ]

Bonding only supports native XDP for specific modes, which can lead to
confusion for users regarding why XDP loads successfully at times and
fails at others. This patch enhances error handling by returning detailed
error messages, providing users with clearer insights into the specific
reasons for the failure when loading native XDP.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241021031211.814-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5699,8 +5699,11 @@ static int bond_xdp_set(struct net_devic
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond))
+	if (!bond_xdp_check(bond)) {
+		BOND_NL_ERR(dev, extack,
+			    "No native XDP support for the current bonding mode");
 		return -EOPNOTSUPP;
+	}
 
 	old_prog = bond->xdp_prog;
 	bond->xdp_prog = prog;


