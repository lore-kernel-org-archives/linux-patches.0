Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3A326D44;
	Tue, 21 Jul 2026 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655566; cv=none; b=a1SxWWb3RBdCQTFbbSHI9G2ZahDxLOh9d2BNfuoH3ksEyVNMlsCLKZr2YQ81S4rR9hU50v8tqjSXJU2OR6XHZHXGtqrRUDj80grtBghJHchkVk7jtxhCh7hut6GzZiFYMm44ffxGvtuW8QGulkp/lTG9qWicFb91AgWMoJKyTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655566; c=relaxed/simple;
	bh=J4+d8CS8ppYTMgAcSDRM08LzL3wLfIN4jdgP6Y+avzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp/UsMJfhhtgfcNtPNWdCUEXleRU1VOjhS2kpC35HhgKVsDA4APJOml5Inuv351X8o7aIMM+UdUe/Z9xmuPF41zq+2YwVP93hwrUeXC1VVxolvpAWRtCDYbST5XSiC6256YDl+jujFAybak4ZYCkN6CRxEKTKhsxc65p834PxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eer2dD9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eer2dD9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4DA1F000E9;
	Tue, 21 Jul 2026 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655565;
	bh=hvfU42uS8DM+D2TQUwHVyeM5D3lrlGxOfTBsaNMaujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eer2dD9mHd9zGMtAO89AiNrLKbV8jvVJW5Oa5njihYFX0GF2Rtl0/XQZYDj/fijCa
	 fx2wLdCCAeWL2ObExFZsIesiJL2ObV5s1XvVDdCb/3Nax1KRAJeyvT/I0NSDtsaQet
	 XlmUpJFiqeh2n817QAcqmpUn8Isk1UVUl4RNxEuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0058/1611] clocksource/drivers/sun5i: Handle error returns from devm_reset_control_get_optional_exclusive()
Date: Tue, 21 Jul 2026 17:02:54 +0200
Message-ID: <20260721152516.134241400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit fed9f727cc3f91dde8278961269419083502b40e ]

The devm_reset_control_get_optional_exclusive() function may return an
ERR_PTR in case of genuine reset control acquisition errors, not just
NULL which indicates the legitimate absence of an optional reset.

Add an IS_ERR() check after the call in sun5i_timer_probe(). On error,
return the error code to ensure proper failure handling rather than
proceeding with invalid pointers.

Fixes: 7e5bac610d2f ("clocksource/drivers/sun5i: Convert to platform device driver")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260205084037.3661261-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sun5i.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index f827d3f98f60e6..d7e012992170b7 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -286,6 +286,9 @@ static int sun5i_timer_probe(struct platform_device *pdev)
 	}
 
 	rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(rstc))
+		return dev_err_probe(dev, PTR_ERR(rstc),
+				     "failed to get reset\n");
 	if (rstc)
 		reset_control_deassert(rstc);
 
-- 
2.53.0



