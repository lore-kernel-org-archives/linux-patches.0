Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03EB32C327;
	Wed,  3 Dec 2025 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776996; cv=none; b=eM7Ym1NnRvkUCmp0q+Ek5aeynQIjDoW5C7LJU1of38ypJbo384x0DN3c2uA7ob650bfpqsn+7RbuNii5PByfyhKCqKAZDYITtAc0BCF6HDlKJ2tV+P71umMaowFds8nZ5B/gJ34GW1rqAWClfT9Chl8ukMauPbYyam8lUgxKL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776996; c=relaxed/simple;
	bh=LvL7+i1TfD+WpM/3BkeadnxSCAuBBjVYasfcF6gOR+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLjGWx2UEoZd5wpuWMHd+iAd6hKgWY/WPsRnC6Ct0j+BaY9pmoPU5HAZEaVUBnXJyE3QdEI0jSuECFDtdcS0gDOCON1GqcQfXQ/jm6HvdQgztqiw3QnK6q9SUd79vtUICDdAbM+SrWSMcsFd1AgAf3WFf3LR5Jn5tWOM8FGa1n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5TnSzV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5TnSzV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D69FC4CEF5;
	Wed,  3 Dec 2025 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776996;
	bh=LvL7+i1TfD+WpM/3BkeadnxSCAuBBjVYasfcF6gOR+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5TnSzV6kGUMQm3Y5J00wofheNNo5Nswe43IpSXnlYPNnjnEUqE66Z0n0nCKvaknN
	 EZhM/pDUiJa3qPazu9qOjKntEHKPG5YXegVWMUjfYD4/mht/g1YNRyMfRrc3OImGbh
	 Tmf2RQiVnxc98uN4fwDnRSxMCitJbJ6pxsaF3NKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Malaya Kumar Rout <mrout@redhat.com>
Subject: [PATCH 6.17 051/146] timekeeping: Fix error code in tk_aux_sysfs_init()
Date: Wed,  3 Dec 2025 16:27:09 +0100
Message-ID: <20251203152348.339798323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit c7418164b463056bf4327b6a2abe638b78250f13 upstream.

If kobject_create_and_add() fails on the first iteration, then the error
code is set to -ENOMEM which is correct. But if it fails in subsequent
iterations then "ret" is zero, which means success, but it should be
-ENOMEM.

Set the error code to -ENOMEM correctly.

Fixes: 7b5ab04f035f ("timekeeping: Fix resource leak in tk_aux_sysfs_init() error paths")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Malaya Kumar Rout <mrout@redhat.com>
Link: https://patch.msgid.link/aSW1R8q5zoY_DgQE@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 08e0943b54da..4790da895203 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -3073,8 +3073,10 @@ static int __init tk_aux_sysfs_init(void)
 		char id[2] = { [0] = '0' + i, };
 		struct kobject *clk = kobject_create_and_add(id, auxo);
 
-		if (!clk)
+		if (!clk) {
+			ret = -ENOMEM;
 			goto err_clean;
+		}
 
 		ret = sysfs_create_group(clk, &aux_clock_enable_attr_group);
 		if (ret)
-- 
2.52.0



