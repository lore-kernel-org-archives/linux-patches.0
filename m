Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A084919E7FF;
	Tue, 16 Jul 2024 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145180; cv=none; b=WDWrC1eXrIdtpeJBj+GVaonwZujEe9chmYZXYcKg2/yuJNA6hn7YRH6f++LgwAU6s4Vito5HLjqawBt91Ky6oYf+aJsyLq/dF7q27D0GqCfnw3NZmBRcgYvzLKA6yC/dPMGY94h9yR5Hw9S1y+EFeRLA3/EPiyJho4+TYCgvGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145180; c=relaxed/simple;
	bh=A3HF26ZgYFOSyYd5MCPHZ1EyNbDQL66viDv8ZAOZc3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SKb4eMZuLXnl0NEJ47eEKDGbAUnltHWbI//lYMXWpjl3BKrXOCaPQSinyjijPPjVY5T9rez5v64CGK6hQQyPJqfLw+t6Uz1NLQLfodqR1+QjZtB1xdwhyHqpw2XsKJa+0HgMwkzwrNIGo8roDkonE3oF+sj4b8FSmTfhz9zygds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAsaqAFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAsaqAFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265A8C116B1;
	Tue, 16 Jul 2024 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145180;
	bh=A3HF26ZgYFOSyYd5MCPHZ1EyNbDQL66viDv8ZAOZc3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAsaqAFvNTSMgavQ573BoY4tptsw8mwRzOVtQBymZmC1C3WDImzH85mT8WxXe7iu1
	 Zw+SVSYFP40PFIfQYcR4elQK5O+fQGTIMSTFPjO+Sxfv4RfgnQ/mbUCG28EIqKTDOo
	 dwSpaA1jUO5PPR4aDvBxcrKywj6V1HyE5pUpqyds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 094/143] iio: trigger: Fix condition for own trigger
Date: Tue, 16 Jul 2024 17:31:30 +0200
Message-ID: <20240716152759.592395554@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: João Paulo Gonçalves <joao.goncalves@toradex.com>

commit 74cb21576ea5247efbbb7d92f71cafee12159cd9 upstream.

The condition for checking if triggers belong to the same IIO device to
set attached_own_device is currently inverted, causing
iio_trigger_using_own() to return an incorrect value. Fix it by testing
for the correct return value of iio_validate_own_trigger().

Cc: stable@vger.kernel.org
Fixes: 517985ebc531 ("iio: trigger: Add simple trigger_validation helper")
Signed-off-by: João Paulo Gonçalves <joao.goncalves@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/20240614143658.3531097-1-jpaulo.silvagoncalves@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -322,7 +322,7 @@ int iio_trigger_attach_poll_func(struct
 	 * this is the case if the IIO device and the trigger device share the
 	 * same parent device.
 	 */
-	if (iio_validate_own_trigger(pf->indio_dev, trig))
+	if (!iio_validate_own_trigger(pf->indio_dev, trig))
 		trig->attached_own_device = true;
 
 	return ret;


