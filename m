Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279F376A1B;
	Wed, 23 Sep 2026 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173871; cv=none; b=cWNajzzJYHg60IR+33XGUecOHSR62iCcn9uQwWCHPrasgAeSNMBVPiDs9Gtwr+mfYBcN+UYwCJC3vNxgWT1zt2XEjJjK6kNEUPmRB7KhP1XQC9+6wT1/ceqWtv2H7h+22+uTv0MPfA+Sn2lkyXWIbspzbi4cdsARU5bDnOg4iRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173871; c=relaxed/simple;
	bh=n1HGjDqDDElHN9LelkSThU1NgRV+f2ubMX2qOYwvWiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os1olnpRdVSJPPC8LD4qD6HA2ncTT9svbVLgX/WQfqdmf66pRYsOX5raZ7Zc9ITpzA/4lYJPp3pqrDWoZuGMHqABC4j1GPnbpyh1xaOGh/kcfYa4iS+hZwie/2YqZ+w1cp3+bQdTXHxIAExMuvThZiI+Ems5+sR1k/vGWRB+arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alz5dfQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alz5dfQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD861F000FF;
	Wed, 23 Sep 2026 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173870;
	bh=jgkFJZBRDebipH7itB9PWdLw//AtgwBRtXj5B4FVHuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alz5dfQlwIGfqW3DtITdYcj0B3zcyQAIRlUtFGOJBV4usSbkxFb1yfRx8wpElUlh9
	 PxAV13R0yZiqdNflsaFnoc2/9ciAuF6ZYV05fuqXkvWZcfJ2b+vKm3caUw31dO/f6i
	 ep+GFXIfWYfWqH4rGXaTnRpVxBF/02OcLqRnj85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 336/438] power: sequencing: dont call .post_enable() if pwrseq_unit_enable() failed
Date: Wed, 23 Sep 2026 16:05:57 +0200
Message-ID: <20260923140653.524025944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -912,6 +912,8 @@ int pwrseq_power_on(struct pwrseq_desc *
 		if (!ret)
 			desc->powered_on = true;
 	}
+	if (ret)
+		return ret;
 
 	if (target->post_enable) {
 		ret = target->post_enable(pwrseq);


