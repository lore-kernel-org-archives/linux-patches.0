Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31438251780;
	Tue, 29 Apr 2025 16:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945544; cv=none; b=GplSSjU1M7tV2K/9Hs36RPbBTLIatPUowDtfeEfzfadzXd6IOaT/qWThzMYjsYphDDDSsHCioe3oFAKuzQbTdvvegVgnPcdXd0SiZx6+IIVpf2jBkA9Fnfm6SFeyq9OAzhtlfEQr6dYUM7k1MlDA7WhWuoR/chzevZ+Lrivs8g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945544; c=relaxed/simple;
	bh=XJEphChaa3/CmZ8es3WT1uV+YGNXdcb/BMYySGmI3qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6Zc0fsMfOk8jfN9HRET/edqAzfK0TUYOHbt+IfkRUllCdisqWzTRoKXLHVZg7KYyDdDws64VLwDxXZA1RW4bwS3IfU031jKxtOOqNcaHxyZnifPQ+UbAe7g/Sf10kTsrV2txSau/jLWsNWBVBsV8Ul9rwvQqT05y4AK71uNyHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2qBEyxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2qBEyxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3522C4CEE9;
	Tue, 29 Apr 2025 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945544;
	bh=XJEphChaa3/CmZ8es3WT1uV+YGNXdcb/BMYySGmI3qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2qBEyxnAY8CL+cYg3KFg6S6OXbdUrg0Szsg/IGszsO9PYSsE5r2ZWEyNWZVyNZHs
	 eIqq51Tyu+ts6E0hiI8QCtZGo90nM8gUhFLamOJgXGtrGrF2iUSlexwh0+BjkpPWg2
	 pxdO6gPhlPk8bFRerv0ykaONmK1xpWBf6uV9uKcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 5.4 147/179] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:41:28 +0200
Message-ID: <20250429161055.335930742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7c7f1bfdb2249f854a736d9b79778c7e5a29a150 upstream.

In chameleon_parse_gdd(), if mcb_device_register() fails, 'mdev'
would be released in mcb_device_register() via put_device().
Thus, goto 'err' label and free 'mdev' again causes a double free.
Just return if mcb_device_register() fails.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/6201d09e2975ae5789879f79a6de4c38de9edd4a.1741596225.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -101,7 +101,7 @@ static int chameleon_parse_gdd(struct mc
 
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	return 0;
 


