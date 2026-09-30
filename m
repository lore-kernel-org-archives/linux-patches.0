Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCA3769FB;
	Wed, 30 Sep 2026 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788701; cv=none; b=AnKdJTfKEzA+uiP3VLkB/iNX+AK1HULPHGvuJhafWLRvzmCBFWOIM+b3D6gd985V8tLI70mArhNG/Mk9HvYFaZnavUAdWWvYeZHUIVQqTJJaPH7+QIJp51lVM3vy8jJ9L8s3cvGQCTFAnK6mUHr0rlpc+7tOvy2nzYyXCzGxBxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788701; c=relaxed/simple;
	bh=cNJP8gy2YNhDeXUnY7ox+B0nUWssLZXpHSyA0i0oB/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYV3VFg0Yk9Y+9dgvKryOIrafSvRZDTkhVklrFyULbyjJPR5fkpdWMh+r09lI+4ZU7wEHbXeBRjTphhQhkmILXkxnPahobVCOW24SIerTOUKyrAW2VRc56dh0WhQDKfYyUNSEFOJ4HmOHV3b0zUTW+xz2wk4gKWNN9+6HeyF5sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JGcGBUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JGcGBUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C151F000FF;
	Wed, 30 Sep 2026 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788699;
	bh=tYrxqTjDzdOEf1pKR/8J4x2GcAdxI9xjXMWKYaAf3hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JGcGBUnT0782vFnKu3SCjCUIm4256qccfSlQOOC1N4d+77ppl8bDfbBPQ3wGqS7y
	 yhqu3lnkEzRxC09J2ObJTTsQ0TXHKaDmZXp3shlTRnd4+lIZGp3VRABj/y7COZeiKt
	 mniZq/HQNPmSoIZJn5uWsYcUZqYosIMrj7URQ6v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 218/877] power: sequencing: dont call .post_enable() if pwrseq_unit_enable() failed
Date: Wed, 30 Sep 2026 17:18:49 +0200
Message-ID: <20260930152419.433123666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 5f90f85eae4e9d2e9628b2019870994ba830b533 upstream.

If the call to pwrseq_unit_enable() failed in pwrseq_enable(), bail out
instead of calling target->post_enable() which assumes the target was
successfully enabled.

Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260909-pwrseq-kunit-v2-1-ef496afc89d2@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -913,6 +913,8 @@ int pwrseq_power_on(struct pwrseq_desc *
 		if (!ret)
 			desc->powered_on = true;
 	}
+	if (ret)
+		return ret;
 
 	if (target->post_enable) {
 		ret = target->post_enable(pwrseq);


