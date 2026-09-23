Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3253A8A3;
	Wed, 23 Sep 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174962; cv=none; b=q18mEEYJCgdOYo7teRNgZ5sk06HUVHaIIjaXtH9iZdEhrgPH14cxb97/RRypTIQUG0rf9ysZ9Y5/Z1lK8h9EVf2Gzw8ZtNi5DkpsQUoL7X82ams1Jo7jAitVb1x9hjYlbwxCMHaT0EFaiNk7YmmdE3s4B7V4/No1f/nWrlei4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174962; c=relaxed/simple;
	bh=aluLNMW/yg5UUAdNZc1xhpSU72rNmFF6jIDwZjB/LiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI+BW41gzrsDxT5TTWZrnykI1cS9Hx6oqGd6eMUhXGipjc772LHwz701ktGLDQ3T5xIR8Cxc3W71GnL2ErjE4uWyA+OIgVxB3dYI4So/8M+kdhAEVml9XRtj1Kz6cxMPi94A0JzuHphwnNVhko2b9qM3abeeMdkfylOervN2Pm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSoN5nGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSoN5nGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CE81F000FF;
	Wed, 23 Sep 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174960;
	bh=Ye7InDsGvWyVj03BlMSJ8LpyR7tkiy6eLMg4HCgET50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSoN5nGw3AdlibDPj0zc53teZstwjjQpXjDlwsb8ZgSxpil3zThalV/guxJqKVtQl
	 VoT41K4TA97ml6lxlBnylhvq8iDBjEpPvnpZOF+y+0DIZ2Ha28OsP1lBVFW4F56Jot
	 Y0i5UvvjAMJ96ekm/l5pYZ+Ye6UMs6VSg8Ocm7Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 277/398] power: sequencing: dont call .post_enable() if pwrseq_unit_enable() failed
Date: Wed, 23 Sep 2026 16:05:51 +0200
Message-ID: <20260923140650.596740223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


