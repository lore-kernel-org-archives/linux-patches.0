Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253E69DE7;
	Wed, 21 Feb 2024 13:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521086; cv=none; b=hYzBHwPaBObvF9FzEx3ajSiWE/HBJOKWUmIoCqtF6OIAjUyBvjFC5Q9Y447wFjYpcuzjgdOvcnoH5mNHL6AVEtbJeWIF4ZlzbSgXCCR71ilP4iTEDeVBgXi6lF2wP83hbF6WHWsrtu25JMIiZoO3JBmuSqvMkEDvJ4P6iIiw91k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521086; c=relaxed/simple;
	bh=kCe7qGiDtedqPNdAKy3ybqA3s2CLWY3y+AHXYpDMRr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC4RkKbUt9Qm7avmWA692sW2By/zy83XidcumDMQY8z+kwXxVqHZKrppdItCr264RCfQp07VQcaDiQtdQ/KdPHOZB8mopRyDwwPXaWgy7RVpjm+y3YNBfrkSXyIsMM4+mG7GM1XJ7EA17XmNRFOVvDNVvPYWU8vZL6lt7fP9St0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhN7FuxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhN7FuxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C2CC433C7;
	Wed, 21 Feb 2024 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521086;
	bh=kCe7qGiDtedqPNdAKy3ybqA3s2CLWY3y+AHXYpDMRr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhN7FuxQhe6GpcyCCmXjxh0Ou0mAHzbvLILkkHMfO3/XLdeponziLOrHDSeGql/KM
	 nc36wTytbSKxueEKJsvLg9YBiYHyQfkTvbHC0nl7yYd0IcZHaS7G2anU6IHCXvfWqq
	 HCPHTXFSpEyKtMKMF0XeeQC+nArK2kljaPfdVAVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 021/202] Revert "driver core: Annotate dev_err_probe() with __must_check"
Date: Wed, 21 Feb 2024 14:05:22 +0100
Message-ID: <20240221125932.457721400@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f601e8f37c2c1c52f2923fffc48204a7f7dc023d upstream.

This reverts commit e1f82a0dcf388d98bcc7ad195c03bd812405e6b2 as it's
already starting to cause build warnings in linux-next for things that
are "obviously correct".

It's up to driver authors do "do the right thing" here with this
function, and if they don't want to call it as the last line of a
function, that's up to them, otherwise code that looks like:
	ret = dev_err_probe(..., ret, ...);
does look really "odd".

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: e1f82a0dcf38 ("driver core: Annotate dev_err_probe() with __must_check")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1582,7 +1582,7 @@ do {									\
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
 extern __printf(3, 4)
-int __must_check dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \


