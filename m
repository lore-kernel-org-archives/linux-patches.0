Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9626335BA;
	Thu, 13 Feb 2025 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460035; cv=none; b=GWP4E84D2OOI96S3sM2O12U/CowJxnf6ktKkhTvE3QRTY5XBjo3wUwkT5Huq7UmoBukKdaMaC6UkXEtEtudCZVcm5UmwubDT2KuX7NphiG1SoiRulThQX+tIwAyfgX1z2cWxE9ES1OqwOU83aXKqpXFnivhSQgo6n5affNufy80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460035; c=relaxed/simple;
	bh=SgRgxJRQMUUKobA02sxADMGNVfjdR+JXFmr7m/HC0r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugJlAzImNxYdaQUqGWCSX7vfUdUdf3J+C4Ly7zZK5Uqv2dlv0p7hwUXXbDuOdyE/IBRz7XmNxNHzs13EfjcfMP6gAjJYT7vA3wL2rz/cxYymiSx1AaRHJsPuhsIbvQ1YZqmK+y9AS2AC5QVPwAT7SIL+j/MO3gLHJCIgLjmkMBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAYdvjDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAYdvjDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23196C4CED1;
	Thu, 13 Feb 2025 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460035;
	bh=SgRgxJRQMUUKobA02sxADMGNVfjdR+JXFmr7m/HC0r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAYdvjDCO0VDByCcVKyGvwz4CH8XK0xBg4wGN3xuKrC2o/Ksub9FtC3Fx0YdxbMY3
	 fARhcqAgbSzamNBcdIT7SbqYDjVp9PSR7xN/PTRsBKZdHif6i6BYZExlEBbx73PHy2
	 GOx5ZrOQh6glndZMrjFWNYkIZXcF9WOYAE/1FJMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.13 438/443] md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add()
Date: Thu, 13 Feb 2025 15:30:03 +0100
Message-ID: <20250213142457.517738693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 62c552070a980363d55a6082b432ebd1cade7a6e upstream.

The linear_conf() returns error pointers, it doesn't return NULL.  Update
the error checking to match.

Fixes: 127186cfb184 ("md: reintroduce md-linear")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/add654be-759f-4b2d-93ba-a3726dae380c@stanley.mountain
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-linear.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -204,8 +204,8 @@ static int linear_add(struct mddev *mdde
 	rdev->saved_raid_disk = -1;
 
 	newconf = linear_conf(mddev, mddev->raid_disks + 1);
-	if (!newconf)
-		return -ENOMEM;
+	if (IS_ERR(newconf))
+		return PTR_ERR(newconf);
 
 	/* newconf->raid_disks already keeps a copy of * the increased
 	 * value of mddev->raid_disks, WARN_ONCE() is just used to make


