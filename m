Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC346F48E;
	Tue, 21 Jul 2026 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660384; cv=none; b=LxENw2/Qf8QsYL96uqwfH7y4+bM9tuq8tGKWvQOYM5MJUxSCZ68bJqnVoGzi8raURWJ0x0uDT2+k3bY8wMFqu5ytT13VMXJ5y/MFDF9mKwjLuo/X9+XvlYuSwUyRCCKg99+EfwhxLBmxsSiejWRpr3HBzd40ZhZ7HF1eyzkjKDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660384; c=relaxed/simple;
	bh=OZYwv4OCtvueXM/TBJEQYVVdLXJuxDrTxtpFlrvooIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ignfRAWuBvtVJ+RW9T6//uyqomroUsN/dShm9Ump87eMv9MlcBIXfre1xM1xXPizeCqQGK9GuqyzEgxN/fED5wMwQ/8CVe6l0/DNXOUzdUaVgr6jzT9hYI49EtdzQEcs4CouAI9h6WXDk9omlq4p4aIUqH7nzFkFiUoylWSDZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuFQaA5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuFQaA5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E1A1F00A3A;
	Tue, 21 Jul 2026 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660382;
	bh=cv3/3+hz9gNw7hQHvc8D3lQMjkx7BE9tTMKE2Rtp65c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuFQaA5R+SpIWjoW3Q12qN8uQ2CfRSPWd+dLDMhJuifb0LgCPw2Qoox0TbSSGhVm6
	 P3sloPzOTQkYYFSnKRntYaOrxQxZQ0LMmiUNW76ZDbLqAvskjtyiOPw7cVMag6UTJo
	 52+NSX8MnXZ5bFMsNbyWVOziFIzkvmLe9cf5jg1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0957/2077] mshv: add bounds check on vp_index in mshv_intercept_isr()
Date: Tue, 21 Jul 2026 17:10:30 +0200
Message-ID: <20260721152615.392636691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit a4ffc59238be84dd1c26bf1c001543e832674fc6 ]

mshv_intercept_isr() extracts vp_index from the hypervisor message
payload and uses it directly to index into pt_vp_array without
validation. handle_bitset_message() and handle_pair_message() already
validate vp_index against MSHV_MAX_VPS before array access.

Add the same MSHV_MAX_VPS bounds check for consistency with the other
message handlers.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_synic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hv/mshv_synic.c b/drivers/hv/mshv_synic.c
index 88170ce6b83f07..7c168e5a740dd2 100644
--- a/drivers/hv/mshv_synic.c
+++ b/drivers/hv/mshv_synic.c
@@ -384,6 +384,11 @@ mshv_intercept_isr(struct hv_message *msg)
 	 */
 	vp_index =
 	       ((struct hv_opaque_intercept_message *)msg->u.payload)->vp_index;
+	/* This shouldn't happen, but just in case. */
+	if (unlikely(vp_index >= MSHV_MAX_VPS)) {
+		pr_debug("VP index %u out of bounds\n", vp_index);
+		goto unlock_out;
+	}
 	vp = partition->pt_vp_array[vp_index];
 	if (unlikely(!vp)) {
 		pr_debug("failed to find VP %u\n", vp_index);
-- 
2.53.0



