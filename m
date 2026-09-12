Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB4F37F314;
	Sat, 12 Sep 2026 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240901; cv=none; b=H+nQmfbPZL6lUartbrDvxbNe1oc1pzpbfFu21XHzFV/n3qIcgv6VwakQn8duFm6W9EcziSOPTXEYrSHPn7nQ0gz+KnPTiv+cnrOpnl2yYIpq4IWAZihWEV9TLWDRfDgjJM6CZ2zpZ5TkilTNJ41WiXQpEKMOG2MhwIKSTdMPjgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240901; c=relaxed/simple;
	bh=U9Sc+iRrNoXn3R+9IOT+dieJayRkF00am6NvbzR+gKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsIjbXvy/ZpfiZazYtp7hcjG6oZ2Qv4w+0noK+VynHtDEX8CokuKYAencHI3IqKfSOGrhJ5PWmXMldPt4HQBXjMmo7u1cbMB4HD+8B2G2CmPeIMcoyRgW1m+6bRlmMNcaiKdSXp9+NBHE2Y+en0sy5N39sUsnmMMOX+WP6Pb328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAw11LBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAw11LBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295161F000FF;
	Sat, 12 Sep 2026 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240895;
	bh=lCNXlVZ4LOy0oVdqcGmNU3Bb8ud9hm19MZk6fPSk2g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAw11LBAzdQ0xOYDyic6WD5q0b0Ca4ubZGZ82K8JvQcZZtJRHXVyOwlGSQMPaXLzK
	 NHDwPNUele+D8ldqjrbra9Q+JZIZiLvT8AdH5wVJFNbeOT/Udgg8qlwbmJtHUD5vC7
	 riY1QctImUhoHWCvxI7eEs0nOxa+9jW3jJ4rdcIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 026/798] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Sat, 12 Sep 2026 08:54:14 +0200
Message-ID: <20260912065517.556816953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 5bb01c657ff9fc807c2c592ca18af34c4fc3bc6f upstream.

The stem parser tests isdigit(*(end - 1)) before checking end > start
and so reads one byte before the property name when the name is empty
or all digits. Check the bound first.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260805-nh-of-alias-overlay-v6-1-74f21d440819@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2014,7 +2014,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


