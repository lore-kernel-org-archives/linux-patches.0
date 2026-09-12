Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEB24BEE3C;
	Sat, 12 Sep 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232792; cv=none; b=ZooNkhQ0oirzVJb3SOSucLz5MCqInXS6kF93GB4JgAQKSvjIvxjZqoJUQupw3CBqZMFjH98HekoB4OqL7IVBpdIa6aTBB30GSj3CqaQPCPEIl73ua2l8TQZVwzWP0goaJ1VdVqEwNJOoN6xIwzl7ONvX21l3x9pofJ084cfA12Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232792; c=relaxed/simple;
	bh=S82ugy3nDYVztv6Ug6Vql7ewc/rXYCQFmg5PUHqPVQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RybVs8jMTSw7Olzh9YuJqn+pNszhzpSSWhHxJ/XRIWDG+lVMQIFgfI2InWkLipVYnoqMYzQBQYQVzJZxxyp5c6W5gmu1Hr0ESP2vTEoBXp4dD2WLW8lUqm/1Cf9UE2CeQw2hHFUaZ9lFcqsmkgbswxx6ez81PIGuZQ0TUIBVYoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edWJjd9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edWJjd9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E561F000FF;
	Sat, 12 Sep 2026 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232790;
	bh=t4OgFU6cTUNMitU2ivHhx4oAYBatwL2aLHTWs2nyU/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edWJjd9mc/MfNJoPybdBSydqxjNoiGVAENRCnz9SbYuc1+MxpczblnyTCw9x/YicI
	 77s5FvFWVIkTGyoEeKJYSVJ9JfBLXJk72ZI6uKey+f6BRoWvfX2eWzGm6Tx65OocxN
	 qUCA5XhB0I90ZC8kPFyrrE/4OM+pRO2pydKgPuwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 029/935] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Sat, 12 Sep 2026 08:50:59 +0200
Message-ID: <20260912065527.507740491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


