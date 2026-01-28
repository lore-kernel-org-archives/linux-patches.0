Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4829302741;
	Wed, 28 Jan 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615588; cv=none; b=eZKZwOeSXiDe2YdLoz0jZZFWn7LWq+j+W2w2L9ENsiaCOnAx9IKlWyWYXtONcqU+fW4cZ3kbEs8Wk+7RFnrEtse5tHHYQEJitzr4Dee9KvpgYeBW/S1AFO58+/fsDtG+pOQr38ePiUF5E/yBis8CxqvsEl2lRT4wCWCEU14Tztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615588; c=relaxed/simple;
	bh=TFlwmTgvevkR+A2u4tdtt/orywV7zWnRJtB6DG5uj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6/zgKrWSERCZyQpuIqFq4/t6T7WYdtmvpcI5XUs5GBMnEkk5yd1SPbokwj/onz0KhGkZqBZGI0XsSc4k7oSE3Saxg9xIpCi5DhkCnHpHAwLQYJ4LEdZXufqRJ8DTBNhSDKQZkJJhlLnwvnriGWLzZYvZeE2q7urP/rarAf105k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o5mm95y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o5mm95y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0C8C116C6;
	Wed, 28 Jan 2026 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615587;
	bh=TFlwmTgvevkR+A2u4tdtt/orywV7zWnRJtB6DG5uj70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o5mm95yTomB4zrY84HaAwDUnWfBOTK1oyyV7swdqviLbq9awshnCUcvP4w3YJkbM
	 0SYNqXL80w11ylzI05dDlY+dAA+WCDcJIecKiAhFloxwu1kyNG2gqCTmBNBXz5tTfx
	 ycW/31UUnrLPmBZ6K7oKV9R5iGBF3Cge33pzq/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.18 053/227] w1: fix redundant counter decrement in w1_attach_slave_device()
Date: Wed, 28 Jan 2026 16:21:38 +0100
Message-ID: <20260128145346.250660600@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit cc8f92e41eb76f450f05234fef2054afc3633100 upstream.

In w1_attach_slave_device(), if __w1_attach_slave_device() fails,
put_device() -> w1_slave_release() is called to do the cleanup job.
In w1_slave_release(), sl->family->refcnt and sl->master->slave_count
have already been decremented. There is no need to decrement twice
in w1_attach_slave_device().

Fixes: 2c927c0c73fd ("w1: Fix slave count on 1-Wire bus (resend)")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251218111414.564403-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -758,8 +758,6 @@ int w1_attach_slave_device(struct w1_mas
 	if (err < 0) {
 		dev_err(&dev->dev, "%s: Attaching %s failed.\n", __func__,
 			 sl->name);
-		dev->slave_count--;
-		w1_family_put(sl->family);
 		atomic_dec(&sl->master->refcnt);
 		kfree(sl);
 		return err;


