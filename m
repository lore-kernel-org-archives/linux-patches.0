Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B23D9535;
	Thu, 16 Jul 2026 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210861; cv=none; b=rsF8+mWGGKmWA+VfeQU14omAZtq1BJ/LoEU5RoBxoEWaM6iHjQsRfLFO7NDoMAh8EhJxJKAD+Wdps3+KCBiOk11ApK0D7ihEOmn+LlwPII2/4ryuY4web2KnJDu0p4t8Ka55N0FwJ/hzVjRPfH3CIqapuceQKqNHiL1l2ZVPrGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210861; c=relaxed/simple;
	bh=38lPXnH0N5iLOgKRBTgtIOU9smctX0VBGkERK/eyZiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm99CR22miPoSjFFJDS84C8XzaqPlqNewG/EBAXWLk/KvJqqoW4B3n9zXY8Gw6VEAkOJ3+guEtX+20d0q3biqUSMCaEkpRQaDh0gsvyWiD2RuUJ3ribKeJIefgH9P/S8411Gu11NOgF5Dh6R4Oc5Sqs7GadQPTWU7jflmrlq1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHwA2FsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHwA2FsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A90A1F000E9;
	Thu, 16 Jul 2026 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210860;
	bh=WoDakid/0hunBQWtd7/VVFzZ2uPcftvuJzA1tpZQaX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHwA2FsBfAO9a5uA9mYFu9qyfcEE85kUgkk3tsQE2mlrEYGHksrhVAlFGeKOXvfYE
	 IxIe9bNiURem8mdwucyVxX+XutOIpuzHPuOlX5VgCy9BP4EbysKy4Gb65S5YUgLeh8
	 ZCvvaczMsUT1TgQbxlumgPRAxjq/crnNVtXRqSIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 208/480] Bluetooth: L2CAP: validate option length before reading conf opt value
Date: Thu, 16 Jul 2026 15:29:15 +0200
Message-ID: <20260716133049.228020331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 687617555cedfb74c9e3cb85d759b908dcb17856 upstream.

l2cap_get_conf_opt() derives the option length from the
attacker-controlled opt->len field and immediately dereferences
opt->val (as u8, get_unaligned_le16() or get_unaligned_le32(), or a
raw pointer for the default case) before any caller has confirmed
that opt->len bytes are present in the buffer. The callers
(l2cap_parse_conf_req(), l2cap_parse_conf_rsp() and
l2cap_conf_rfc_get()) only detect a malformed option afterwards, once
the running length has gone negative, by which point the
out-of-bounds read has already executed.

An existing post-hoc length check keeps the garbage value from being
consumed, so this is not a data leak in the current control flow. It
is still a validate-after-use ordering bug: up to 4 bytes are read
past the end of the buffer before it is known to contain them, and it
is fragile to future changes in the callers.

Fix it at the source. Pass the end of the buffer into
l2cap_get_conf_opt() and refuse to touch opt->val unless the full
option (header + value) fits. Each caller computes an end pointer
once before the loop and checks the return value directly instead of
inferring the error from a negative length.

Fixes: 7c9cbd0b5e38 ("Bluetooth: Verify that l2cap_get_conf_opt provides large enough buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3048,13 +3048,24 @@ fail:
 	return NULL;
 }
 
-static inline int l2cap_get_conf_opt(void **ptr, int *type, int *olen,
-				     unsigned long *val)
+static inline int l2cap_get_conf_opt(void **ptr, void *end, int *type,
+				     int *olen, unsigned long *val)
 {
 	struct l2cap_conf_opt *opt = *ptr;
 	int len;
 
+	/* opt->len is attacker-controlled. Validate that the full option
+	 * (header + value) actually fits in the buffer before touching
+	 * opt->val, otherwise the switch below reads past the end of the
+	 * caller's buffer.
+	 */
+	if (end - *ptr < L2CAP_CONF_OPT_SIZE)
+		return -EINVAL;
+
 	len = L2CAP_CONF_OPT_SIZE + opt->len;
+	if (end - *ptr < len)
+		return -EINVAL;
+
 	*ptr += len;
 
 	*type = opt->type;
@@ -3426,6 +3437,7 @@ static int l2cap_parse_conf_req(struct l
 	void *ptr = rsp->data;
 	void *endptr = data + data_size;
 	void *req = chan->conf_req;
+	void *req_end = req + chan->conf_len;
 	int len = chan->conf_len;
 	int type, hint, olen;
 	unsigned long val;
@@ -3439,9 +3451,11 @@ static int l2cap_parse_conf_req(struct l
 	BT_DBG("chan %p", chan);
 
 	while (len >= L2CAP_CONF_OPT_SIZE) {
-		len -= l2cap_get_conf_opt(&req, &type, &olen, &val);
-		if (len < 0)
+		int ret = l2cap_get_conf_opt(&req, req_end, &type, &olen, &val);
+
+		if (ret < 0)
 			break;
+		len -= ret;
 
 		hint  = type & L2CAP_CONF_HINT;
 		type &= L2CAP_CONF_MASK;
@@ -3669,6 +3683,7 @@ static int l2cap_parse_conf_rsp(struct l
 	struct l2cap_conf_req *req = data;
 	void *ptr = req->data;
 	void *endptr = data + size;
+	void *rsp_end = rsp + len;
 	int type, olen;
 	unsigned long val;
 	struct l2cap_conf_rfc rfc = { .mode = L2CAP_MODE_BASIC };
@@ -3677,9 +3692,11 @@ static int l2cap_parse_conf_rsp(struct l
 	BT_DBG("chan %p, rsp %p, len %d, req %p", chan, rsp, len, data);
 
 	while (len >= L2CAP_CONF_OPT_SIZE) {
-		len -= l2cap_get_conf_opt(&rsp, &type, &olen, &val);
-		if (len < 0)
+		int ret = l2cap_get_conf_opt(&rsp, rsp_end, &type, &olen, &val);
+
+		if (ret < 0)
 			break;
+		len -= ret;
 
 		switch (type) {
 		case L2CAP_CONF_MTU:
@@ -3930,6 +3947,7 @@ static void l2cap_conf_rfc_get(struct l2
 {
 	int type, olen;
 	unsigned long val;
+	void *rsp_end = rsp + len;
 	/* Use sane default values in case a misbehaving remote device
 	 * did not send an RFC or extended window size option.
 	 */
@@ -3948,9 +3966,11 @@ static void l2cap_conf_rfc_get(struct l2
 		return;
 
 	while (len >= L2CAP_CONF_OPT_SIZE) {
-		len -= l2cap_get_conf_opt(&rsp, &type, &olen, &val);
-		if (len < 0)
+		int ret = l2cap_get_conf_opt(&rsp, rsp_end, &type, &olen, &val);
+
+		if (ret < 0)
 			break;
+		len -= ret;
 
 		switch (type) {
 		case L2CAP_CONF_RFC:


