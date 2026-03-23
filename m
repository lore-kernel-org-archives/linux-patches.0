Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82B2285417;
	Mon, 23 Mar 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282947; cv=none; b=JemMnKWDfry4/eq9nz3PC0zp0f24F5vEJA/Lw/iI6lfgIJY0WttqaPFEeVprs157UD494Gl5ijH2FdGjuQNZPfFU6XeeOGNsgMjL5BL7jRjRK2brvD/hWFiU4q74DaHwLjcaCa+NZWtX8erCzWLR3+R2WnzWdArXxIVH++J6RPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282947; c=relaxed/simple;
	bh=1q+0WZjP//MUfyw1Fq/9isyEHH8sY6SxNJjA/XF4lGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtipnweyLD4nzSlqCMgIcytTS5y9xIYZRZaqk2lB1/acfd05e/Djvdf/trOHin9EZxAbyKIn4Ji/t8CIFgDJXsxdn8AA3+PnoauThxkWGk7gceXFG7yY1TgC72U8axOGVilMIb/qX7UzJERDtRmmMeuEwGFs7xvi8wWxH+aTgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxOxQJ39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxOxQJ39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467FFC2BC9E;
	Mon, 23 Mar 2026 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282947;
	bh=1q+0WZjP//MUfyw1Fq/9isyEHH8sY6SxNJjA/XF4lGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxOxQJ39s/AWLZCSHXx5wgV3ODCQqxD0Gf7OTfm0Ezna/PgW9yyWyBbETD44MFaoP
	 MYf4V/bynrNJltDWZOOux/68Ef8eg1VOz9BOVhpGH7mI/WNNdMuV4IgwZLl+KqGv0u
	 ChzvmowwamkXMStG4n4YVGaEmvhc5qtd5d+BEo9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/481] s390/zcrypt: Enable AUTOSEL_DOM for CCA serialnr sysfs attribute
Date: Mon, 23 Mar 2026 14:45:27 +0100
Message-ID: <20260323134533.509902815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 598bbefa8032cc58b564a81d1ad68bd815c8dc0f ]

The serialnr sysfs attribute for CCA cards when queried always
used the default domain for sending the request down to the card.
If for any reason exactly this default domain is disabled then
the attribute code fails to retrieve the CCA info and the sysfs
entry shows an empty string. Works as designed but the serial
number is a card attribute and thus it does not matter which
domain is used for the query. So if there are other domains on
this card available, these could be used.

So extend the code to use AUTOSEL_DOM for the domain value to
address any online domain within the card for querying the cca
info and thus show the serialnr as long as there is one domain
usable regardless of the default domain setting.

Fixes: 8f291ebf3270 ("s390/zcrypt: enable card/domain autoselect on ep11 cprbs")
Suggested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[ preserved zc->online as the fourth argument to cca_get_info() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |   12 +++++++-----
 drivers/s390/crypto/zcrypt_cex4.c    |    3 +--
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1689,11 +1689,13 @@ static int fetch_cca_info(u16 cardnr, u1
 
 	memset(ci, 0, sizeof(*ci));
 
-	/* get first info from zcrypt device driver about this apqn */
-	rc = zcrypt_device_status_ext(cardnr, domain, &devstat);
-	if (rc)
-		return rc;
-	ci->hwtype = devstat.hwtype;
+	/* if specific domain given, fetch status and hw info for this apqn */
+	if (domain != AUTOSEL_DOM) {
+		rc = zcrypt_device_status_ext(cardnr, domain, &devstat);
+		if (rc)
+			return rc;
+		ci->hwtype = devstat.hwtype;
+	}
 
 	/* prep page for rule array and var array use */
 	pg = (u8 *)__get_free_page(GFP_KERNEL);
--- a/drivers/s390/crypto/zcrypt_cex4.c
+++ b/drivers/s390/crypto/zcrypt_cex4.c
@@ -85,8 +85,7 @@ static ssize_t cca_serialnr_show(struct
 
 	memset(&ci, 0, sizeof(ci));
 
-	if (ap_domain_index >= 0)
-		cca_get_info(ac->id, ap_domain_index, &ci, zc->online);
+	cca_get_info(ac->id, AUTOSEL_DOM, &ci, zc->online);
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n", ci.serial);
 }


