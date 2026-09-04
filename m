Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E8C35AC03;
	Fri,  4 Sep 2026 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502029; cv=none; b=ZP8tsY2zdK+Zy7nh235Z4/elYw+40b+6RS+uNAG9JAsI6QsO/izms5tWxMK1KQzYU5PajHCOYj54R7NGSCPfzQZV2B62kSSsM/0I804wVKpaeTBFQDMO7BwNSTkULf5p7Fay2cwz4ZX0kuL45MJkRY46XIUrkGuxbB+COJfnnBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502029; c=relaxed/simple;
	bh=NpruBYwS2Gr2HpcM3OJkz5zQYPKfWRRgBgT5PgMY9wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP7TJsYi1zVbcqtm3vkbl4fAQIpj5GGZJeUST2NATsr7ueQrgMK6UjdH3k68HAJbJeCEXPP271PRybZ+1Ebf1R6B9fIzb8g3WeIQqJ/QpmMohGrTn6IXHVyw7istK1th7PhhunZ9KGlUEnBpbCaz5dc4SErKsKL4705GaROzxXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0GcIZtE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0GcIZtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4B01F00A3D;
	Fri,  4 Sep 2026 06:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502028;
	bh=2UKbnekbC2y9dvCFrWMbwXuTQQDgUxH+zY6vuzrb3t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0GcIZtEbO/PK4OBUO1INA3W2Rgg2b/EyGeMRvLpYJGSDnE0hEnDNdHXGqfa2X8oI
	 rMuqSW+ef2NCtHXelfcYk1Pi21hDsPZxVETmRDk7uxaRc+lamePsDO9fxx5YZXMTJW
	 mfVfQgsvLg7vkOWX/dM654j0bliy3frfd06fGgtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 064/403] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Fri,  4 Sep 2026 06:57:47 +0200
Message-ID: <20260904045736.287131907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1818,7 +1818,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


