Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C3F471251;
	Tue, 21 Jul 2026 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667005; cv=none; b=nCoFjmhTfe8BCq211aF4mr6jh8RAXBT3WAKb7h3UcUVwiU6kUJNf4M1MZifL+958Ke2sbapiTwwKccKK0M6WfFG6NSzLwQkc9VdhbZ+tWeBF4dU8dfF3AXChysIIol2NNFxi10YtFHEao5mHY4cJWYhXfneF9zIYCRGc13GNdz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667005; c=relaxed/simple;
	bh=FSRIuoiH7ZJp6SAEfkSSR76AU2tp+3skZ00QJcM3aos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkm2pAk3s36x9jsaAyp/MmBAVjW3j01aVL6BXjWowiO7YnN1FmX8X6PZHlAMf01I5UCdlIVnTzjLx4bxcZ8/tGC2zlIiOr7nMLKbijMC+naEHXznTR4NmMNIJf8SZ9Dw/HAXR19+IZXZFyo04O/vxEP3Hz0vI9UIHE2Nuhvj0o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iArcnYMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iArcnYMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A6A1F000E9;
	Tue, 21 Jul 2026 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667004;
	bh=zmQONVqMw0YC91lcoEHd2dVPSL+3N4ySOnKghAmphR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iArcnYMJXrTHC/kbidFyHyNCgKGdDhHw65y5kuhmQjOO2UDVqoNQo9imVoZ6Avdbg
	 7QwwAjTHv8d39q3ecfPEAmS8BlljVi9sdByzTNJIrzPXOujf09+Ha64FWfKzCrvVof
	 n3ILmA+n6jWm7b35xqCLcz/Izu+E8ymPWHvWSOAA=
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
Subject: [PATCH 6.6 0897/1266] net: atm: reject out-of-range traffic classes in QoS validation
Date: Tue, 21 Jul 2026 17:22:14 +0200
Message-ID: <20260721152501.919730016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


