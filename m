Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1959646D2DD;
	Tue, 21 Jul 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657271; cv=none; b=CURIC0MPKsXLPo+tYPjP/UL34jLbDMvL09+RSF9wR0YZ76hgzrSDM0B5ocELXPXuBYeFkcfnRz9j57ZaZAiKjx9+wo/QxP+FYpYjMYXrLz+Tfxztlgd0eqJgq5vsQxAkP19JjXqPCrAAY2fLJyvs/tdxflX98ofT3Dss2mEqMic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657271; c=relaxed/simple;
	bh=wU8HUHeKVUYejpLR1rg9QSYe+iMZT8j6eB+hhd5qrIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2/WOXCE3oI16nsAmpDb3hryep5HkDHXDT3cyx5LqP6VUtTTVPbYAvI2NLTkCfQEt/1YivqHuHmCG14uycjcdG2XfGJdc+lygWBSzsxtrlu7J8vRO7ok2nza+wMoPjLsRAbwAUp3rZp69pP3fCA6vjCQeK82vhMAwSEfwm3U4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dlto/W3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dlto/W3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2F51F000E9;
	Tue, 21 Jul 2026 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657269;
	bh=aCtit741rUS3CVw9IuS1jAaOccfXEwlAlfJiuONcnU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dlto/W3CAdYUrIE4MdlxhsV6jNbhXIqdu6adps7YKg62pLKXHg5RI+xvaWdGLCzCt
	 dQt+QizDXXruaER7K/RYHfrMEYXAQuoJvPF8L+lXEmU0HWDy8PSIMJO8FWZCZ8y1TE
	 +DDA9XoZ8HTuO6Fi1kp8AUshpnN8iHIR11TNvQ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0657/1611] mshv: add bounds check on vp_index in mshv_intercept_isr()
Date: Tue, 21 Jul 2026 17:12:53 +0200
Message-ID: <20260721152530.163524667@linuxfoundation.org>
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
index e6b6381b7c369d..1a822beae2390a 100644
--- a/drivers/hv/mshv_synic.c
+++ b/drivers/hv/mshv_synic.c
@@ -375,6 +375,11 @@ mshv_intercept_isr(struct hv_message *msg)
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



