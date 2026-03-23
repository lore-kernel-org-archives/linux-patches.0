Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C33A9D9D;
	Mon, 23 Mar 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277095; cv=none; b=B4LHPBYhjeT8S/+XvjvDbyLb1Bp3Q+dcCbAk+hpOH1jkU/4PdmwnSIOL+GcrOy4HtF5NdvycTTTzaaW6WTq70mL6LPo83XnNXjUfgFa87E3TYugUa497akfaghLuDvI/MfuxYQQpTl44vQPAslPdDkahgBz64sIsKKf2gfy53fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277095; c=relaxed/simple;
	bh=1BIQ0L+q98Bi1XEPRRxFUNY/9L6b139P8tA7cGgrmcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fn5+nRt1J5UiE6SDDnxlMDrxGVWRWEgDneyS762iqlVui/PXAG02OJ+XZT2vnIMGExjxmAe91ryexk34uBRmEFcRc50ZosiERNA1yH5rd9yFh+TbHW4MRQQ2+Nez1qu05xQmPAej0C0/sl9GKKB3vlpjxQPp5ZdARFhDgLXAAIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4LmGgIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4LmGgIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49846C4CEF7;
	Mon, 23 Mar 2026 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277095;
	bh=1BIQ0L+q98Bi1XEPRRxFUNY/9L6b139P8tA7cGgrmcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4LmGgIWErE+TV9DUlGEU5O7D8POvNOKCo4araGtKKuWKuatOXRI70hY4yOALXK+J
	 K9HFWPtgjMublZ2MxI0vpe9yVZFZLbDYc2iCeQ613evcu+uTGc3y7jKjWjjchI+lIG
	 +niIHRu1lR45sNC+RK8tEV15z5SsoooYydNLb+NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 318/460] Bluetooth: L2CAP: Validate L2CAP_INFO_RSP payload length before access
Date: Mon, 23 Mar 2026 14:45:14 +0100
Message-ID: <20260323134534.317849855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Johannes Möller <research@johannes-moeller.dev>

commit dd815e6e3918dc75a49aaabac36e4f024d675101 upstream.

l2cap_information_rsp() checks that cmd_len covers the fixed
l2cap_info_rsp header (type + result, 4 bytes) but then reads
rsp->data without verifying that the payload is present:

 - L2CAP_IT_FEAT_MASK calls get_unaligned_le32(rsp->data), which reads
   4 bytes past the header (needs cmd_len >= 8).

 - L2CAP_IT_FIXED_CHAN reads rsp->data[0], 1 byte past the header
   (needs cmd_len >= 5).

A truncated L2CAP_INFO_RSP with result == L2CAP_IR_SUCCESS triggers an
out-of-bounds read of adjacent skb data.

Guard each data access with the required payload length check.  If the
payload is too short, skip the read and let the state machine complete
with safe defaults (feat_mask and remote_fixed_chan remain zero from
kzalloc), so the info timer cleanup and l2cap_conn_start() still run
and the connection is not stalled.

Fixes: 4e8402a3f884 ("[Bluetooth] Retrieve L2CAP features mask on connection setup")
Cc: stable@vger.kernel.org
Signed-off-by: Lukas Johannes Möller <research@johannes-moeller.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4587,7 +4587,8 @@ static inline int l2cap_information_rsp(
 
 	switch (type) {
 	case L2CAP_IT_FEAT_MASK:
-		conn->feat_mask = get_unaligned_le32(rsp->data);
+		if (cmd_len >= sizeof(*rsp) + sizeof(u32))
+			conn->feat_mask = get_unaligned_le32(rsp->data);
 
 		if (conn->feat_mask & L2CAP_FEAT_FIXED_CHAN) {
 			struct l2cap_info_req req;
@@ -4606,7 +4607,8 @@ static inline int l2cap_information_rsp(
 		break;
 
 	case L2CAP_IT_FIXED_CHAN:
-		conn->remote_fixed_chan = rsp->data[0];
+		if (cmd_len >= sizeof(*rsp) + sizeof(rsp->data[0]))
+			conn->remote_fixed_chan = rsp->data[0];
 		conn->info_state |= L2CAP_INFO_FEAT_MASK_REQ_DONE;
 		conn->info_ident = 0;
 


