Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA203D45CB;
	Tue, 16 Jun 2026 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633362; cv=none; b=QlMQPFwdKYj8pbKOvdpgNSbTFoK6HnMQM+HUqqHrV4JtnKkPfKYixqPGVAzqEnVcl9WikzPhC2L/IoVGxCjN3na/luKglk+C99p32VnDD5HjZXrbqiSDEUFMosBYt2puHbJk7GHPZhCL40DOz3gjDBM2Ek2NQs3Gv4deel4AkbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633362; c=relaxed/simple;
	bh=dZnzTCWxKdZc0yZFtg/Qs2doMIzDX58Qb1rgKyvCqTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4vu1C2mrAZmy1NU7Z9vIvn1UkSSlNBVdiA+PEFBGlrssDdawsO0kiKvAk0bzR24sKGbCtKM2oUTNUoyTcV1avCtNuNjM26HeVC2ozG3SN8yKnX396FwvalX9iweirEX+ylgIHsaP2hrBjqsUOMIctFjiNmyeUfE9737ZxdL1K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOOoNIny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOOoNIny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E231F00A3F;
	Tue, 16 Jun 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633361;
	bh=K+qubTohgYifyF5h7IUe58Vv3c+VEBsvW9jvkIOHk2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOOoNInyDy/3hnFsy35PoNiLrj4He9YsSc2SNiNuqn0Kq6CwcfQ+p6lqsZksBXiAT
	 /8D5dHZs2tpN6zxcqblleKjDS4jyH1hqFYsMdifZ1xV4EBtisFk1lcwiGdagHNX7aG
	 p1CCU3EF0kO7+zaeUI/OK2LK6ij02K1tkzhLdlC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 065/411] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Tue, 16 Jun 2026 20:25:03 +0530
Message-ID: <20260616145103.734693502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 9dbd84990394c51f5cee1e8871bb5ff8af5ed939 upstream.

__set_chan_timer() takes a l2cap_chan reference via l2cap_chan_hold()
before scheduling the delayed work.  The normal path in
l2cap_chan_timeout() drops this reference with l2cap_chan_put() at the
end, but the early return when chan->conn is NULL skips the put,
leaking the reference.

Add the missing l2cap_chan_put() before the early return.

Fixes: adf0398cee86 ("Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -435,8 +435,10 @@ static void l2cap_chan_timeout(struct wo
 
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
-	if (!conn)
+	if (!conn) {
+		l2cap_chan_put(chan);
 		return;
+	}
 
 	mutex_lock(&conn->chan_lock);
 	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling


