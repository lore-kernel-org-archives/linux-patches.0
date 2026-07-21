Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420843901B;
	Tue, 21 Jul 2026 21:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669881; cv=none; b=GKbfdAKUqw9hQ0gxQFUq4VLXY2MIlir9pCVEMm/A3FWb171P3cv7zDsNVAn0qzr5Pb0SSRInOZuLqpv/3HZNU2xlB7toH5I97TWlBbBlAjQRt4qDJI67ihKXT9QCiYJORFlH9uXkFcY7sfze9uqkFg69QTiqLlJvPqF6LUqQPRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669881; c=relaxed/simple;
	bh=2aeh1BcZez6aOvjScmg1F6reIAIXprPGMdx9VJMBmTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcV2y3+Hc+TVUHbZZ43SGLdA6+94P4st8IBAzHr2Rv/Tbq6e1lFmhv38IeR6IvxhBKjLqypdQBOke3fjxc5EFBqkSHv7fPHgcRnCU54Q6NNVd8sgUjCiaf05caLLHI8OIXMwd51on//iLO9XdJXshSxYIh6X0XeCIfL24B0UnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIkEX19z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIkEX19z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E5E1F00A3A;
	Tue, 21 Jul 2026 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669875;
	bh=7QBv9wU5QOQMyA+6c6dcHjsskCJ4DA69Hxv3OVeCbeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIkEX19zmLKfZRUl/30YtKQYceFlKE6cMERn1MntYL3t3fTkLtjiDHzzcUSSUDrYC
	 eNZVwg7egTFGvs2CKbj/7OS/1em194CCH+buOQBQwG/GyDA0O5RpUM3n9NJkJiS2Ut
	 rAHK4OdEzErLombqMXcNNuqPxVJPaLaSiSqodVhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0720/1067] net: atm: reject out-of-range traffic classes in QoS validation
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152440.694261294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit cdf19f380e46192e7084be559638aab1f6ed86a2 upstream.

Reject ATM traffic classes above ATM_ANYCLASS in check_tp().
SO_ATMQOS stores the supplied QoS after check_qos() succeeds, so
accepting larger values leaves invalid traffic_class values in
vcc->qos.

That bad state later reaches pvc_info(), which indexes class_name[]
with vcc->qos.{rx,tp}.traffic_class. Values above ATM_ANYCLASS cause
an out-of-bounds read when /proc/net/atm/pvc is read.

Tighten the existing QoS validation so invalid traffic_class values
are rejected at the point where user supplied QoS is accepted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/58f02c6f73d9818fd5d2022e1116759fdde6116b.1780965530.git.zcliangcn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/atm/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -720,6 +720,8 @@ static int atm_change_qos(struct atm_vcc
 static int check_tp(const struct atm_trafprm *tp)
 {
 	/* @@@ Should be merged with adjust_tp */
+	if (tp->traffic_class > ATM_ANYCLASS)
+		return -EINVAL;
 	if (!tp->traffic_class || tp->traffic_class == ATM_ANYCLASS)
 		return 0;
 	if (tp->traffic_class != ATM_UBR && !tp->min_pcr && !tp->pcr &&


