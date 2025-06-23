Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7F23E330;
	Mon, 23 Jun 2025 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684433; cv=none; b=cBi0NpBN6y5dSu6nSt/3tKtWCxtfeYj6jNxw2XZevRMY3PAqDH8zL1i1RPegUXDh6vhjTx5pYL/PD5Q33HcVEpI8EaL52uHtpVRXsPdZHZF0rXFDjTZ8HI/5xRhkGiDReYrEpxeHpiUk0BnhquMSQPP5wMwPQcv88w/cRMQCrb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684433; c=relaxed/simple;
	bh=mSxv1zMVuJoG6UKuEwrD9a/k7kigsTKhpjdCvcSLRzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHvpFPdbOt0O5dmV1yWyBIkpaWUFny0lPYkhM6z1CFgRPIbe1EuTcufm1N19LVpx39bHlvaCr9GsA4dbs0Kcg1rK7s6bo7raiKMQjF3Jvn2T6Ipidg/+nAmqYh5lf4iad7np3kzKEmX9SOGvJJVTSIK0Nnt2v5jC2JlYrtDNNLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+JQs+Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+JQs+Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E5DC4CEEA;
	Mon, 23 Jun 2025 13:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684432;
	bh=mSxv1zMVuJoG6UKuEwrD9a/k7kigsTKhpjdCvcSLRzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+JQs+Zdy4CPvpgHgto0C3vdsNZdAFIf07FRK13op23KB21tsyMqv4XqqBgVRYgOC
	 1SZ4e25hFIFv5i4iqqw/B8NUH/Yi/q2r7DkP2UwHhWHJv9JJ9//X+amkacWhB6UswV
	 56BEuTbDbmmjLY65V8ZKdkoBmPv483FcNuL/+ch8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 065/592] media: ccs-pll: Check for too high VT PLL multiplier in dual PLL case
Date: Mon, 23 Jun 2025 15:00:23 +0200
Message-ID: <20250623130701.804292297@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 6868b955acd6e5d7405a2b730c2ffb692ad50d2c upstream.

The check for VT PLL upper limit in dual PLL case was missing. Add it now.

Fixes: 6c7469e46b60 ("media: ccs-pll: Add trivial dual PLL support")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs-pll.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -312,6 +312,11 @@ __ccs_pll_calculate_vt_tree(struct devic
 	dev_dbg(dev, "more_mul2: %u\n", more_mul);
 
 	pll_fr->pll_multiplier = mul * more_mul;
+	if (pll_fr->pll_multiplier > lim_fr->max_pll_multiplier) {
+		dev_dbg(dev, "pll multiplier %u too high\n",
+			pll_fr->pll_multiplier);
+		return -EINVAL;
+	}
 
 	if (pll_fr->pll_multiplier * pll_fr->pll_ip_clk_freq_hz >
 	    lim_fr->max_pll_op_clk_freq_hz)


